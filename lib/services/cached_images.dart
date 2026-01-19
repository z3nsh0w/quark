// A microservice for full image caching using cached_network_image library
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  final Map<String, Future<Uint8List>> _cache = {};

  Future<Uint8List> getImage(String uri) {
    var future = _cache[uri];
    if (future != null) {
      return future;
    }

    final completer = Completer<Uint8List>();
    _cache[uri] = completer.future;

    _loadImage(uri)
        .then((data) {
          completer.complete(data);
        })
        .catchError((error, stackTrace) {
          completer.completeError(error, stackTrace);
        });

    return completer.future;
  }

  Future<Uint8List> _loadImage(String uri) async {
    final fileData = await _readFromDisk(uri);
    if (fileData != null) {
      return fileData;
    }

    final response = await Dio().get<Uint8List>(
      uri,
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data as Uint8List;
    await _saveToDisk(uri, bytes);

    return bytes;
  }

  Future<String> getImagePath(String uri) async {
    final file = await _getImageFile(uri);
    return file.path;
  }

  Future<Uint8List?> _readFromDisk(String uri) async {
    final file = await _getImageFile(uri);
    if (await file.exists()) {
      return await file.readAsBytes();
    }
    return null;
  }

  Future<void> _saveToDisk(String uri, Uint8List data) async {
    final file = await _getImageFile(uri);
    await file.writeAsBytes(data);
  }

  String getMd5(dynamic info) {
    return md5.convert(info is String ? utf8.encode(info) : info).toString();
  }

  Future<File> _getImageFile(String uri) async {
    final dir = await getApplicationCacheDirectory();
    final hash = getMd5(uri);
    await Directory(join(dir.path, 'cached_images')).create(recursive: true);
    return File(join(dir.path, 'cached_images', hash));
  }
}


class CachedImage extends StatelessWidget {
  final String coverUri;
  final double height;
  final double width;
  final double borderRadius;
  final int alphaChannel;

  const CachedImage({
    super.key,
    required this.coverUri,
    this.height = 50,
    this.width = 50,
    this.borderRadius = 0,
    this.alphaChannel = 100
  });



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: ImageCacheService().getImage(coverUri),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return SizedBox(
            width: width,
            height: height,
            child: Image.memory(snapshot.data!, fit: BoxFit.cover),
          );
        }
        if (snapshot.hasError) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(alphaChannel),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            width: width,
            height: height,
            child: Icon(
              Symbols.music_note,
              color: Colors.white.withAlpha(alphaChannel),
              size: width < 100 ? 16 : 42,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: width * 0.9,
            height: width * 0.9,
            child: CircularProgressIndicator(
              color: const Color.fromARGB(100, 255, 255, 255),
            ),
          );
        }

        return SizedBox(width: width, height: height);
      },
    );
  }
}
