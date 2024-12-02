import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/views/home/home_controller.dart';
import 'package:musify/views/home/widgets/recommand.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/myModel.dart';
import '../../../screens/common/mySliverControlBar.dart';
import '../../../screens/common/mySliverControlList.dart';

class HomeTabOne extends StatefulWidget {
  const HomeTabOne({super.key});

  @override
  State<HomeTabOne> createState() => _HomeTabOneState();
}

class _HomeTabOneState extends State<HomeTabOne> {
  final ScrollController _recentAlbumscontroller = ScrollController();
  final ScrollController _lastAlbumcontroller = ScrollController();
  final ScrollController _randomAlbumcontroller = ScrollController();
  final ScrollController _mostAlbumscontroller = ScrollController();

  var controller = Get.find<HomeController>();

  List<Albums> get _randomalbums => controller.randomalbums.value;
  List<Albums> get _lastalbums => controller.lastalbums.value;
  List<Albums> get _mostalbums => controller.mostalbums.value;
  List<Albums> get _recentalbums => controller.recentalbums.value;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _recentAlbumscontroller.dispose();
    _lastAlbumcontroller.dispose();
    _randomAlbumcontroller.dispose();
    _mostAlbumscontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      double itemHeight = min(250, constraints.maxWidth / (isMobile ? 2.5 : 4));

      return Obx(
        () => CustomScrollView(
          slivers: [
            if (_randomalbums.isNotEmpty)
              SliverToBoxAdapter(
                child: HomeRecommand(
                  albums: _randomalbums,
                ),
              ),
            if (_mostalbums.isNotEmpty)
              SliverToBoxAdapter(
                  child: MySliverControlBar(
                title: S.current.play + S.current.most,
                controller: _mostAlbumscontroller,
              )),
            if (_mostalbums.isNotEmpty)
              SliverToBoxAdapter(
                child: MySliverControlList(
                  controller: _mostAlbumscontroller,
                  albums: _mostalbums,
                  height: itemHeight,
                ),
              ),
            if (_recentalbums.isNotEmpty)
              SliverToBoxAdapter(
                  child: MySliverControlBar(
                title: S.current.last + S.current.play,
                controller: _recentAlbumscontroller,
              )),
            if (_recentalbums.isNotEmpty)
              SliverToBoxAdapter(
                  child: MySliverControlList(
                controller: _recentAlbumscontroller,
                albums: _recentalbums,
                height: itemHeight,
              )),
            if (_lastalbums.isNotEmpty)
              SliverToBoxAdapter(
                child: MySliverControlBar(
                  title: S.current.last + S.current.add,
                  controller: _lastAlbumcontroller,
                ),
              ),
            if (_lastalbums.isNotEmpty)
              SliverToBoxAdapter(
                child: MySliverControlList(
                  controller: _lastAlbumcontroller,
                  albums: _lastalbums,
                  height: itemHeight,
                ),
              ),
            SliverToBoxAdapter(child: MBottomPlaceholder())
          ],
        ),
      );
    });
  }
}
