import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/constant.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/widgets/music_bar/music_bar.dart';

class MusicBarService extends GetxService {
  static OverlayEntry? overlayEntry;

  static RxBool hideBar = false.obs;

  Future<MusicBarService> init() async {
    return this;
  }

  static show({double? top, double? left}) {
    var context = navigatorKey.currentState?.context;
    if (context == null || !isMobile) {
      return;
    }

    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return MusicBarWidget(
          top: top ?? 100,
          left: left ?? 100,
          child: Material(
            color: Colors.transparent,
            child: MusicBar(),
          ),
        );
      });

      Overlay.of(context).insert(overlayEntry!);
    }
  }

  ///隐藏音乐栏
  static hide() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}

class MusicBarWidget extends StatefulWidget {
  final double top;
  final double left;
  final Widget child;
  final Duration duration = const Duration(milliseconds: 300);

  const MusicBarWidget({
    super.key,
    required this.top,
    required this.left,
    required this.child,
  });

  @override
  State<MusicBarWidget> createState() => _MusicBarWidgetState();
}

class _MusicBarWidgetState extends State<MusicBarWidget>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  double left = 0;
  double top = 0;
  double maxX = 0;
  double maxY = 0;
  var parentKey = GlobalKey();
  var childKey = GlobalKey();
  var parentSize = const Size(0, 0);
  var childSize = const Size(0, 0);
  late StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = eventBus.on().listen((event) {
      EventObj eventObj = event;
      if (eventObj.code == EventCode.toBottom) {
        toBottom();
      }
      if (eventObj.code == EventCode.riseUp) {
        riseUp();
      }
    });
    left = widget.left;
    top = widget.top;
    WidgetsBinding.instance.addPostFrameCallback((d) {
      parentSize = getWidgetSize(parentKey);
      childSize = getWidgetSize(childKey);
      maxX = parentSize.width - childSize.width;
      maxY = parentSize.height - childSize.height;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Stack(
      key: parentKey,
      fit: StackFit.expand,
      children: [
        Positioned(
          key: childKey,
          width: width,
          left: 0,
          bottom: 10,
          child: widget.child,
        )
      ],
    );
  }

  //底部导航栏消失时沉底
  void toBottom() {
    _controller = AnimationController(vsync: this)..duration = widget.duration;
    var animation = Tween<double>(begin: top, end: maxY).animate(_controller!);
    animation.addListener(() {
      top = animation.value;
      setState(() {});
    });
    _controller!.forward();
  }

  //底部导航栏出现时抬高
  void riseUp() {
    _controller = AnimationController(vsync: this)..duration = widget.duration;
    var animation =
        Tween<double>(begin: top, end: maxY - 56).animate(_controller!);
    animation.addListener(() {
      top = animation.value;
      setState(() {});
    });
    _controller!.forward();
  }

  Size getWidgetSize(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size;
  }
}

EventBus eventBus = EventBus();

enum EventCode { toBottom, riseUp }

class EventObj {
  final EventCode code;

  EventObj(this.code);
}
