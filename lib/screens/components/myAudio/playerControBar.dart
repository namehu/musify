import 'package:flutter/material.dart';
import 'package:musify/widgets/music/operation_icons.dart';

class PlayerControBar extends StatefulWidget {
  const PlayerControBar({Key? key}) : super(key: key);
  @override
  _PlayerControBarState createState() => _PlayerControBarState();
}

class _PlayerControBarState extends State<PlayerControBar> {
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PlayModeToggleIcon(),
        PlayPreIcon(),
        PlayFastRewindIcon(),
        PlayToggleIcon(),
        PlayListIcon(),
        PlayFastForwardIcon(),
        PlayNextIcon(),
        PlayStarIcon(),
      ],
    );
  }
}
