import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/constant.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/widgets/m_toast.dart';
import 'm_dialog.dart';

Future<dynamic> showPlayListDialog({
  String? title,
  double? width,
  BuildContext? context,
}) {
  context ??= navigatorKey.currentState!.context;
  title ??= S.current.create + S.current.playlist;
  final formKey = GlobalKey<FormState>();

  String playlistName = '';

  handeSave() async {
    var state = formKey.currentState!;
    if (state.validate()) {
      state.save();
      await MRequest.api.createPlaylist(playlistName);
      MToast.success(S.current.create + S.current.playlist + S.current.success);
      Navigator.of(Get.overlayContext!, rootNavigator: true).pop(1);
    }
  }

  return Get.dialog(
    MDialog(
      title: title,
      content: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.edit_note,
                  color: ThemeService.color.iconColor,
                  size: 14,
                ),
                // border: InputBorder.none,
              ),
              validator: (value) {
                RegExp reg = RegExp(r'^.{2,12}$');
                if (!reg.hasMatch(value!)) {
                  return '请输入歌单名称';
                }
                return null;
              },
              onSaved: (newValue) {
                playlistName = newValue!;
              },
            ),
          ],
        ),
      ),
      onOk: () {
        handeSave();
      },
    ),
  );
}
