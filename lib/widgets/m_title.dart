import 'package:flutter/widgets.dart';
import 'package:musify/services/theme_service.dart';

final Map<int, double> _sizeMap = {
  1: 38,
  2: 30,
  3: 24,
  4: 20,
  5: 16,
};

class MTitle extends StatelessWidget {
  final String title;
  final int level;
  final List<dynamic>? actions;
  final void Function(int index)? onActionsTap;

  MTitle({
    Key? key,
    required this.title,
    this.level = 4,
    this.actions,
    this.onActionsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _children = <Widget>[];

    for (var i = 0; i < (actions ?? []).length; i++) {
      var element = actions![i];
      _children.add(
        GestureDetector(
          onTap: () {
            onActionsTap?.call(i);
          },
          child: (element is String)
              ? Text(
                  element,
                  style: TextStyle(
                    color: ThemeService.color.textSecondColor,
                    fontSize: 13,
                  ),
                )
              : element,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Text(
            title,
            style: TextStyle(
              fontSize: _sizeMap[level],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: _children,
        ),
      ],
    );
  }
}
