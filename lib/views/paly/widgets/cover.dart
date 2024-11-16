import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musify/widgets/m_cover.dart';

class PlayCoverWidget extends StatefulWidget {
  final String url;
  const PlayCoverWidget({super.key, required this.url});

  @override
  State<PlayCoverWidget> createState() => _PlayCoverWidgetState();
}

class _PlayCoverWidgetState extends State<PlayCoverWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 320,
      // color: Colors.red,
      child: MCover(
        url: widget.url,
        radius: 4,
      ),
    );
  }
}
