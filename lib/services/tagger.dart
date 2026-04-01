/// Universal audio tag writer — MP4/M4A container + MP3 ID3v2
/// Pure Dart, no dependencies.
///
/// Critical fix: MP4 atom type names are 4 bytes of latin-1.
/// The © symbol is 0xA9 — one byte. utf8.encode('©') gives 0xC2 0xA9 — two bytes.
/// That corrupts the atom name (©nam becomes Â©na, etc.) and players ignore the tag.
/// Fix: write atom type via codeUnitAt(i) & 0xFF — latin-1 encoding.
/// BY AI
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

// ─── Public API ───────────────────────────────────────────────────────────────

class AudioTags {
  final String? title;
  final String? artist;
  final String? albumArtist;
  final String? album;
  final String? year;
  final String? genre;
  final String? comment;
  final int? trackNumber;
  final int? trackTotal;
  final int? discNumber;
  final int? discTotal;
  final Uint8List? coverData;
  final String coverMime;

  const AudioTags({
    this.title,
    this.artist,
    this.albumArtist,
    this.album,
    this.year,
    this.genre,
    this.comment,
    this.trackNumber,
    this.trackTotal,
    this.discNumber,
    this.discTotal,
    this.coverData,
    this.coverMime = 'image/jpeg',
  });
}

enum _Format { mp4, mp3, unknown }

// ─── Writer ───────────────────────────────────────────────────────────────────

class AudioTagger {
  static Future<void> writeToFile(String path, AudioTags tags) async {
    final file = File(path);
    if (!await file.exists()) throw FileSystemException('File not found', path);

    final src = await file.readAsBytes();
    final fmt = _detect(src);

    final Uint8List result;
    switch (fmt) {
      case _Format.mp4:
        result = Mp4Tagger.write(src, tags);
      case _Format.mp3:
        result = Id3Tagger.write(src, tags);
      case _Format.unknown:
        throw UnsupportedError('Unsupported audio format: $path');
    }

    await _atomicWrite(file, result);
  }

  static _Format _detect(Uint8List src) {
    if (src.length >= 8) {
      final t = String.fromCharCodes(src.sublist(4, 8));
      if (t == 'ftyp' || t == 'moov' || t == 'mdat' || t == 'free' || t == 'wide') {
        return _Format.mp4;
      }
    }
    if (src.length >= 3) {
      if (src[0] == 0x49 && src[1] == 0x44 && src[2] == 0x33) return _Format.mp3;
      if (src[0] == 0xFF && (src[1] & 0xE0) == 0xE0) return _Format.mp3;
    }
    return _Format.unknown;
  }
}

Future<void> _atomicWrite(File file, Uint8List data) async {
  final tmp = File('${file.path}.tagtmp');
  await tmp.writeAsBytes(data, flush: true);
  await tmp.rename(file.path);
}

// ─── Byte helpers ─────────────────────────────────────────────────────────────

Uint8List _concat(List<Uint8List> parts) {
  final total = parts.fold<int>(0, (s, p) => s + p.length);
  final out = Uint8List(total);
  int pos = 0;
  for (final p in parts) {
    out.setAll(pos, p);
    pos += p.length;
  }
  return out;
}

/// Build an MP4 box with 8-byte header.
/// CRITICAL: atom type is 4 bytes of latin-1.
/// © = U+00A9 = 0xA9 (one byte). utf8.encode gives 0xC2,0xA9 (two bytes) — WRONG.
/// Solution: write each char as codeUnitAt(i) & 0xFF — latin-1, not UTF-8.
Uint8List _box(String type, Uint8List payload) {
  assert(type.length == 4, 'Atom type must be exactly 4 chars: "$type"');
  final size = 8 + payload.length;
  final out = Uint8List(size);
  final bd = ByteData.sublistView(out);
  bd.setUint32(0, size);
  // latin-1 encoding: each char -> its low byte
  out[4] = type.codeUnitAt(0) & 0xFF;
  out[5] = type.codeUnitAt(1) & 0xFF;
  out[6] = type.codeUnitAt(2) & 0xFF;
  out[7] = type.codeUnitAt(3) & 0xFF;
  out.setAll(8, payload);
  return out;
}

/// iTunes data box: [size][data][flags 4B][locale 4B][value]
Uint8List _dataBox(Uint8List value, int flags) {
  final size = 16 + value.length;
  final out = Uint8List(size);
  final bd = ByteData.sublistView(out);
  bd.setUint32(0, size);
  out.setAll(4, ascii.encode('data'));
  bd.setUint32(8, flags);
  bd.setUint32(12, 0);
  out.setAll(16, value);
  return out;
}

// ─── MP4 atom parser ──────────────────────────────────────────────────────────

class _Atom {
  final int offset;
  final int size;
  final String type; // latin-1 string

  _Atom(this.offset, this.size, this.type);
  int get end => offset + size;
  int get dataOffset => offset + 8;
}

/// Read atom type as latin-1 — same encoding as _box() writes.
String _readType(Uint8List bytes, int pos) =>
    String.fromCharCodes(bytes.sublist(pos + 4, pos + 8));

List<_Atom> _parseAtoms(Uint8List bytes, int start, int end) {
  final result = <_Atom>[];
  final bd = ByteData.sublistView(bytes);
  int pos = start;
  while (pos + 8 <= end) {
    final size = bd.getUint32(pos);
    if (size < 8 || pos + size > end) break;
    result.add(_Atom(pos, size, _readType(bytes, pos)));
    pos += size;
  }
  return result;
}

_Atom? _findAtom(List<_Atom> atoms, String type) {
  for (final a in atoms) {
    if (a.type == type) return a;
  }
  return null;
}

// ─── MP4 Tagger ───────────────────────────────────────────────────────────────

class Mp4Tagger {
  static Uint8List write(Uint8List src, AudioTags tags) {
    final topAtoms = _parseAtoms(src, 0, src.length);
    final moovAtom = _findAtom(topAtoms, 'moov')
        ?? (throw const FormatException('No moov atom found'));

    final newMoov = _rebuildMoov(src, moovAtom, tags);
    final delta = newMoov.length - moovAtom.size;

    final result = _concat([
      src.sublist(0, moovAtom.offset),
      newMoov,
      src.sublist(moovAtom.end),
    ]);

    // Fix absolute chunk offsets in stco/co64 — they shift when moov grows
    return delta != 0
        ? _fixChunkOffsets(result, moovAtom.offset, moovAtom.offset + newMoov.length, delta)
        : result;
  }

  static Uint8List _rebuildMoov(Uint8List src, _Atom moovAtom, AudioTags tags) {
    final children = _parseAtoms(src, moovAtom.dataOffset, moovAtom.end);

    // meta box layout: [version+flags: 4 bytes][hdlr][ilst]
    final newMeta = _box('meta', _concat([
      Uint8List(4),      // version=0, flags=0x000000
      _buildHdlr(),
      _buildIlst(tags),
    ]));
    final newUdta = _box('udta', newMeta);

    final payload = <Uint8List>[];
    bool hadUdta = false;
    for (final child in children) {
      if (child.type == 'udta') {
        payload.add(newUdta);
        hadUdta = true;
      } else {
        payload.add(src.sublist(child.offset, child.end));
      }
    }
    if (!hadUdta) payload.add(newUdta);

    return _box('moov', _concat(payload));
  }

  static Uint8List _fixChunkOffsets(
      Uint8List bytes, int moovStart, int moovEnd, int delta) {
    final out = Uint8List.fromList(bytes);
    final bd = ByteData.sublistView(out);
    _walkFix(out, bd, moovStart, moovEnd, delta);
    return out;
  }

  static void _walkFix(Uint8List out, ByteData bd, int start, int end, int delta) {
    int pos = start;
    while (pos + 8 <= end) {
      final size = bd.getUint32(pos);
      if (size < 8 || pos + size > end) break;
      final type = _readType(out, pos);
      switch (type) {
        case 'stco':
          final count = bd.getUint32(pos + 12);
          for (int i = 0; i < count; i++) {
            final idx = pos + 16 + i * 4;
            bd.setUint32(idx, bd.getUint32(idx) + delta);
          }
        case 'co64':
          final count = bd.getUint32(pos + 12);
          for (int i = 0; i < count; i++) {
            final idx = pos + 16 + i * 8;
            bd.setUint64(idx, bd.getUint64(idx) + delta);
          }
        case 'moov':
        case 'trak':
        case 'mdia':
        case 'minf':
        case 'stbl':
          _walkFix(out, bd, pos + 8, pos + size, delta);
      }
      pos += size;
    }
  }

  // ── ilst builder ─────────────────────────────────────────────────────────

  static Uint8List _buildIlst(AudioTags tags) {
    final atoms = <Uint8List>[];

    // flags=1 means UTF-8 text (iTunes well-known type)
    void text(String name, String? v) {
      if (v == null || v.isEmpty) return;
      atoms.add(_box(name, _dataBox(Uint8List.fromList(utf8.encode(v)), 1)));
    }

    // Atom names with © use latin-1: © = 0xA9, handled correctly by _box()
    text('\u00a9nam', tags.title);        // ©nam  title
    text('\u00a9ART', tags.artist);       // ©ART  artist
    text('aART',      tags.albumArtist);  // aART  album artist
    text('\u00a9alb', tags.album);        // ©alb  album
    text('\u00a9day', tags.year);         // ©day  year
    text('\u00a9gen', tags.genre);        // ©gen  genre
    text('\u00a9cmt', tags.comment);      // ©cmt  comment

    // Track: binary [0,0, num_hi, num_lo, total_hi, total_lo, 0, 0], flags=0
    if (tags.trackNumber != null) {
      atoms.add(_box('trkn',
          _dataBox(_packIdx(tags.trackNumber!, tags.trackTotal ?? 0), 0)));
    }
    if (tags.discNumber != null) {
      atoms.add(_box('disk',
          _dataBox(_packIdx(tags.discNumber!, tags.discTotal ?? 0), 0)));
    }

    // Cover: flags=13 (JPEG) or 14 (PNG)
    if (tags.coverData != null) {
      final flags = tags.coverMime == 'image/png' ? 14 : 13;
      atoms.add(_box('covr', _dataBox(tags.coverData!, flags)));
    }

    return _box('ilst', _concat(atoms));
  }

  static Uint8List _packIdx(int num, int total) {
    final b = Uint8List(8);
    b[2] = (num >> 8) & 0xFF;
    b[3] = num & 0xFF;
    b[4] = (total >> 8) & 0xFF;
    b[5] = total & 0xFF;
    return b;
  }

  // Minimal hdlr needed inside meta: handler_type = 'mdir'
  static Uint8List _buildHdlr() {
    // [version+flags 4B][pre_defined 4B][handler_type 4B][reserved 12B][name 1B]
    final p = Uint8List(4 + 4 + 12 + 1);
    // handler_type at offset 4: 'mdir' — all ASCII, safe to write directly
    p[4] = 0x6D; p[5] = 0x64; p[6] = 0x69; p[7] = 0x72; // 'mdir'
    return _box('hdlr', p);
  }
}

// ─── MP3 / ID3v2.3 Tagger ────────────────────────────────────────────────────

class Id3Tagger {
  static Uint8List write(Uint8List src, AudioTags tags) {
    final audio = _strip(src);
    final frames = <Uint8List>[];

    void text(String id, String? v) {
      if (v == null || v.isEmpty) return;
      frames.add(_textFrame(id, v));
    }

    text('TIT2', tags.title);
    text('TPE1', tags.artist);
    text('TPE2', tags.albumArtist);
    text('TALB', tags.album);
    text('TYER', tags.year);
    text('TCON', tags.genre);

    if (tags.comment != null && tags.comment!.isNotEmpty) {
      frames.add(_commFrame(tags.comment!));
    }
    if (tags.trackNumber != null) {
      final v = tags.trackTotal != null
          ? '${tags.trackNumber}/${tags.trackTotal}'
          : '${tags.trackNumber}';
      frames.add(_textFrame('TRCK', v));
    }
    if (tags.discNumber != null) {
      final v = tags.discTotal != null
          ? '${tags.discNumber}/${tags.discTotal}'
          : '${tags.discNumber}';
      frames.add(_textFrame('TPOS', v));
    }
    if (tags.coverData != null) {
      frames.add(_apicFrame(tags.coverData!, tags.coverMime));
    }

    return _concat([_buildTag(frames), audio]);
  }

  static Uint8List _strip(Uint8List src) {
    if (src.length < 10) return src;
    if (src[0] != 0x49 || src[1] != 0x44 || src[2] != 0x33) return src;
    // Syncsafe integer: 4 × 7 bits
    final size =
        (src[6] << 21) | (src[7] << 14) | (src[8] << 7) | src[9];
    final skip = 10 + size;
    return skip < src.length ? src.sublist(skip) : Uint8List(0);
  }

  static Uint8List _buildTag(List<Uint8List> frames) {
    final payload = _concat(frames);
    // Pad to next 512-byte boundary so future tag edits don't rewrite the whole file
    final padLen = 512 - (payload.length % 512);
    final body = _concat([payload, Uint8List(padLen)]);

    final hdr = Uint8List(10);
    hdr[0] = 0x49; hdr[1] = 0x44; hdr[2] = 0x33; // 'ID3'
    hdr[3] = 0x03; hdr[4] = 0x00;                 // version 2.3.0
    hdr[5] = 0x00;                                  // flags: none
    // Syncsafe size
    final len = body.length;
    hdr[6] = (len >> 21) & 0x7F;
    hdr[7] = (len >> 14) & 0x7F;
    hdr[8] = (len >> 7) & 0x7F;
    hdr[9] = len & 0x7F;
    return _concat([hdr, body]);
  }

  // Text frame: [encoding=UTF-8 (0x03)][utf8 text]
  static Uint8List _textFrame(String id, String value) {
    return _frame(id, _concat([
      Uint8List.fromList([0x03]),
      Uint8List.fromList(utf8.encode(value)),
    ]));
  }

  // COMM frame: [encoding][lang 'eng'][description null][text]
  static Uint8List _commFrame(String text) {
    return _frame('COMM', _concat([
      Uint8List.fromList([0x03]),
      ascii.encode('eng'),
      Uint8List.fromList([0x00]),
      Uint8List.fromList(utf8.encode(text)),
    ]));
  }

  // APIC frame: [encoding][mime null][pic_type=3 Cover][description null][data]
  static Uint8List _apicFrame(Uint8List img, String mime) {
    return _frame('APIC', _concat([
      Uint8List.fromList([0x03]),
      Uint8List.fromList(ascii.encode(mime)),
      Uint8List.fromList([0x00]),
      Uint8List.fromList([0x03]),
      Uint8List.fromList([0x00]),
      img,
    ]));
  }

  // ID3v2.3 frame: [id 4B][size 4B big-endian non-syncsafe][flags 2B][data]
  static Uint8List _frame(String id, Uint8List data) {
    final out = Uint8List(10 + data.length);
    final bd = ByteData.sublistView(out);
    out.setAll(0, ascii.encode(id)); // frame IDs are always ASCII
    bd.setUint32(4, data.length);    // non-syncsafe in v2.3
    // flags = 0x0000
    out.setAll(10, data);
    return out;
  }
}

// ─── CLI ─────────────────────────────────────────────────────────────────────

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart audio_tagger.dart <file> [options]');
    print('Options:');
    print('  --title   "Track title"');
    print('  --artist  "Artist"');
    print('  --album   "Album"');
    print('  --year    "2024"');
    print('  --track   "3/12"');
    print('  --cover   cover.jpg');
    return;
  }

  final path = args[0];
  String? title, artist, album, year, coverPath;
  int? trackNum, trackTotal;

  for (var i = 1; i + 1 < args.length; i += 2) {
    switch (args[i]) {
      case '--title':  title  = args[i + 1];
      case '--artist': artist = args[i + 1];
      case '--album':  album  = args[i + 1];
      case '--year':   year   = args[i + 1];
      case '--cover':  coverPath = args[i + 1];
      case '--track':
        final p = args[i + 1].split('/');
        trackNum = int.tryParse(p[0]);
        if (p.length > 1) trackTotal = int.tryParse(p[1]);
    }
  }

  Uint8List? coverData;
  String coverMime = 'image/jpeg';
  if (coverPath != null) {
    final f = File(coverPath);
    if (await f.exists()) {
      coverData = await f.readAsBytes();
      if (coverPath.toLowerCase().endsWith('.png')) coverMime = 'image/png';
    } else {
      stderr.writeln('Warning: cover not found: $coverPath');
    }
  }

  try {
    await AudioTagger.writeToFile(path, AudioTags(
      title: title,
      artist: artist,
      album: album,
      year: year,
      trackNumber: trackNum,
      trackTotal: trackTotal,
      coverData: coverData,
      coverMime: coverMime,
    ));
    print('Done: $path');
  } catch (e) {
    stderr.writeln('Error: $e');
    exit(1);
  }
}