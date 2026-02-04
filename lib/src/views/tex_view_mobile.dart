import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/utils/core_utils.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class TeXViewState extends State<TeXView> with AutomaticKeepAliveClientMixin {
  late WebViewControllerPlus _controller;

  double _height = minHeight;
  String? _lastData;
  bool _pageLoaded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewControllerPlus()
      ..loadFlutterAsset(
          "packages/flutter_tex/js/${widget.renderingEngine?.name ?? 'katex'}/index.html")
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'TeXViewRenderedCallback',
        onMessageReceived: (jm) {
          final height = double.tryParse(jm.message);
          if (height != null && _height != height) {
            setState(() {
              _height = height;
            });
            widget.onRenderFinished?.call(height);
          }
        },
      )
      ..addJavaScriptChannel(
        'OnTapCallback',
        onMessageReceived: (jm) {
          widget.child.onTapCallback(jm.message);
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          _pageLoaded = true;
          _initTeXView();
        },
      ))
      ..setOnConsoleMessage((message) {
        log("flutter_tex: ${message.message}");
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    updateKeepAlive();
    _initTeXView();
    return IndexedStack(
      index: widget.loadingWidgetBuilder?.call(context) != null
          ? _height == minHeight
              ? 1
              : 0
          : 0,
      children: <Widget>[
        SizedBox(
            height: _height,
            child: WebViewWidget(
              controller: _controller,
              gestureRecognizers: {
                Factory(() => HorizontalDragGestureRecognizer())
              },
            )
            // child: WebViewPlus(

            //   initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            //   allowsInlineMediaPlayback: true,

            ),
        widget.loadingWidgetBuilder?.call(context) ?? const SizedBox.shrink()
      ],
    );
  }

  void _initTeXView() {
    if (_pageLoaded && getRawData(widget) != _lastData) {
      if (widget.loadingWidgetBuilder != null) _height = minHeight;
      _controller.runJavaScript(
          "try { initView(${getRawData(widget)}) } catch (e) { console.error(e) }");
      _lastData = getRawData(widget);
    }
  }
}
