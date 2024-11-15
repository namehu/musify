import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musify/util/mycss.dart';

/// cover Image
class MCover extends StatelessWidget {
  final String url;
  final double? size;
  final double radius;

  const MCover({
    super.key,
    this.url = '',
    this.radius = 15,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: (url.isEmpty)
          ? Image.asset(
              mylogoAsset,
              width: size,
              height: size,
            )
          : CachedNetworkImage(
              imageUrl: url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return AnimatedSwitcher(
                  child: Image.asset(mylogoAsset),
                  duration: const Duration(milliseconds: imageMilli),
                );
              },
            ),
    );
  }
}
