// import 'package:pointycastle/export.dart';
// import 'dart:typed_data';
// import 'dart:convert';

// class TrackDecryptor {
//   // Слава яндексу 💩

//   /// hex в Uint8List
//   static Uint8List hexToBytes(String hex) {
//     final result = Uint8List(hex.length ~/ 2);
//     for (int i = 0; i < hex.length; i += 2) {
//       result[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
//     }
//     return result;
//   }
  
//   /// Создаем крипта крипта биржа 
//   static Uint8List createIV() {
//     return Uint8List(16);
//   }
  
//   static Uint8List decryptAudio(Uint8List encryptedData, String keyHex) {

//     final key = hexToBytes(keyHex);
//     final iv = createIV();
//     final cipher = CTRStreamCipher(AESEngine());
//     final params = ParametersWithIV(KeyParameter(key), iv);
    
//     cipher.init(false, params);

//     final decryptedData = Uint8List(encryptedData.length);
//     cipher.processBytes(encryptedData, 0, encryptedData.length, decryptedData, 0);
    
//     return decryptedData;
//   }
  

//   /// Полный цикл дешифрования трека
//   static Uint8List decryptFromBase64(String base64Data, String keyHex) {
//     final encryptedBytes = base64Decode(base64Data);
//     return decryptAudio(encryptedBytes, keyHex);
//   }

// }