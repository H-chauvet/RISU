import 'package:flutter/material.dart';

/// Loads an image from a given URL and returns it as a widget.
///
/// The [imageURL] parameter specifies the URL of the image to be loaded.
/// If [maxHeight] is provided, the image will be wrapped inside a container with a maximum height of [maxHeight].
///
/// Returns a widget that displays the loaded image.
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
          image: imageURL,
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
