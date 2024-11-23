import 'package:flutter/material.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/widgets/m_title.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(StyleSize.space),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MTitle(
            title: S.current.playlist,
          ),
        ],
      ),
    );
  }
}
