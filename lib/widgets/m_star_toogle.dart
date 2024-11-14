import 'package:flutter/material.dart';

import '../util/mycss.dart';

class MStarToogle extends StatelessWidget {
  final bool value;
  final double? size;
  final dynamic Function(bool value) onChange;

  const MStarToogle({
    super.key,
    required this.value,
    this.size = 16,
    required this.onChange,
  });

  get color => value ? badgeRed : Colors.grey;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(0),
      icon: Icon(
        value ? Icons.favorite : Icons.favorite_border_outlined,
        color: color,
        size: size,
      ),
      onPressed: () {
        onChange(!value);
      },
    );
  }
}
