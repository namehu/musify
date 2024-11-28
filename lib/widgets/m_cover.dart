import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musify/services/theme_service.dart';
import '../styles/colors.dart';

enum MCoverShapeEnum { round, squareRound, rect }

/// cover Image
class MCover extends StatelessWidget {
  final String url;
  final double? radius;
  final double? size;
  final bool? showDefaultPalceholder;
  final Widget? placeholder;

  @Deprecated('')
  final bool? round;

  final MCoverShapeEnum? shape;

  const MCover({
    super.key,
    this.url = '',
    this.radius = 4,
    this.size,
    this.shape = MCoverShapeEnum.squareRound,
    this.round = false,
    this.showDefaultPalceholder = false,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return shape! == MCoverShapeEnum.round
        ? ClipOval(
            child: _buildChild(),
          )
        : shape! == MCoverShapeEnum.rect
            ? ClipRRect(
                child: _buildChild(),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(radius!),
                child: _buildChild(),
              );
  }

  _buildChild() {
    if (url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return LoadingAnimationWidget.threeArchedCircle(
            color: gray5,
            size: max(32, size != null ? size! : 32),
          );
        },
        errorWidget: (ctx, s, ss) => Icon(
          Icons.music_off,
          color: ThemeService.color.textDisabledColor,
        ),
      );
    }

    if (placeholder != null) {
      return placeholder!;
    }

    return showDefaultPalceholder!
        ? SizedBox(
            width: size,
            height: size,
            child: Center(
              child: Icon(
                Icons.music_note_outlined,
                size: size != null ? size! / 2 : 14,
                color: ThemeService.color.textSecondColor,
              ),
            ),
          )
        : null;
  }
}
