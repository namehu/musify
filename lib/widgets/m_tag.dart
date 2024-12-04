import 'package:flutter/material.dart';
import 'package:musify/enums/size_enums.dart';

class MTag extends StatefulWidget {
  const MTag({
    super.key,
    this.child,
    this.size = SizeEnum.small,
    this.radius = 0.0,
    this.onTap,
  });

  final Widget? child;
  final SizeEnum? size;
  final double? radius;
  final void Function()? onTap;

  @override
  State<MTag> createState() => _MTagState();
}

class _MTagState extends State<MTag> {
  bool isHover = false;

  get _padding {
    switch (widget.size) {
      case SizeEnum.small:
        return EdgeInsets.all(4);
      case SizeEnum.large:
        return EdgeInsets.symmetric(vertical: 6, horizontal: 8);
      default:
        return EdgeInsets.symmetric(vertical: 4, horizontal: 8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius!),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            padding: _padding,
            color: isHover ? Colors.grey[400] : Colors.grey[300],
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
