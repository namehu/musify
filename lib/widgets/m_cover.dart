import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../styles/colors.dart';
import '../util/mycss.dart';

/// cover Image
class MCover extends StatelessWidget {
  final String url;
  final double? radius;
  final double? size;
  final bool? round;

  const MCover({
    super.key,
    this.url = '',
    this.radius = 15,
    this.size,
    this.round = false,
  });

  @override
  Widget build(BuildContext context) {
    return round!
        ? ClipOval(
            child: _buildChild(),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius!),
            child: _buildChild(),
          );
  }

  _buildChild() {
    return (url.isEmpty)
        ? Image.asset(mylogoAsset, width: size, height: size)
        : CachedNetworkImage(
            imageUrl: url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return LoadingAnimationWidget.staggeredDotsWave(
                color: gray6,
                size: 40,
              );
            },
            errorWidget: (ctx, s, ss) => Image.asset(
                'assets/images/icon_album.png',
                width: size,
                height: size),
          );
  }
}
