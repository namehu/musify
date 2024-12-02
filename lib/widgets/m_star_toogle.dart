import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';

class MStarToogle extends StatelessWidget {
  final bool value;
  final Color? color;
  final double? size;
  final bool? disabled;
  final dynamic Function(bool value)? onChange;

  const MStarToogle({
    super.key,
    required this.value,
    this.color,
    this.size = 24,
    this.disabled = false,
    this.onChange,
  });

  get _color => disabled!
      ? ThemeService.color.textDisabledColor
      : value
          ? Colors.red
          : color ?? ThemeService.color.iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled! || onChange == null
          ? null
          : () {
              if (onChange != null) onChange!(!value);
            },
      child: Icon(
        value ? Icons.favorite : Icons.favorite_border_outlined,
        color: _color,
        size: size,
      ),
    );
  }
}
