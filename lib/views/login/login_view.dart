import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musify/enums/serve_type_enum.dart';
import 'package:musify/services/global_service.dart';
import 'package:musify/services/theme_service.dart';
import 'login_controller.dart';

class LoginViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: controller.editId != null,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(controller.editId != null ? '编辑服务器' : '设置服务器'),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Container(
            constraints:
                BoxConstraints(maxWidth: GloabalService.contentMaxWidth),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icon_music.png',
                  width: 150,
                  height: 56,
                ),
                SizedBox(height: 80),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => DropdownButton(
                          hint: Text('选择服务器类型'),
                          isExpanded: true,
                          underline: Divider(
                            height: 1,
                            color: Colors.white,
                          ),
                          value: controller.serverType.value,
                          onChanged: (va) {
                            controller.serverType.value = va!;
                          },
                          items: ServeTypeEnum.values
                              .map((e) => DropdownMenuItem(
                                    child: Text(e.label),
                                    value: e,
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                TextField(
                  controller: controller.servercontroller,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: '服务器地址',
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: controller.usernamecontroller,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: '用户名',
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: controller.passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: '密码',
                  ),
                ),
                SizedBox(height: 40),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          controller.handleSubmit(context);
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                ThemeService.color.primaryButtonColor),
                            shape:
                                WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              side: BorderSide(color: Colors.red),
                            ))),
                        child: Obx(
                          () => Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (controller.loading.value)
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: LoadingAnimationWidget.dotsTriangle(
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              Text(
                                controller.editId != null ? '修改' : '登录',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
