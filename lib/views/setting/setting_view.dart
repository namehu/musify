import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/size_enums.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/global_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/views/setting/setting_controller.dart';
import 'package:musify/widgets/m_button.dart';
import 'package:musify/widgets/m_title.dart';

class SettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SettingController>(SettingController());
  }
}

class SettingView extends GetView<SettingController> {
  var gloabalService = Get.find<GloabalService>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text(S.current.settings)),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(StyleSize.space),
            constraints:
                BoxConstraints(maxWidth: GloabalService.contentMaxWidth),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    child: _card(
                      child: _listItem(
                        icon: Icons.museum,
                        title: S.current.version,
                        value: Text(
                          version,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                ),
                // server config card
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: StyleSize.spaceLarge, bottom: StyleSize.space),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MTitle(title: S.current.server),
                        MButton(
                          size: SizeEnum.samll,
                          onTap: () {
                            Get.toNamed(Routes.CHANGE_SERVER);
                          },
                          title: S.current.change + S.current.server,
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _card(
                    child: Column(
                      children: [
                        _listItem(
                          icon: Icons.dns,
                          title: S.current.serverURL,
                          value: Text(
                            controller.sever.baseurl,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        _listItem(
                          icon: Icons.person,
                          title: S.current.username,
                          value: Text(
                            controller.sever.username,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        _listItem(
                          icon: Icons.password,
                          title: S.current.password,
                          value: Text(
                            '********',
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: StyleSize.spaceLarge, bottom: StyleSize.space),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MTitle(title: S.current.systemSettings),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _card(
                      child: Column(
                    children: [
                      _listItem(
                        icon: Icons.museum,
                        title: S.current.language,
                        value: Obx(
                          () => Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DropdownButton(
                                value: controller.selectedSort.value,
                                items: controller.lanMenuItems,
                                isDense: true,
                                underline: Container(),
                                onChanged: (value) async {
                                  String va = value.toString();

                                  await controller.languageService
                                      .changeLanguage(va);

                                  controller.selectedSort.value = va;

                                  gloabalService.restartApp();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      _listItem(
                        icon: Icons.museum,
                        title: S.current.theme,
                        value: Obx(
                          () => Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DropdownButton(
                                value: ThemeService.modekey,
                                items: controller.themeMenuItems,
                                isDense: true,
                                underline: Container(),
                                onChanged: (value) async {
                                  var va = int.parse(value.toString());
                                  await ThemeService.setThemeMode(va);
                                  gloabalService.restartApp();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _card({
    String? title,
    List<Widget>? extra,
    Widget? child,
  }) {
    // 处理标题
    List<Widget> titles = [];
    if (title != null) {
      titles.add(
        Expanded(child: Text(title)),
      );
      titles.addAll(extra ?? [SizedBox(width: 10)]);
    }

    var containerChild = <Widget>[];
    containerChild.addAllIf(titles.isNotEmpty, [
      Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: titles,
      ),
    ]);

    // 处理间隔占位
    containerChild.addIf(
        child != null && title != null, SizedBox(height: StyleSize.space));
    // 处理内容
    containerChild.addIf(child != null, child!);

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: ThemeService.color.cardColor,
        borderRadius: StyleProperty.borderRadius,
      ),
      child: Column(
        children: containerChild,
      ),
    );
  }

  _listItem({
    String? title,
    IconData? icon,
    Widget? value,
  }) {
    final children = <Widget>[];

    children.addIf(
      icon != null,
      Container(
        margin: EdgeInsets.only(right: 10),
        child: Icon(
          icon,
          size: 14,
        ),
      ),
    );

    children.add(Text(
      title ?? '',
      style: TextStyle(),
    ));

    if (value != null) {
      children.add(
        Expanded(
          flex: 1,
          child: value,
        ),
      );
    }

    return Container(
      height: 48,

      // padding: EdgeInsets.only(top: 15, left: 15),
      // contentPadding: EdgeInsets.zero,
      child: Flex(
        direction: Axis.horizontal,

        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}
