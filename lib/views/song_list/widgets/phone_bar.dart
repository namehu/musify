import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    var width = MediaQuery.of(Get.context!).size.width;
    return FlexibleSpaceBar(
      background: Stack(
        children: [
          MCover(
            size: width,
            url: coverUrl,
            shape: MCoverShapeEnum.rect,
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
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: MCover(url: coverUrl, size: 100),
                        ),
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
