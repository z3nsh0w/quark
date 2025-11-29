// Trying to implement my cached_network_image
// Maybe it will come in handy someday (tomorrow)


// import 'dart:io';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:crypto/crypto.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:dio/dio.dart';



// class CachedImages extends StatefulWidget {
//   final dynamic image;
//   final double height;
//   final double width;
//   const CachedImages({super.key, required this.image, required this.height, required this.width});


//   @override
//   State<CachedImages> createState() => _CachedImages();
// }


// class _CachedImages extends State<CachedImages> {
//   String? _localImagePath;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _resolveImage();
//   }

//   Future<void> _resolveImage() async {
//     final dir = await getApplicationCacheDirectory();
//     String hash;

//     if (widget.image is Uint8List) {
//       hash = sha256.convert(widget.image as Uint8List).toString();
//     } else if (widget.image is String) {
//       hash = sha256.convert(utf8.encode(widget.image as String)).toString();
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }

//     final filePath = '${dir.path}/$hash';
//     final file = File(filePath);

//     if (await file.exists()) {
//       setState(() {
//         _localImagePath = filePath;
//         _isLoading = false;
//       });
//     } else {
//       try {
//         if (widget.image is Uint8List) {
//           await file.writeAsBytes(widget.image as Uint8List);
//         } else if (widget.image is String) {
//           await Dio().download(widget.image as String, filePath);
//         }

//         setState(() {
//           _localImagePath = filePath;
//           _isLoading = false;
//         });
//       } catch (e) {
//         debugPrint('Failed to cache image: $e');
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return SizedBox(
//         height: widget.height,
//         width: widget.width,
//         child: const Center(child: CircularProgressIndicator(color: Color.fromARGB(101, 255, 255, 255),)),
//       );
//     }

//     if (_localImagePath == null || _localImagePath!.isEmpty) {
//       return SizedBox(
//         height: widget.height,
//         width: widget.width,
//         child: const Icon(Icons.error),
//       );
//     }

//     return Image.file(
//       File(_localImagePath!),
//       height: widget.height,
//       width: widget.width,
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) {
//         return SizedBox(
//           height: widget.height,
//           width: widget.width,
//           child: const Icon(Icons.broken_image),
//         );
//       },
//     );
//   }
// }