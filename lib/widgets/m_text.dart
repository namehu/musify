import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';

enum MTextTypeEnum {
  primary,
  secondary,
}

class MText extends StatelessWidget {
  final String? text;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextStyle? style;
  final MTextTypeEnum? type;
  final GestureTapCallback? onTap;

  const MText({
    super.key,
    this.text = '',
    this.maxLines,
    this.textAlign = TextAlign.start,
    this.type = MTextTypeEnum.primary,
    this.style,
    this.onTap,
  });

  TextStyle get _textStyle {
    var st = style ?? TextStyle();
    var co = type == MTextTypeEnum.primary
        ? null
        : ThemeService.color.textSecondColor;

    st = st.copyWith(color: st.color ?? co);
    return st;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text!,
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        style: _textStyle,
      ),
    );
  }
}
