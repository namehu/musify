import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musify/services/theme_service.dart';

enum MCoverShapeEnum { round, squareRound, rect }

/// cover Image
class MCover extends StatelessWidget {
  final String url;
  final double? radius;
  final double? size;
  final bool? imagePlaceholder;
  final Widget? placeholder;

  @Deprecated('')
  final bool? round;

  final MCoverShapeEnum? shape;

  const MCover({
    super.key,
    this.url = '',
    this.radius = 4,
    this.size,
    this.imagePlaceholder = false,
    this.shape = MCoverShapeEnum.squareRound,
    this.round = false,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return shape! == MCoverShapeEnum.round
        ? ClipOval(
            child: SizedBox(
              width: size,
              height: size,
              child: _buildChild(),
            ),
          )
        : shape! == MCoverShapeEnum.rect
            ? ClipRRect(
                child: SizedBox(
                  width: size,
                  height: size,
                  child: _buildChild(),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(radius!),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: _buildChild(),
                ),
              );
  }

  _buildChild() {
    if (url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: imagePlaceholder!
            ? (context, url) {
                return LoadingAnimationWidget.threeArchedCircle(
                  color: ThemeService.color.textSecondColor,
                  size: max(24, size != null ? size! / 3 : 32),
                );
              }
            : (context, url) => SizedBox(width: size, height: size),
        errorWidget: (ctx, s, ss) => Icon(
          Icons.music_off,
          color: ThemeService.color.textDisabledColor,
        ),
      );
    }

    return placeholder ?? Container();
  }
}
