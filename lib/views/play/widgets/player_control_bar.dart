import 'package:flutter/material.dart';
import 'package:musify/widgets/music/operation_icons.dart';

class PlayerControlBar extends StatefulWidget {
  const PlayerControlBar({super.key});
  @override
  State<PlayerControlBar> createState() => _PlayerControlBarState();
}

class _PlayerControlBarState extends State<PlayerControlBar> {
  final double iconSize = 24;
  final int loopMode = 0;
  bool isactivePlay = true;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PlayModeToggleIcon(),
        PlayPreIcon(),
        PlayToggleIcon(iconSize: 64),
        PlayNextIcon(),
        PlayListIcon(),
      ],
    );
  }
}
