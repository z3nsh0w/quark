enum LyricsFormat {
  /// Простые субтитры в текстовом формате
  onlyText('TEXT'),
  /// Субтитры с временной меткой трека
  withTimeStamp('LRC');

  final String value;

  const LyricsFormat(this.value);
}