import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/widgets/music/operation_icons.dart';

class PlayerControllBar extends GetResponsiveView {
  final bool? dark;
  PlayerControllBar({
    super.key,
    this.dark = false,
  });

  @override
  Widget builder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PlayModeToggleIcon(),
        PlayPreIcon(),
        PlayToggleIcon(iconSize: 64),
        PlayNextIcon(),
        PlayListIcon(),
      ],
    );
  }

  @override
  Widget desktop() {
    var color = dark! ? operationIconDarkColor : null;
    return Container(
      constraints: BoxConstraints(maxWidth: 350),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PlayModeToggleIcon(
            color: color,
          ),
          PlayPreIcon(
            color: color,
          ),
          // PlayFastRewindIcon(),
          PlayToggleIcon(
            color: color,
            iconSize: 64,
          ),
          // PlayFastForwardIcon(),
          PlayNextIcon(
            color: color,
          ),
          PlayListIcon(
            color: color,
          ),
          // PlayStarIcon(
          // ),
        ],
      ),
    );
  }
}
