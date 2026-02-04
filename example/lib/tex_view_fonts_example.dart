import 'package:design_system/gen/assets.gen.dart';
import 'package:design_system/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class TeXViewFontsExamples extends StatelessWidget {
  final TeXViewRenderingEngine renderingEngine;

  const TeXViewFontsExamples(
      {super.key, this.renderingEngine = const TeXViewRenderingEngine.katex()});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("TeXView Fonts"),
      ),
      body: TeXView(
          fonts: [
            const TeXViewFont(fontFamily: 'army', src: 'fonts/Army.ttf'),
            const TeXViewFont(fontFamily: 'budhrg', src: 'fonts/Budhrg.ttf'),
            const TeXViewFont(fontFamily: 'celtg', src: 'fonts/CELTG.ttf'),
            const TeXViewFont(fontFamily: 'hillock', src: 'fonts/hillock.ttf'),
            const TeXViewFont(
                fontFamily: 'intimacy', src: 'fonts/intimacy.ttf'),
            const TeXViewFont(
                fontFamily: 'sansation_light', src: 'fonts/SansationLight.ttf'),
            const TeXViewFont(
                fontFamily: 'slenmini', src: 'fonts/slenmini.ttf'),
            const TeXViewFont(
                fontFamily: 'subaccuz_regular',
                src: 'fonts/SubaccuzRegular.ttf'),
            TeXViewFont(
              fontFamily: DSFonts.beVietnamPro,
              src: DSAssets.fonts.beVietnamProRegular,
            ),
          ],
          renderingEngine: renderingEngine,
          child: TeXViewColumn(children: [
            _teXViewWidget("Subaccuz Regular", 'army'),
            _teXViewWidget("Subaccuz Regular", 'budhrg'),
            _teXViewWidget("Subaccuz Regular", 'celtg'),
            _teXViewWidget("Subaccuz Regular", 'hillock'),
            _teXViewWidget("Subaccuz Regular", 'intimacy'),
            _teXViewWidget("Subaccuz Regular", 'sansation_light'),
            _teXViewWidget("Subaccuz Regular", 'slenmini'),
            _teXViewWidget("Subaccuz Regular", 'subaccuz_regular'),
            _teXViewWidget("Subaccuz Regular", DSFonts.beVietnamPro),
          ]),
          style: const TeXViewStyle(
            margin: TeXViewMargin.all(10),
            elevation: 10,
            borderRadius: TeXViewBorderRadius.all(25),
            border: TeXViewBorder.all(
              TeXViewBorderDecoration(
                  borderColor: Colors.blue,
                  borderStyle: TeXViewBorderStyle.solid,
                  borderWidth: 5),
            ),
            backgroundColor: Colors.white,
          ),
          loadingWidgetBuilder: (context) => const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text("Rendering...")
                  ],
                ),
              )),
    );
  }

  static TeXViewWidget _teXViewWidget(String title, String fontFamily) {
    return TeXViewColumn(
        style: const TeXViewStyle(
            margin: TeXViewMargin.all(5),
            padding: TeXViewPadding.all(5),
            borderRadius: TeXViewBorderRadius.all(10),
            border: TeXViewBorder.all(TeXViewBorderDecoration(
                borderWidth: 2,
                borderStyle: TeXViewBorderStyle.groove,
                borderColor: Colors.green))),
        children: [
          TeXViewDocument(title,
              style: TeXViewStyle(
                  fontStyle: TeXViewFontStyle(
                      fontSize: 20,
                      sizeUnit: TeXViewSizeUnit.pt,
                      fontFamily: fontFamily),
                  padding: const TeXViewPadding.all(10),
                  borderRadius: const TeXViewBorderRadius.all(10),
                  textAlign: TeXViewTextAlign.center,
                  width: 250,
                  margin: const TeXViewMargin.zeroAuto())),
        ]);
  }
}
