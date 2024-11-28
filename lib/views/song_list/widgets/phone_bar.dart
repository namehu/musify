import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/widgets/m_cover.dart';

class PhoneBar extends StatelessWidget {
  final String? cover;
  final String title;

  const PhoneBar({super.key, required this.title, this.cover = ''});

  @override
  Widget build(BuildContext context) {
    var coverUrl = cover ?? '';

    return FlexibleSpaceBar(
      background: Stack(
        children: [
          MCover(
            size: MediaQuery.of(Get.context!).size.width,
            radius: 0,
            url: coverUrl,
            shape: MCoverShapeEnum.rect,
            placeholderColor: ThemeService.color.primaryColor,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: StyleSize.spaceLarge,
                vertical: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 120,
                    child: Row(
                      children: [
                        MCover(url: coverUrl, size: 100),
                        SizedBox(
                          width: StyleSize.space,
                        ),
                        Column(
                          children: [
                            Text(
                              title,
                              style: TextStyle(color: gray1, fontSize: 28),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
