import 'package:app_5roga/core/routes/navigator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullMenuImageScreen extends StatelessWidget {
  const FullMenuImageScreen({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          pop(context);
        },
        child: Hero(
          tag: imageUrl,
          child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain, width: double.infinity, height: double.infinity),
        ),
      ),
    );
  }
}
