import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class _VibePainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;
  final List<List<double>> colors;
  final double bgBrightness;
  final double scale;
  final List<List<double>> rotations;

  _VibePainter({
    required this.shader,
    required this.time,
    required this.colors,
    required this.bgBrightness,
    required this.scale,
    required this.rotations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    int idx = 0;
    void setF(double v) => shader.setFloat(idx++, v);

    setF(size.width);
    setF(size.height);
    setF(time);
    setF(scale);
    setF(bgBrightness);

    for (final c in colors) {
      setF(c[0]);
      setF(c[1]);
      setF(c[2]);
    }

    for (final r in rotations) {
      setF(r[0]);
      setF(r[1]);
      setF(r[2]);
    }

    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_VibePainter old) => true;
}

class VibeWidget extends StatefulWidget {
  final double size;
  /// 0 - 360
  final double hue;
  final double speed;
  /// 0 - 1
  final double scale;

  const VibeWidget({
    super.key,
    this.size = 400,
    this.hue = 200,
    this.speed = 0.2,
    this.scale = 0.38,
  });

  @override
  State<VibeWidget> createState() => _VibeWidgetState();
}

class _VibeWidgetState extends State<VibeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ui.FragmentShader? _shader;
  bool _shaderError = false;

  late PaletteAnimator _palette;
  double _time = 0;
  DateTime _lastTick = DateTime.now();
  final List<List<double>> _rotations = [
    [-0.3, 0.3, 0.2],
    [-0.3, -0.3, -0.2],
    [-0.3, -0.3, 0.2],
  ];

  @override
  void initState() {
    super.initState();
    _palette = PaletteAnimator(baseHue: widget.hue);
    _loadShader();

    _controller =
        AnimationController(vsync: this, duration: const Duration(days: 1))
          ..addListener(_onTick)
          ..repeat();
  }

  Future<void> _loadShader() async {
    try {
      final program = await ui.FragmentProgram.fromAsset('shaders/vibe.frag');
      if (mounted) {
        setState(() => _shader = program.fragmentShader());
      }
    } catch (e) {
      debugPrint('VibeWidget: shader load error → $e');
      if (mounted) setState(() => _shaderError = true);
    }
  }

  void _onTick() {
    final now = DateTime.now();
    final dtMs = now.difference(_lastTick).inMicroseconds / 1000.0;
    _lastTick = now;

    _palette.tick(dtMs);

    final energy = widget.speed;
    _time = (_time + energy * dtMs / 1000.0) % 86400.0;

    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(VibeWidget old) {
    super.didUpdateWidget(old);
    if (old.hue != widget.hue) {
      _palette.updateColor(widget.hue, widget.hue);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_shaderError) {
      return SizedBox.square(
        dimension: widget.size,
        child: const ColoredBox(
          color: Colors.black,
          child: Center(
            child: Text('Shader error', style: TextStyle(color: Colors.red)),
          ),
        ),
      );
    }

    if (_shader == null) {
      return SizedBox.square(
        dimension: widget.size,
        child: const ColoredBox(color: Colors.transparent),
      );
    }

    return SizedBox.square(
      dimension: widget.size,
      child: CustomPaint(
        painter: _VibePainter(
          shader: _shader!,
          time: _time,
          colors: _palette.value,
          bgBrightness: 0.0,
          scale: widget.scale,
          rotations: _rotations,
        ),
      ),
    );
  }
}

class ScalarLerp {
  double currentValue;
  double targetValue;
  double elapsedTime;
  final double duration; // ms

  ScalarLerp(double initial, this.duration)
    : currentValue = initial,
      targetValue = initial,
      elapsedTime = 0;

  double get value => currentValue;

  void update(double target) {
    targetValue = target;
    elapsedTime = 0;
  }

  void tick(double dtMs) {
    final t = (elapsedTime / duration).clamp(0.0, 1.0);
    elapsedTime += dtMs;
    currentValue = currentValue + (targetValue - currentValue) * t;
  }
}

class ColorLerp {
  late ScalarLerp r, g, b;

  ColorLerp(double hue) {
    final rgb = _hslToRgb(hue, 1.0, 0.5);
    r = ScalarLerp(rgb[0], 3000);
    g = ScalarLerp(rgb[1], 3000);
    b = ScalarLerp(rgb[2], 3000);
  }

  List<double> get value => [r.value, g.value, b.value];

  void update(double hue) {
    final rgb = _hslToRgb(hue, 1.0, 0.5);
    r.update(rgb[0]);
    g.update(rgb[1]);
    b.update(rgb[2]);
  }

  void tick(double dtMs) {
    r.tick(dtMs);
    g.tick(dtMs);
    b.tick(dtMs);
  }
}

class PaletteAnimator {
  late ColorLerp topStart, topEnd;
  late ColorLerp middleStart, middleEnd;
  late ColorLerp bottomStart, bottomEnd;

  final _rand = Random();

  PaletteAnimator({double baseHue = 10}) {
    final parts = _createParts(baseHue);
    topStart = parts[2];
    topEnd = parts[5];
    middleStart = parts[1];
    middleEnd = parts[4];
    bottomStart = parts[0];
    bottomEnd = parts[3];
  }

  List<ColorLerp> _createParts(double hue) {
    final h = _wrapHue(hue);
    final h2 = _wrapHue(h + _randRange(30, 40));
    return [
      ColorLerp(h),
      ColorLerp(300),
      ColorLerp(50),
      ColorLerp(h2),
      ColorLerp(320),
      ColorLerp(50),
    ];
  }

  List<List<double>> get value => [
    bottomStart.value,
    middleStart.value,
    topStart.value,
    bottomEnd.value,
    middleEnd.value,
    topEnd.value,
  ];

  void updateColor(double hue1, double hue2) {
    final h = _wrapHue(hue1);
    final h2 = _wrapHue(h + _randRange(40, 80));
    final h3 = _wrapHue(hue2);
    topStart.update(h);
    topEnd.update(_wrapHue(h + _randRange(30, 40)));
    middleStart.update(h2);
    middleEnd.update(_wrapHue(h2 + _randRange(30, 40)));
    bottomStart.update(h3);
    bottomEnd.update(_wrapHue(h3 + _randRange(30, 40)));
  }

  void tick(double dtMs) {
    topStart.tick(dtMs);
    topEnd.tick(dtMs);
    middleStart.tick(dtMs);
    middleEnd.tick(dtMs);
    bottomStart.tick(dtMs);
    bottomEnd.tick(dtMs);
  }

  double _wrapHue(double h) => (h + 280) % 360;
  double _randRange(int lo, int hi) =>
      lo + _rand.nextInt(hi - lo + 1).toDouble();
}

List<double> _hslToRgb(double h, double s, double l) {
  double f(double n) {
    final k = (n + h / 30) % 12;
    final a = s * min(l, 1 - l);
    return l - a * max(-1, min(k - 3, min(9 - k, 1.0)));
  }

  return [f(0), f(8), f(4)];
}
//generated