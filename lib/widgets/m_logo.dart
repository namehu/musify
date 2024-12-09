import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musify/enums/serve_type_enum.dart';

const navidrome = 'assets/images/server_logo/navidrome.svg';
const jellyfin = 'assets/images/server_logo/jellyfin.svg';
const subsonic = 'assets/images/server_logo/subsonic.svg';

class MLogo extends StatelessWidget {
  final ServeTypeEnum? serverType;
  final double? size;
  const MLogo({
    super.key,
    this.serverType = ServeTypeEnum.subsnoic,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    var logo = serverType == ServeTypeEnum.navidrome
        ? navidrome
        : serverType == ServeTypeEnum.jellyfin
            ? jellyfin
            : subsonic;

    return SvgPicture.asset(
      logo,
      width: size!,
      height: size!,
      semanticsLabel: 'Server Logo',
    );
  }
}
