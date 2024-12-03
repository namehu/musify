import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';

class IconPlay extends StatelessWidget {
  const IconPlay({
    super.key,
    this.size = 40,
    this.onTap,
  });

  final double? size;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: ThemeService.color.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.play_arrow,
          color: gray1,
        ),
      ),
    );
  }
}
