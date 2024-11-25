import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/widgets/m_text.dart';

class MColumn {
  final String? text;
  final Widget? child;
  final double? width;
  final int? flex;
  final bool? show;

  MColumn({
    this.text = '',
    this.child,
    this.width = 100,
    this.flex,
    this.show = true,
  });
}

typedef MTableListItem = List<MColumn>;

class MTableList extends StatelessWidget {
  final List<MColumn> data;
  final double? height;
  final bool? divider;
  final bool? isHead;

  const MTableList({
    super.key,
    required this.data,
    this.height = 50,
    this.divider = false,
    this.isHead = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (var i = 0; i < data.length; i++) {
      var item = data[i];

      Widget _child = item.child ??
          MText(
            text: item.text!,
            maxLines: 1,
            style: isHead! ? TextStyle(fontWeight: FontWeight.bold) : null,
          );

      if (item.show!) {
        if (item.flex != null) {
          children.add(Expanded(
            flex: item.flex!,
            child: _child,
          ));
        } else {
          children.add(Container(
            alignment: Alignment.centerLeft,
            width: item.width!,
            child: _child,
          ));
        }
      }
    }

    return Container(
      height: height!,
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: divider!
          ? BoxDecoration(
              border: Border(
              bottom:
                  BorderSide(color: ThemeService.color.borderColor, width: 0.5),
            ))
          : null,
      child: Row(children: children),
    );
  }
}
