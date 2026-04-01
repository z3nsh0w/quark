// A microservice for full image caching using cached_network_image library
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:image/image.dart' as img;
import 'package:quark/services/files.dart';

class ImageBlurService {
  static final ImageBlurService _instance = ImageBlurService._internal();
  factory ImageBlurService() => _instance;
  ImageBlurService._internal();
  final ImageCacheService mainService = ImageCacheService();

  Future<Uint8List?> getBlurredNetworkImage(String url) async {
    final keyOrg = mainService.getMd5(url);
    final keyBlurred = "${keyOrg}_b95";

    final blurredFile = await mainService._getImageFile(
      url,
      safeKey: keyBlurred,
    );
    if (await blurredFile.exists()) {
      return await blurredFile.readAsBytes();
    }

    final originalBytes = await ImageCacheService().getImage(url);

    final originalFile = await mainService._getImageFile(url, safeKey: keyOrg);
    if (!await originalFile.exists()) {
      await originalFile.writeAsBytes(originalBytes);
    }

    final blurredBytes = await Isolate.run(() {
      final image = img.decodeImage(originalBytes);
      if (image == null) {
        Logger(
          "ImageBlurService",
        ).warning("Failed to decode network image bytes. Url: $url");
        return null;
      }
      // Resize the image to increase speed
      final newResizedImage = img.copyResize(image, width: 150);
      final blurred = img.gaussianBlur(newResizedImage, radius: 25);
      return Uint8List.fromList(img.encodeJpg(blurred, quality: 70));
    });
    if (blurredBytes != null) {
      await blurredFile.writeAsBytes(blurredBytes);
    }
    return blurredBytes;
  }

  Future<Uint8List?> getBlurFromBytes(Uint8List url) async {
    final keyOrg = mainService.getMd5(url);
    final keyBlurred = "${keyOrg}_b95";

    final blurredFile = await mainService._getImageFile(
      'url',
      safeKey: keyBlurred,
    );
    if (await blurredFile.exists()) {
      return await blurredFile.readAsBytes();
    }

    final blurredBytes = await Isolate.run(() {
      final image = img.decodeImage(url);
      if (image == null) {
        Logger(
          "ImageBlurService",
        ).warning("Failed to decode network image bytes. Url: $url");
        return null;
      }
      // Resize the image to increase speed
      final newResizedImage = img.copyResize(image, width: 150);
      final blurred = img.gaussianBlur(newResizedImage, radius: 25);
      return Uint8List.fromList(img.encodeJpg(blurred, quality: 70));
    });
    if (blurredBytes != null) {
      await blurredFile.writeAsBytes(blurredBytes);
    }
    return blurredBytes;
  }
}

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  final Map<String, Future<Uint8List>> _cache = {};

  Future<Uint8List> getImage(String uri) {
    var future = _cache[uri];
    if (future != null) {
      return future;
    }

    final completer = Completer<Uint8List>();
    _cache[uri] = completer.future;

    _loadImage(uri)
        .then((data) {
          completer.complete(data);
        })
        .catchError((error, stackTrace) {
          completer.completeError(error, stackTrace);
        });

    return completer.future;
  }

  Future<Uint8List> _loadImage(String uri) async {
    final fileData = await _readFromDisk(uri);
    if (fileData != null) {
      return fileData;
    }

    final response = await Dio().get<Uint8List>(
      uri,
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data as Uint8List;
    await _saveToDisk(uri, bytes);

    return bytes;
  }

  Future<String> putImageBytes(String key, Uint8List bytes) async {
    if (_cache.containsKey(key)) {
      final file = await _getImageFile(key);
      return file.path;
    }

    final file = await _getImageFile(key);
    if (await file.exists()) {
      _cache[key] = Future.value(bytes);
      return file.path;
    }

    await file.writeAsBytes(bytes);
    _cache[key] = Future.value(bytes);

    return file.path;
  }

  Future<File> _getImageFile(String uri, {String? safeKey}) async {
    safeKey ??= getMd5(uri);
    final cacheDir = Directory(
      join(ApplicationCacheDirectory.instance.directory.path, 'cached_images'),
    );
    await cacheDir.create(recursive: true);
    return File(join(cacheDir.path, safeKey));
  }

  Future<String> getImagePath(String uri) async {
    final file = await _getImageFile(uri);
    return file.path;
  }

  Future<Uint8List?> _readFromDisk(String uri, {String? safeKey}) async {
    final file = await _getImageFile(uri, safeKey: safeKey);
    if (await file.exists()) {
      return await file.readAsBytes();
    }
    return null;
  }

  Future<void> _saveToDisk(String uri, Uint8List data) async {
    final file = await _getImageFile(uri);
    await file.writeAsBytes(data);
  }

  String getMd5(dynamic info) {
    return md5.convert(info is String ? utf8.encode(info) : info).toString();
  }
}

class CachedBlurredNetworkImage extends StatefulWidget {
  final String coverUri;
  final double height;
  final double width;
  final BoxFit fit;
  final int alphaChannel;
  final Color backgroundColor;
  final int alphaChannelIcon;
  final Color iconColor;
  final double borderRadius;

  const CachedBlurredNetworkImage({
    super.key,
    required this.coverUri,
    this.height = 50,
    this.width = 50,
    this.fit = BoxFit.cover,
    this.backgroundColor = Colors.grey,
    this.iconColor = Colors.white,
    this.alphaChannelIcon = 100,
    this.alphaChannel = 100,
    this.borderRadius = 0,
  });
  @override
  State<CachedBlurredNetworkImage> createState() =>
      _CachedBlurredNetworkImageState();
}

class _CachedBlurredNetworkImageState extends State<CachedBlurredNetworkImage> {
  late Future<Uint8List?> _future;

  @override
  void initState() {
    super.initState();
    _future = ImageBlurService().getBlurredNetworkImage(widget.coverUri);
  }

  @override
  void didUpdateWidget(CachedBlurredNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coverUri != widget.coverUri) {
      _future = ImageBlurService().getBlurredNetworkImage(widget.coverUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: Image.memory(snapshot.data!, fit: widget.fit),
          );
        }

        if (snapshot.hasError || widget.coverUri == "https://none" || widget.coverUri == "none" || snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor.withAlpha(widget.alphaChannel),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            width: 300,
            height: 300,
          );
        }
        return SizedBox(width: widget.width, height: widget.height);
      },
    );
  }
}

class CachedBlurredImageFromBytes extends StatefulWidget {
  final Uint8List bytes;
  final double height;
  final double width;
  final BoxFit fit;
  final int alphaChannel;
  final Color backgroundColor;
  final int alphaChannelIcon;
  final Color iconColor;
  final double borderRadius;

  const CachedBlurredImageFromBytes({
    super.key,
    required this.bytes,
    this.height = 50,
    this.width = 50,
    this.fit = BoxFit.cover,
    this.backgroundColor = Colors.grey,
    this.iconColor = Colors.white,
    this.alphaChannelIcon = 100,
    this.alphaChannel = 100,
    this.borderRadius = 0,
  });

  @override
  State<CachedBlurredImageFromBytes> createState() =>
      _CachedBlurredImageFromBytesState();
}

class _CachedBlurredImageFromBytesState
    extends State<CachedBlurredImageFromBytes> {
  late Future<Uint8List?> _future;

  @override
  void initState() {
    super.initState();
    _future = ImageBlurService().getBlurFromBytes(widget.bytes);
  }

  @override
  void didUpdateWidget(CachedBlurredImageFromBytes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.bytes, widget.bytes)) {
      _future = ImageBlurService().getBlurFromBytes(widget.bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: Image.memory(snapshot.data!, fit: widget.fit),
          );
        }
        if (snapshot.hasError || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor.withAlpha(widget.alphaChannel),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            width: 300,
            height: 300,
          );
        }
        return SizedBox(width: widget.width, height: widget.height);
      },
    );
  }
}

class CachedImage extends StatelessWidget {
  final String coverUri;
  final double height;
  final double width;
  final double borderRadius;
  final int alphaChannel;
  final Color backgroundColor;
  final int alphaChannelIcon;
  final Color iconColor;

  const CachedImage({
    super.key,
    required this.coverUri,
    this.height = 50,
    this.width = 50,
    this.borderRadius = 0,
    this.alphaChannel = 100,
    this.backgroundColor = Colors.grey,
    this.iconColor = Colors.white,
    this.alphaChannelIcon = 100,
  });

  @override
  Widget build(BuildContext context) {
    if (coverUri == 'none' || coverUri == 'https://none') {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor.withAlpha(alphaChannel),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        width: width,
        height: height,
        child: Icon(
          Symbols.music_note,
          color: iconColor.withAlpha(alphaChannelIcon),
          size: width < 100 ? 16 : 42,
        ),
      );
    }
    return FutureBuilder<Uint8List>(
      future: ImageCacheService().getImage(coverUri),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),

            child: SizedBox(
              width: width,
              height: height,
              child: Image.memory(snapshot.data!, fit: BoxFit.cover),
            ),
          );
        }
        if (snapshot.hasError) {
          return Container(
            decoration: BoxDecoration(
              color: backgroundColor.withAlpha(alphaChannel),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            width: width,
            height: height,
            child: Icon(
              Symbols.music_note,
              color: iconColor.withAlpha(alphaChannelIcon),
              size: width < 100 ? 16 : 42,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: width * 0.9,
            height: width * 0.9,
            child: CircularProgressIndicator(
              color: const Color.fromARGB(100, 255, 255, 255),
            ),
          );
        }

        return SizedBox(width: width, height: height);
      },
    );
  }
}

class CachedImageProvider extends ImageProvider<CachedImageProvider> {
  const CachedImageProvider(this.url, {this.scale = 1.0});

  final String url;
  final double scale;

  @override
  Future<CachedImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CachedImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    CachedImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<CachedImageProvider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    CachedImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);
    final Uint8List bytes = await ImageCacheService().getImage(key.url);

    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
      bytes,
    );

    return decode(buffer);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CachedImageProvider &&
        other.url == url &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'CachedImageProvider')}("$url", scale: $scale)';
}

class CachedBlurredImageProvider
    extends ImageProvider<CachedBlurredImageProvider> {
  const CachedBlurredImageProvider(this.url, {this.scale = 1.0});

  final String url;
  final double scale;

  @override
  Future<CachedBlurredImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) {
    return SynchronousFuture<CachedBlurredImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    CachedBlurredImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<CachedBlurredImageProvider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    CachedBlurredImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);
    final Uint8List? bytes = await ImageBlurService().getBlurredNetworkImage(
      key.url,
    );

    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
      bytes!,
    );

    return decode(buffer);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CachedBlurredImageProvider &&
        other.url == url &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'CachedImageProvider')}("$url", scale: $scale)';
}

class MemoryBytesImageProvider extends ImageProvider<MemoryBytesImageProvider> {
  const MemoryBytesImageProvider(this.bytes, {this.scale = 1.0});

  final Uint8List bytes;
  final double scale;

  @override
  Future<MemoryBytesImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MemoryBytesImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    MemoryBytesImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<MemoryBytesImageProvider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    MemoryBytesImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);
    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
      key.bytes,
    );

    return decode(buffer);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MemoryBytesImageProvider &&
        other.bytes == bytes &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(bytes.hashCode, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'MemoryBytesImageProvider')}(${describeIdentity(bytes)}, scale: $scale)';
}
