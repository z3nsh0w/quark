import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:quark/services/database/database.dart';
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

  Future<void> getLyrics() async {
    if (widget.track.lyricsInfo == null ||
        (!widget.track.lyricsInfo!.hasAvailableSyncLyrics &&
            !widget.track.lyricsInfo!.hasAvailableTextLyrics)) {
      setState(() {
        hasLyrics = false;
        loading = false;
      });
      return;
    }

    final format = widget.track.lyricsInfo!.hasAvailableSyncLyrics
        ? LyricsFormat.withTimeStamp
        : LyricsFormat.onlyText;

    final lyrics = await YandexMusicSingleton.getLyrics(
      widget.track.id,
      format,
    );

    if (!mounted) return;
    setState(() {
      if (lyrics.isNotEmpty) {
        mapWithTimestampAndText = lyrics;
        hasLyrics = true;
        wts = format == LyricsFormat.withTimeStamp;
      } else {
        hasLyrics = false;
      }
      loading = false;
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
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: Duration(
                  milliseconds:
                      (650 * DatabaseStreamerService().transitionSpeed.value)
                          .round(),
                ),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                layoutBuilder: (currentChild, previousChildren) => SizedBox(
                  width: 400,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  ),
                ),
                child: SizedBox(
                  key: ValueKey(Player.player.nowPlayingTrack.cover),
                  width: 400,
                  height: MediaQuery.of(context).size.height,
                  child: OverflowBox(
                    maxWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height,
                    alignment: Alignment.centerLeft,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                      child: CachedBlurredNetworkImage(
                        coverUri:
                            'https://${Player.player.nowPlayingTrack.cover.replaceAll('%%', '300x300')}',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
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
                            sync:
                                widget.track.lyricsInfo!.hasAvailableSyncLyrics,
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
            ],
          ),
        ),
      ),
    );
  }
}

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
  late List<Duration> _timestamps;

  // @override
  // void didChangeDependencies() {
  //   setState(() {});
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    _timestamps = lyrics.map((e) => e.entries.first.key).toList();

    listener = () {
      if (!mounted) return;
      final int index = getNearby(
        _timestamps,
        Player.player.playedNotifier.value,
      );

      if (index != nowIndex) {
        scrollToNow(index);
      }

      setState(() {
        nowIndex = index;
      });
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
