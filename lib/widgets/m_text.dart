import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';

enum MTextTypeEnum {
  primary,
  secondary,
}

class MText extends StatelessWidget {
  final String? text;
  final int? maxLines;
  final TextStyle? style;
  final MTextTypeEnum? type;
  final GestureTapCallback? onTap;

  const MText({
    super.key,
    this.text = '',
    this.type = MTextTypeEnum.primary,
    this.maxLines,
    this.style,
    this.onTap,
  });

  TextStyle get _textStyle {
    var _style = style ?? TextStyle();
    var _color = _style.color ??
        (type == MTextTypeEnum.primary
            ? null
            : ThemeService.color.textSecondColor);

    _style = _style.copyWith(color: _color);
    print('$_color     ${_style.color}');
    return _style;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text!,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: _textStyle,
      ),
    );
  }
}
