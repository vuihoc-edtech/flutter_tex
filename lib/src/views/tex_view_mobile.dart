import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/utils/core_utils.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class TeXViewState extends State<TeXView> with AutomaticKeepAliveClientMixin {
  late WebViewPlusController _controller;

  double _height = minHeight;
  String? _lastData;
  bool _pageLoaded = false;

  @override
  bool get wantKeepAlive => true;

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
          child: WebViewPlus(
            initialUrl:
                "packages/flutter_tex/js/${widget.renderingEngine?.name ?? 'katex'}/index.html",
            gestureRecognizers: {
              Factory(() => HorizontalDragGestureRecognizer())
            },
            onWebViewCreated: (controller) {
              _controller = controller;
              widget.onWebViewCreated?.call(controller);
            },
            onPageFinished: (message) {
              _pageLoaded = true;
              _initTeXView();
            },
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            navigationDelegate: widget.navigationDelegate,
            allowsInlineMediaPlayback: true,
            javascriptChannels: {
              JavascriptChannel(
                  name: 'TeXViewRenderedCallback',
                  onMessageReceived: (jm) async {
                    final height = double.tryParse(jm.message);
                    if (height != null && _height != height) {
                      setState(() {
                        _height = height;
                      });
                      widget.onRenderFinished?.call(height);
                    }
                  }),
              JavascriptChannel(
                  name: 'OnTapCallback',
                  onMessageReceived: (jm) {
                    widget.child.onTapCallback(jm.message);
                  })
            },
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
        widget.loadingWidgetBuilder?.call(context) ?? const SizedBox.shrink()
      ],
    );
  }

  void _initTeXView() {
    if (_pageLoaded && getRawData(widget) != _lastData) {
      if (widget.loadingWidgetBuilder != null) _height = minHeight;
      _controller.webViewController
          .runJavascript("initView(${getRawData(widget)})");
      _lastData = getRawData(widget);
    }
  }
}
