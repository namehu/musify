import 'package:flutter/material.dart';
import 'package:musify/api/index.dart';
import 'package:musify/enums/album_list_type_enum.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/myModel.dart';
import '../../../screens/common/mySliverControlBar.dart';
import '../../../screens/common/mySliverControlList.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final ScrollController _recentAlbumscontroller = ScrollController();
  final ScrollController _lastAlbumcontroller = ScrollController();
  final ScrollController _randomAlbumcontroller = ScrollController();
  final ScrollController _mostAlbumscontroller = ScrollController();
  List<Albums>? _randomalbums;
  List<Albums>? _lastalbums;
  List<Albums>? _mostalbums;
  List<Albums>? _recentalbums;

  _getAlbuoms(AlbumListTypeEnum type) async {
    List<Albums> list =
        await MRequest.api.getAlbumList(pageNum: 1, pageSize: 10, type: type);
    if (list.isNotEmpty && mounted) {
      setState(() {
        switch (type) {
          case AlbumListTypeEnum.random:
            _randomalbums = list;
            break;
          case AlbumListTypeEnum.frequent:
            _mostalbums = list;
            break;
          case AlbumListTypeEnum.newest:
            _lastalbums = list;
            break;
          case AlbumListTypeEnum.recent:
            _recentalbums = list;
            break;
          default:
        }
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getAlbuoms(AlbumListTypeEnum.random);
    _getAlbuoms(AlbumListTypeEnum.frequent);
    _getAlbuoms(AlbumListTypeEnum.newest);
    _getAlbuoms(AlbumListTypeEnum.recent);
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
    return CustomScrollView(
      slivers: <Widget>[
        if (_randomalbums != null && _randomalbums!.isNotEmpty)
          SliverToBoxAdapter(
              child: MySliverControlBar(
            title: S.current.random,
            controller: _randomAlbumcontroller,
          )),
        if (_randomalbums != null && _randomalbums!.isNotEmpty)
          SliverToBoxAdapter(
              child: MySliverControlList(
                  controller: _randomAlbumcontroller, albums: _randomalbums!)),
        if (_mostalbums != null && _mostalbums!.isNotEmpty)
          SliverToBoxAdapter(
              child: MySliverControlBar(
            title: S.current.play + S.current.most,
            controller: _mostAlbumscontroller,
          )),
        if (_mostalbums != null && _mostalbums!.isNotEmpty)
          SliverToBoxAdapter(
              child: MySliverControlList(
                  controller: _mostAlbumscontroller, albums: _mostalbums!)),
        if (_recentalbums != null && _recentalbums!.isNotEmpty)
          SliverToBoxAdapter(
              child: MySliverControlBar(
            title: S.current.last + S.current.play,
            controller: _recentAlbumscontroller,
          )),
        if (_recentalbums != null && _recentalbums!.isNotEmpty)
          SliverToBoxAdapter(
              child: MySliverControlList(
                  controller: _recentAlbumscontroller, albums: _recentalbums!)),
        if (_lastalbums != null && _lastalbums!.isNotEmpty)
          SliverToBoxAdapter(
              child: MySliverControlBar(
            title: S.current.last + S.current.add,
            controller: _lastAlbumcontroller,
          )),
        if (_lastalbums != null && _lastalbums!.isNotEmpty)
          SliverToBoxAdapter(
            child: MySliverControlList(
                controller: _lastAlbumcontroller, albums: _lastalbums!),
          ),
        SliverToBoxAdapter(child: MBottomPlaceholder())
      ],
    );
  }
}
