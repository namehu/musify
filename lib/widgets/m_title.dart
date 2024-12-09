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
  final double? size;
  final List<dynamic>? actions;
  final void Function(int index)? onActionsTap;

  const MTitle({
    super.key,
    required this.title,
    this.level = 4,
    this.size,
    this.actions,
    this.onActionsTap,
  });

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    for (var i = 0; i < (actions ?? []).length; i++) {
      var element = actions![i];
      children.add(
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
        Text(
          title,
          style: TextStyle(
            fontSize: size ?? _sizeMap[level],
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ],
    );
  }
}
