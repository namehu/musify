import 'package:flutter/material.dart';
import 'package:musify/enums/size_enums.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/styles/size.dart';

/// 自定义按钮组件
class MButton extends StatelessWidget {
  final String title;
  final SizeEnum? size;
  final VoidCallback? onTap;

  MButton({
    Key? key,
    required this.title,
    this.size = SizeEnum.normal,
    this.onTap,
  }) : super(key: key);

  get padding => EdgeInsets.only(
        top: size!.paddingTop,
        bottom: size!.paddingTop,
        left: size!.paddingLeft,
        right: size!.paddingLeft,
      );

  double get fontSize => size == SizeEnum.samll ? 12 : 14;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: StyleColor.primaryButtonColor,
          borderRadius: StyleProperty.borderRadius,
        ),
        child: Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            )),
      ),
    );
  }
}
