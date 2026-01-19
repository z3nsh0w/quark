enum AudioQuality {
  lossless('lossless'),
  normal('nq'),
  low('lq'),
  mp3('mp3');

  final String value;

  const AudioQuality(this.value);
}