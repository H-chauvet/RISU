import 'package:flutter/cupertino.dart';

Widget loadImageFromURL(String? imageURL, {double? maxHeight}) {
  if (maxHeight != null) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: putImage(imageURL),
    );
  }
  return putImage(imageURL);
}

Widget putImage(String? imageURL) {
  return imageURL != null
      ? FadeInImage.assetNetwork(
          placeholder: 'assets/image_placeholder.png',
          image: imageURL ?? '',
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 50),
          fadeOutDuration: const Duration(milliseconds: 50),
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/image_placeholder.png',
              fit: BoxFit.cover,
            );
          },
        )
      : Image.asset(
          'assets/image_placeholder.png',
          fit: BoxFit.cover,
        );
}
