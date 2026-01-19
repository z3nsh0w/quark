class DerivedColors {
  /// HEX
  final String average;

  /// HEX
  final String waveText;

  /// HEX
  final String miniPlayer;

  /// HEX
  final String accent;

  DerivedColors(Map<String, dynamic> colors)
    : average = colors['average'],
      waveText = colors['waveText'],
      miniPlayer = colors['miniPlayer'],
      accent = colors['accent'];
}
