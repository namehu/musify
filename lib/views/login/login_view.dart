import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musify/enums/serve_type_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/global_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';
import 'login_controller.dart';

class LoginViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
          title: Text(controller.editId != null
              ? S.current.serverEdit
              : S.current.serverSet),
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
                          hint: Text(
                            S.current.server + S.current.type,
                            style: TextStyle(
                              color: gray1,
                            ),
                          ),
                          isExpanded: true,
                          underline: Divider(
                            height: 1,
                            color: gray1,
                          ),
                          style: TextStyle(color: gray1),
                          value: controller.serverType.value,
                          onChanged: (va) {
                            controller.serverType.value = va!;
                          },
                          items: ServeTypeEnum.values
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.label),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                _buildInput(
                  controller: controller.servercontroller,
                  labelText: S.current.serverURL,
                  hintText: 'https://127.0.0.1:3000',
                ),
                SizedBox(height: 40),
                _buildInput(
                  controller: controller.usernamecontroller,
                  labelText: S.current.username,
                ),
                SizedBox(height: 40),
                _buildInput(
                  controller: controller.passwordcontroller,
                  labelText: S.current.password,
                  password: true,
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
                                controller.editId != null
                                    ? S.current.modify
                                    : S.current.login,
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

  Widget _buildInput({
    String? labelText,
    String? hintText,
    TextEditingController? controller,
    bool password = false,
  }) {
    return TextField(
      obscureText: password,
      enableSuggestions: !password,
      autocorrect: !password,
      controller: controller,
      style: TextStyle(color: gray1),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: gray1.withOpacity(0.3)),
        labelStyle: TextStyle(color: gray1),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: gray1),
        ),
        labelText: labelText,
      ),
    );
  }
}
