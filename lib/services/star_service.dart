import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/enums/star_type_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/widgets/m_toast.dart';

/// 收藏服务
class StarService extends GetxService {
  Future<StarService> init() async {
    return this;
  }

  /// 切换收藏状态
  /// [star] true 收藏，false 取消收藏
  /// [type] 收藏类型
  /// [id] 收藏id
  toggleStar({
    required String id,
    required StarTypeEnum type,
    required bool star,
  }) async {
    if (star) {
      await MRequest.api.addStar(id, type);
      MToast.show(S.current.add + S.current.favorite);
    } else {
      await MRequest.api.removeStar(id, type);
      MToast.show(S.current.cancel + S.current.favorite);
    }
  }
}
