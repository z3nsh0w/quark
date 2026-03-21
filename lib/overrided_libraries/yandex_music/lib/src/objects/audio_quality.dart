enum AudioQuality {
  lossless('lossless'),
  normal('nq'),
  low('lq'),
  @Deprecated('use AudioQuality.normal instead')
  mp3('mp3');

  final String value;

  const AudioQuality(this.value);
}