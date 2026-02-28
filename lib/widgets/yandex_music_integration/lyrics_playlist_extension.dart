import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import '/widgets/state_indicator.dart';
import 'package:quark/objects/track.dart';
import 'package:quark/services/player/player.dart';
import 'package:quark/services/cached_images.dart';
import 'package:quark/services/yandex_music_singleton.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';

class LyricsView extends StatefulWidget {
  final Function(StateIndicatorOperation operation) showOperation;
  final VoidCallback closePlaylist;
  final Track track;

  const LyricsView({
    super.key,
    required this.showOperation,
    required this.closePlaylist,
    required this.track,
  });

  @override
  State<LyricsView> createState() => _TrackInfoView();
}

class _TrackInfoView extends State<LyricsView> {
  ScrollController scrollController = ScrollController();
  List<Map<Duration, String>> mapWithTimestampAndText = [];

  bool hasLyrics = true;
  bool loading = true;
  bool wts = false;
  bool seek = true;

  int nowIndex = 0;

  void getLyrics() async {
    if (widget.track.lyricsInfo == null ||
        (!widget.track.lyricsInfo!.hasAvailableSyncLyrics &&
            !widget.track.lyricsInfo!.hasAvailableTextLyrics)) {
      setState(() {
        hasLyrics = false;
        loading = false;
      });

      return;
    }
    Logger('LyricsView').info('Requesting lyrics');
    if (widget.track.lyricsInfo!.hasAvailableSyncLyrics) {
      final lyrics = await YandexMusicSingleton.instance.tracks.getLyrics(
        widget.track.id,
        format: LyricsFormat.withTimeStamp,
      );
      extractLyricsWTS(lyrics.downloadUrl);
    }
    if (widget.track.lyricsInfo!.hasAvailableTextLyrics &&
        !widget.track.lyricsInfo!.hasAvailableSyncLyrics) {
      final lyrics = await YandexMusicSingleton.instance.tracks.getLyrics(
        widget.track.id,
        format: LyricsFormat.onlyText,
      );
      extractLyricsOT(lyrics.downloadUrl);
    }
    setState(() {
      loading = false;
    });
  }

  void extractLyricsWTS(String link) async {
    final res = await Dio().get(link);

    final List<String> words = res.data.toString().split('\n');
    final List<Map<Duration, String>> nowStatedMapWithTimestampWithText = [];
    for (String word in words) {
      final word2 = word.split(' ');
      final timestamp = word2.first;
      word2.remove(timestamp);
      final words = word2.join(' ');

      final clean = timestamp.replaceAll(RegExp(r'[\[\]]'), '').split(':');
      if (clean.length > 1) {
        final mins = clean[0];
        final secs = clean[1].split('.').first;
        final millis = clean[1].split('.').last;

        final Duration duraton = Duration(
          minutes: int.parse(mins),
          seconds: int.parse(secs),
          milliseconds: int.parse(millis),
        );

        nowStatedMapWithTimestampWithText.add({duraton: words});
      }
    }
    if (nowStatedMapWithTimestampWithText.first.entries.first.key !=
        Duration(seconds: 0)) {
      nowStatedMapWithTimestampWithText.insert(0, {
        Duration(milliseconds: 0): '',
      });
    }

    if (!mounted) return;
    setState(() {
      wts = true;
      mapWithTimestampAndText = nowStatedMapWithTimestampWithText;
    });
  }

  void extractLyricsOT(String link) async {
    final res = await Dio().get(link);
    final List<String> words = res.data.toString().split('\n');
    final List<Map<Duration, String>> result = [];
    for (String word in words) {
      result.add({Duration.zero: word});
    }
    result.insert(0, {Duration(milliseconds: 0): ''});
    setState(() {
      mapWithTimestampAndText = result;
    });
  }

  @override
  void initState() {
    getLyrics();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity!.abs() > 500) {
            widget.closePlaylist();
          }
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
            child: Container(
              width: 400,
              height: MediaQuery.of(context).size.height,
              decoration: overlayBoxDecoration(),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 0),
                child: Stack(
                  children: [
                    if (loading) ...[
                      Center(
                        child: Text(
                          'Processing your request...',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    if (!hasLyrics) ...[
                      Center(
                        child: Text(
                          'It looks like this track has no lyrics',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    // TrackInfo(track: Player.player.nowPlayingTrack),
                    if (!loading && hasLyrics)
                      SizedBox.expand(
                        child: LyricsList(
                          lyrics: mapWithTimestampAndText,
                          sync: widget.track.lyricsInfo!.hasAvailableSyncLyrics,
                        ),
                      ),

                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: appBar(widget.closePlaylist, () {}, () {}),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class TrackInfo extends StatefulWidget {
//   final PlayerTrack track;
//   const TrackInfo({super.key, required this.track});
//   @override
//   State<StatefulWidget> createState() => _TrackInfo();
// }

// class _TrackInfo extends State<TrackInfo> {
//   PlayerTrack get track => widget.track;

//   AudioMetadata? data;

//   @override
//   void initState() {
//     if (track is LocalTrack) {

//     }

//     super.initState();
//   }

//   Widget _buildLocalTrackInfo() {


//     return Column(children: [

//       ],
//     );
//   }

//   Widget _recognizedTrack() {
//     final matched = (track as YandexMusicTrack).track.matchedTrack!;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.07),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.12)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//             child: Row(
//               children: [
//                 const SizedBox(width: 6),
//                 Text(
//                   'Matched track',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: Row(
//               children: [
//                 if (matched.coverUri != null)
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: CachedImage(
//                       coverUri: matched.coverUri!,
//                       height: 64,
//                       width: 64,
//                     ),
//                   ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         matched.title,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         matched.artists.map((e) => e.title).join(', '),
//                         style: TextStyle(color: Colors.white54, fontSize: 13),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       if (matched.albums.isNotEmpty) ...[
//                         const SizedBox(height: 2),
//                         Text(
//                           matched.albums.first.title,
//                           style: TextStyle(color: Colors.white38, fontSize: 12),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _yandexHeader() {
//     return Center(
//       child: Material(
//         color: Colors.transparent,
//         child: Column(
//           children: [
//             if ((track as YandexMusicTrack).track.trackSource !=
//                 TrackSource.UGC) ...[
//               if ((track as YandexMusicTrack).track.albums.isNotEmpty) ...[
//                 SizedBox(height: 10),
//                 Text(
//                   'Album',
//                   style: TextStyle(
//                     color: Colors.white.withAlpha(100),
//                     fontFamily: 'noto',
//                     fontSize: 14,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 CachedImage(
//                   coverUri:
//                       'https://${(track as YandexMusicTrack).track.albums[0].coverUri.replaceAll('%%', "300x300")}',
//                   height: 180,
//                   width: 180,
//                   borderRadius: 12,
//                 ),

//                 SizedBox(height: 5),
//                 Text(
//                   '${(track as YandexMusicTrack).track.albums[0].title} (${(track as YandexMusicTrack).track.albums[0].year})',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontFamily: 'noto',
//                     decoration: TextDecoration.none,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 Text(
//                   '${(track as YandexMusicTrack).track.albums[0].trackCount} tracks. ${(track as YandexMusicTrack).track.albums[0].likesCount} likes',
//                   style: TextStyle(
//                     color: Colors.white.withAlpha(200),
//                     fontFamily: 'noto',
//                     fontWeight: FontWeight.w100,
//                     fontSize: 14,
//                   ),
//                 ),
//                 Text(
//                   (track as YandexMusicTrack).track.albums[0].artists
//                       .map((e) => e.title)
//                       .join(', '),
//                   style: TextStyle(
//                     color: Colors.white.withAlpha(200),
//                     fontFamily: 'noto',
//                     fontWeight: FontWeight.w100,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildYMTrackInfo() {
//     return Column(
//       children: [
//         _yandexHeader(),
//         if ((track as YandexMusicTrack).track.trackSource ==
//             TrackSource.UGC) ...[
//           SizedBox(height: 10),
//           Text(
//             'Track uploaded by user',
//             style: TextStyle(
//               color: Colors.white.withAlpha(100),
//               fontFamily: 'noto',
//               fontSize: 14,
//             ),
//           ),
//           SizedBox(height: 10),
//           CachedImage(
//             coverUri: track.cover,
//             height: 180,
//             width: 180,
//             borderRadius: 12,
//           ),
//           SizedBox(height: 10),
//           Text(
//             (track as YandexMusicTrack).track.title,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'noto',
//               decoration: TextDecoration.none,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           Text(
//             track.artists.join(', '),
//             style: TextStyle(
//               color: const Color.fromARGB(200, 255, 255, 255),
//               fontSize: 15,
//               fontFamily: 'noto',
//               decoration: TextDecoration.none,
//               fontWeight: FontWeight.w100,
//             ),
//           ),

//           SizedBox(height: 15),
//           if ((track as YandexMusicTrack).track.matchedTrack != null) ...[
//             Text(
//               'Matched Track',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'noto',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             _recognizedTrack(),
//           ],
//         ],
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return (track is YandexMusicTrack)
//         ? _buildYMTrackInfo()
//         : _buildLocalTrackInfo();
//   }
// }

class LyricsList extends StatefulWidget {
  final bool sync;
  final List<Map<Duration, String>> lyrics;
  const LyricsList({super.key, required this.lyrics, this.sync = true});
  @override
  State<StatefulWidget> createState() => _LyricsList();
}

class _LyricsList extends State<LyricsList> {
  late VoidCallback listener;

  ScrollController scrollController = ScrollController();
  List<Map<Duration, String>> get lyrics => widget.lyrics;
  bool get sync => widget.sync;
  int nowIndex = 0;

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void initState() {
    listener = () {
      if (!mounted) return;
      final int index = getNearby(
        lyrics.map((e) => e.entries.first.key).toList(),
        Player.player.playedNotifier.value,
      );
      if (index != nowIndex) {
        scrollToNow(index);
      }

      setState(() {
        nowIndex = index;
      });
      setState(() {});
    };
    if (sync) {
      Player.player.playedNotifier.addListener(listener);
    }
    super.initState();
  }

  @override
  void activate() {
    if (sync) {
      Player.player.playedNotifier.addListener(listener);
    }
    super.activate();
  }

  @override
  void deactivate() {
    Player.player.playedNotifier.removeListener(listener);
    super.deactivate();
  }

  int getNearby(List<Duration> timestamps, Duration current) {
    if (timestamps.isEmpty) return 1;

    int nearest = 0;

    for (int i = 0; i < timestamps.length; i++) {
      if (timestamps[i] > current) break;
      nearest = i;
    }

    const double threshold = 0.99;

    if (nearest + 1 < timestamps.length) {
      final currentTs = timestamps[nearest];
      final nextTs = timestamps[nearest + 1];
      final gap = (nextTs - currentTs).inMilliseconds;
      final passed = (current - currentTs).inMilliseconds;

      if (gap > 0 && passed / gap >= threshold) {
        return nearest + 1;
      }
    }

    return nearest;
  }

  void scrollToNow(int index) {
    if (!scrollController.hasClients || lyrics.isEmpty || !sync) return;

    final padding = MediaQuery.of(context).size.height / 2;
    final totalHeight =
        scrollController.position.maxScrollExtent +
        scrollController.position.viewportDimension -
        padding * 2;

    final averageItemHeight = totalHeight / lyrics.length;
    final targetPosition = padding + index * averageItemHeight;
    final screenHeight = scrollController.position.viewportDimension;
    final offset =
        targetPosition - (screenHeight / 2) + (averageItemHeight / 2);

    scrollController.animateTo(
      offset.clamp(0.0, scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOutQuint,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (lyrics.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 2,
      ),
      itemCount: lyrics.length,
      itemBuilder: (BuildContext context, int index) {
        if (lyrics[index].entries.last.value == '') {
          return InkWell(
            onTap: () async {
              await Player.player.seek(lyrics[index].entries.first.key);
            },
            child: Icon(
              Icons.music_note,
              size: index == nowIndex ? 35 : 20,
              color: index == nowIndex ? Colors.white : Colors.grey,
            ),
          );
        }
        return InkWell(
          onTap: () async {
            await Player.player.seek(lyrics[index].entries.first.key);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AnimatedContainer(
              padding: index == nowIndex
                  ? EdgeInsets.symmetric(vertical: 20, horizontal: 25)
                  : EdgeInsets.symmetric(vertical: 4, horizontal: 25),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOutQuint,
              child: Transform.scale(
                scale: index == nowIndex ? 1.2 : 0.9,
                child: Text(
                  lyrics[index].entries.last.value,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  maxLines: null,
                  softWrap: true,
                  style: TextStyle(
                    color: index == nowIndex ? Colors.white : Colors.grey,
                    fontWeight: index == nowIndex
                        ? FontWeight.w900
                        : FontWeight.w400,
                    fontSize: index == nowIndex ? 18 : 16,

                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget appBar(
  Function() togglePlaylist,
  Function() refreshPlaylist,
  Function() search,
) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          color: Color.fromARGB(15, 255, 255, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if ((Player.player.nowPlayingTrack as YandexMusicTrack)
                      .track
                      .lyricsInfo !=
                  null)
                Text(
                  (Player.player.nowPlayingTrack as YandexMusicTrack)
                          .track
                          .lyricsInfo!
                          .hasAvailableSyncLyrics
                      ? "Synced lyrics"
                      : (Player.player.nowPlayingTrack as YandexMusicTrack)
                            .track
                            .lyricsInfo!
                            .hasAvailableTextLyrics
                      ? "No synced lyrics"
                      : "No lyrics",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: 'noto',
                  ),
                ),
              if ((Player.player.nowPlayingTrack as YandexMusicTrack)
                      .track
                      .lyricsInfo ==
                  null)
                Text(
                  "No lyrics",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: 'noto',
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

BoxDecoration overlayBoxDecoration() {
  return BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
    borderRadius: const BorderRadius.only(
      topRight: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
    ),
  );
}
