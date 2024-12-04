import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';

import '../../enums/size_enums.dart';
import '../../generated/l10n.dart';
import '../../services/theme_service.dart';
import '../m_button.dart';

class MDialog extends StatelessWidget {
  final double? width;
  final String? title;
  final Widget? content;

  final void Function()? onOk;
  final void Function()? onClose;

  const MDialog({
    super.key,
    this.width,
    this.title = '',
    this.content,
    this.onOk,
    this.onClose,
  });

  handleClose() {
    if (onClose != null) {
      onClose!();
    } else {
      Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = this.width ?? (isMobile ? 320 : 480);

    return GestureDetector(
      onTap: () {
        handleClose();
      },
      child: Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                /// prevent click outside
              },
              child: FittedBox(
                child: ClipRRect(
                  borderRadius: StyleProperty.borderRadius,
                  child: Container(
                    width: width,
                    constraints: BoxConstraints(
                      minHeight: 150,
                    ),
                    padding: EdgeInsets.all(0),
                    color: ThemeService.color.dialogBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          // color: ThemeService.color.dividerColor,
                          padding: EdgeInsets.all(StyleSize.spaceSmall),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                  color: ThemeService.color.textColor,
                                ),
                              ),
                              InkWell(
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: ThemeService.color.textColor,
                                ),
                                onTap: () {
                                  handleClose();
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(StyleSize.spaceSmall),
                          child: content,
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(
                            horizontal: StyleSize.space,
                            vertical: 7,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  handleClose();
                                },
                                child: Text(
                                  S.current.cancel,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: StyleSize.space,
                              ),
                              MButton(
                                title: S.current.confrim,
                                size: SizeEnum.small,
                                width: 50,
                                onTap: () {
                                  if (onOk != null) {
                                    onOk!();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
