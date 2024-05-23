import 'package:flutter/cupertino.dart';

class ImageItem {
  final int id;
  final String asset;
  final String name;
  final String path;

  const ImageItem({
    required this.id,
    required this.asset,
    required this.name,
    required this.path,
  });
}