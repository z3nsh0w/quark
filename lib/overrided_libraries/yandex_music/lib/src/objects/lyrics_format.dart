enum LyricsFormat {
  /// Simple subtitles in text format
  onlyText('TEXT'),
  /// Subtitles with track timestamp
  withTimeStamp('LRC');

  final String value;

  const LyricsFormat(this.value);
}