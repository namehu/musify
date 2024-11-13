import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(controller.editId != null ? '编辑服务器' : '选择服务器'),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.jpg',
                  width: 150,
                  height: 56,
                ),
                SizedBox(height: 80),
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
                        child: Text(
                          controller.editId != null ? '修改' : '登录',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
