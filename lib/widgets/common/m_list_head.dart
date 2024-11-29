import 'package:flutter/material.dart';
import 'package:musify/styles/size.dart';

class MListHead extends StatelessWidget {
  final Widget cover;
  final String title;
  final List<Widget> subWidgets;

  const MListHead({
    super.key,
    required this.cover,
    required this.title,
    required this.subWidgets,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Expanded(
        flex: 1,
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: StyleSize.titleSize,
          ),
        ),
      ),
    ];

    for (Widget widget in subWidgets) {
      children.add(SizedBox(height: StyleSize.spaceSmall));
      children.add(widget);
    }

    return Container(
      margin: EdgeInsets.only(top: StyleSize.space),
      padding: EdgeInsets.symmetric(horizontal: StyleSize.space),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 136,
            height: 136,
            margin: EdgeInsets.only(right: StyleSize.space),
            child: cover,
          ),
          Expanded(
            child: SizedBox(
              height: 136,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          )
        ],
      ),
    );
  }
}
