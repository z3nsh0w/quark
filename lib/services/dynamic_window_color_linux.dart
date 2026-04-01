import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:quark/objects/track.dart';
import 'package:quark/services/cached_images.dart';
import 'package:quark/services/player/player.dart';
import 'package:quark/services/database/database.dart';

enum WindowSize { standart, small }

abstract class DynamicWindowColor {
  static final _channel = MethodChannel('app/window_style');
  static final Map<PlayerTrack, List<Color>> _cached = {};
  static bool _inited = false;
  static bool _paused = false;
  static List<Color> nowColor = [Colors.transparent];

  static void init() {
    if (!Platform.isLinux) {
      return;
    }
    Player.player.trackChangeNotifier.addListener(_changeColor);
    _inited = true;
  }

  static void pause() {
    _paused = true;
  }

  static void resume() {
    _paused = false;
  }

  static void updateColor() {
    _changeColor();
  }

  /// The maximum number of colors supported is 3
  static Future<void> setHeaderColor(
    List<Color> colors, {
    double? transitionSpeed,
  }) async {
    if (!DatabaseStreamerService().dynamicWindowColor.value ||
        !Platform.isLinux ||
        !_inited) {
      return;
    }
    if (listEquals(nowColor, colors)) {
      return;
    }
    // R1 G1 B1 - Left-
    // R2 G2 B2 - Center
    // R3 G3 B3 - Right
    // TODO: support for an unlimited number of colors.
    if (colors.isEmpty) {
      return;
    }
    final leftColor = colors[0];
    final centerColor = colors.length > 1 ? colors[1] : colors[0];
    final rightColor = colors.length > 2 ? colors[2] : centerColor;
    await _channel.invokeMethod('setHeaderColor', {
      'r1': leftColor.red,
      'g1': leftColor.green,
      'b1': leftColor.blue,
      'r2': centerColor.red,
      'g2': centerColor.green,
      'b2': centerColor.blue,
      'r3': rightColor.red,
      'g3': rightColor.green,
      'b3': rightColor.blue,
      'transition_speed':
          transitionSpeed ?? DatabaseStreamerService().transitionSpeed.value,
    });
    nowColor = colors;
    Logger("DWC").fine("Changed Color");
    // Logger(
    //   "DynamicWindowColor_Linux",
    // ).info("A request to change the theme color has been sent.");
  }

  static void updateTitle(String title) async {
    if (!DatabaseStreamerService().dynamicWindowColor.value ||
        !Platform.isLinux ||
        _paused ||
        !_inited) {
      return;
    }

    await _channel.invokeMethod('setHeaderTitle', {"title": title});
    Logger("DWC").fine("Sended");
  }

  static void notifySize(WindowSize size) async {
    if (!DatabaseStreamerService().dynamicWindowColor.value ||
        !Platform.isLinux ||
        _paused ||
        !_inited) {
      return;
    }

    await _channel.invokeMethod('setHeaderWidth', {
      "height": size == WindowSize.small ? 2 : 2,
    });
    Logger("DWC").fine("Sended");
  }

  static void _changeColor() async {
    if (!DatabaseStreamerService().dynamicWindowColor.value ||
        !Platform.isLinux ||
        _paused ||
        !_inited) {
      return;
    }

    final npt = Player.player.nowPlayingTrack;

    if (_cached.containsKey(npt)) {
      setHeaderColor(_cached[npt]!);
      return;
    }

    Uint8List? cover;

    if (npt is LocalTrack) {
      cover = npt.coverByted;
      if (listEquals(Uint8List(0), cover)) return;
    } else {
      try {
        cover = await ImageBlurService().getBlurredNetworkImage(
          "https://${npt.cover.replaceAll("%%", "300x300")}",
        );
      } catch (e) {}
    }
    if (cover == null) {
      final accentColor = Color.fromARGB(1, 31, 31, 31);
      setHeaderColor([accentColor]);
      return;
    }
    final color = await getAccentColorsFromRaw(cover);
    final accentColors = color.map((e) => darken(e)).toList();
    _cached.addAll({npt: accentColors});
    setHeaderColor(accentColors);
  }

  /// Darken color by 15%
  static Color darken(Color color, [double amount = 0.15]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Future<List<Color>> getAccentColorsFromRaw(
    Uint8List imageBytes,
  ) async {
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final rgbaBytes = byteData!.buffer.asUint8List();

    final int width = image.width;
    final int height = image.height;
    // What percentage will skips from the top.
    // Increases the likelihood of accurately hitting color at 850px width.
    final int skipRows = (height * 0.15).floor();
    final int startPixelIndex = skipRows * width;

    /// We divide img into 3 zones
    final int zoneWidth = (width / 3).floor();

    List<Color> result = [];

    for (int zone = 0; zone < 3; zone++) {
      int r = 0, g = 0, b = 0, a = 0;

      int start = startPixelIndex + (zone * zoneWidth);
      int end = start + zoneWidth;

      for (int i = start; i < end; i++) {
        int offset = i * 4;
        r += rgbaBytes[offset];
        g += rgbaBytes[offset + 1];
        b += rgbaBytes[offset + 2];
        a += rgbaBytes[offset + 3];
      }

      result.add(
        Color.fromARGB(
          // Taking the average value for the entire zone
          (a ~/ zoneWidth).clamp(0, 255),
          (r ~/ zoneWidth).clamp(0, 255),
          (g ~/ zoneWidth).clamp(0, 255),
          (b ~/ zoneWidth).clamp(0, 255),
        ),
      );
    }

    return result;
  }
}
