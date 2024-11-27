import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/constant.dart';
import 'package:musify/enums/size_enums.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/widgets/m_button.dart';

import '../../styles/size.dart';

showPlayListDialog({
  String? title = '',
  double? width = 350,
  BuildContext? context,
}) {
  context ??= navigatorKey.currentState!.context;
  final _formKey = GlobalKey<FormState>();

  _close() {
    Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
  }

  Get.dialog(
    GestureDetector(
      onTap: () {
        _close();
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          color: ThemeService.color.dividerColor,
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
                                  _close();
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(StyleSize.spaceSmall),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    label: Text(S.current.playlist),
                                    hintText: '请输入歌单名称',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.none,
                                      color: ThemeService.color.textColor,
                                    ),
                                    // border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    RegExp reg = new RegExp(r'^\.{2,12}$');
                                    if (!reg.hasMatch(value!)) {
                                      return '请输入歌单名称';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(StyleSize.spaceSmall),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  _close();
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
                                size: SizeEnum.samll,
                                width: 50,
                                onTap: () {
                                  var _state = _formKey.currentState!;
                                  if (_state.validate()) {
                                    _state.save();
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
    ),
  );
  // showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: ThemeService.color.dialogBackgroundColor,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: StyleProperty.borderRadius,
  //         ),
  //         contentPadding: EdgeInsets.all(16),
  //         titlePadding: EdgeInsets.all(16),
  //         title: Text('新增歌单'),
  //       );
  //     });
}
