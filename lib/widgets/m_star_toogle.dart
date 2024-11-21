import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';

class MStarToogle extends StatelessWidget {
  final bool value;
  final double? size;
  final bool? disabled;
  final dynamic Function(bool value)? onChange;

  const MStarToogle({
    super.key,
    required this.value,
    this.size = 24,
    this.disabled = false,
    this.onChange,
  });

  get color => disabled!
      ? ThemeService.color.textDisabledColor
      : value
          ? Colors.red
          : ThemeService.color.iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(
        value ? Icons.favorite : Icons.favorite_border_outlined,
        color: color,
        size: size,
      ),
      onTap: disabled!
          ? null
          : () {
              if (onChange != null) onChange!(!value);
            },
    );
  }
}
