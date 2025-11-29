import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:xml/xml.dart' as xml;

String getFileInfoSign({
  required String trackId,
  required String quality,
  required List<String> codecs,
  required String transport,
  required dynamic timestamp,
}) {
  final  secretKey = "7tvSmFbyf5hJnIHhCimDDD";
  final codecsString = codecs.join();
  final signString = '$timestamp$trackId$quality$codecsString$transport';
  final key = utf8.encode(secretKey);
  final bytes = utf8.encode(signString);
  final hmac = Hmac(sha256, key);
  final digest = hmac.convert(bytes);
  final base64Signature = base64Encode(digest.bytes);
  return base64Signature.substring(0, base64Signature.length - 1);
}

Map<String, dynamic> getLyricsSign({required String trackId}) {
  final secretKey = 'p93jhgh689SBReK6ghtw62';
  final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final message = '$trackId$timestamp';
  final keyBytes = utf8.encode(secretKey);
  final messageBytes = utf8.encode(message);
  final hmac = Hmac(sha256, keyBytes);
  final digest = hmac.convert(messageBytes);
  final sign = base64.encode(digest.bytes);
  print({'timestamp': timestamp, 'signature': sign});
  return {'timestamp': timestamp, 'signature': sign};
}

String getMp3Sign({required xml.XmlDocument xmlDoc}) {
  final secretKey = 'XGRlBW9FXlekgbPrRHuSiA';

  final path = xmlDoc.findAllElements('path').first.text;
  final s = xmlDoc.findAllElements('s').first.text;
  final signData = secretKey + path.substring(1) + s;
  final signBytes = utf8.encode(signData);
  final sign = md5.convert(signBytes).toString();
  return sign;
}
