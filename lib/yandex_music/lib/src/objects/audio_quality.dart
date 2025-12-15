enum AudioQuality {
  lossless('lossless'),
  normal('nq'),
  low('lq');

  final String value;

  const AudioQuality(this.value);
}