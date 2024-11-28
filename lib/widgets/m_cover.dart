import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../styles/colors.dart';
import '../util/mycss.dart';

enum MCoverShapeEnum { round, squareRound, rect }

/// cover Image
class MCover extends StatelessWidget {
  final String url;
  final double? radius;
  final double? size;
  final String? placeholderImage;
  final Color? placeholderColor;

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
    this.placeholderColor,
    this.placeholderImage = mylogoAsset,
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
            size: 32,
          );
        },
        errorWidget: (ctx, s, ss) => Image.asset(
          'assets/images/icon_album.png',
          width: size,
          height: size,
        ),
      );
    }

    if (placeholderColor != null) {
      return Container(
        width: size,
        height: size,
        color: placeholderColor!,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: gray5,
          size: 32,
        ),
      ),
    );
    // return Image.asset(
    //   placeholderImage!,
    //   width: size,
    //   height: size,
    //   fit: BoxFit.cover,
    // );
  }
}
