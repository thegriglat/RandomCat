import 'package:flutter/material.dart';

class CatImageWidget extends StatelessWidget {
  final String url;

  const CatImageWidget({Key? key, required this.url}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.fill,
      loadingBuilder: (BuildContext context,
          Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return CircularProgressIndicator(
            value: loadingProgress
                .expectedTotalBytes !=
                null
                ? loadingProgress
                .cumulativeBytesLoaded /
                loadingProgress
                    .expectedTotalBytes!
                : null,
          );
      },
    );
  }
}
