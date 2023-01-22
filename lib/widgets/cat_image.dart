import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatImageWidget extends StatelessWidget {
  final String url;

  const CatImageWidget({Key? key, required this.url}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => const Text("Error!"),
    );
  }
}
