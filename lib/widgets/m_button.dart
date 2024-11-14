import 'package:flutter/material.dart';
import 'package:musify/enums/size_enums.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';

enum ButtonType { primary, secondary }

/// 自定义按钮组件
class MButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final ButtonType? type;
  final SizeEnum? size;
  final double? width;
  final VoidCallback? onTap;

  MButton({
    Key? key,
    required this.title,
    this.type = ButtonType.primary,
    this.size = SizeEnum.normal,
    this.icon,
    this.width,
    this.onTap,
  }) : super(key: key);

  get padding => EdgeInsets.only(
        top: size!.paddingTop,
        bottom: size!.paddingTop,
        left: size!.paddingLeft,
        right: size!.paddingLeft,
      );

  double get fontSize => size == SizeEnum.samll ? 12 : 14;
  get color {
    return switch (type) {
      ButtonType.primary => ThemeService.color.primaryButtonColor,
      ButtonType.secondary => ThemeService.color.secondaryButtonColor,
      // ButtonType.danger => Theme.of(context).errorColor,
      _ => ThemeService.color.primaryButtonColor,
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: height,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: StyleProperty.borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(
                      icon!,
                      size: 16,
                    ),
                  )
                : Container(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
