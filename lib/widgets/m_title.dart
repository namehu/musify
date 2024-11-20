import 'package:flutter/widgets.dart';

class MTitle extends StatelessWidget {
  final String title;
  final int level;

  final Map<int, double> _sizeMap = {
    1: 38,
    2: 30,
    3: 24,
    4: 20,
    5: 16,
  };

  MTitle({
    Key? key,
    required this.title,
    this.level = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
          fontSize: _sizeMap[level],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
