import 'package:flutter/material.dart';

class MTag extends StatefulWidget {
  final Widget? child;
  final void Function()? onTap;
  const MTag({
    super.key,
    this.child,
    this.onTap,
  });

  @override
  State<MTag> createState() => _MTagState();
}

class _MTagState extends State<MTag> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
          padding: EdgeInsets.all(4),
          color: isHover ? Colors.grey[400] : Colors.grey[300],
          child: widget.child,
        ),
      ),
    );
  }
}
