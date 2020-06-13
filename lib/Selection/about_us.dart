import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tslm/Size/size.dart';

class AboutUsTest extends StatefulWidget {
  @override
  _AboutUsTestState createState() => _AboutUsTestState();
}

class _AboutUsTestState extends State<AboutUsTest> {
  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    double _width = ScreenSize.safeBlockHorizontal;
    double _height = ScreenSize.safeBlockVertical;
    return Scaffold(
      //backgroundColor: Color(0xffe7eff7),
      backgroundColor: Color(0xffe8eff7),
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Padding(
            padding: EdgeInsets.only(top: _height * 10),
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: <Widget>[
                  Container(
                      height: _height * 5,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ExactAssetImage('assets/logo_full.png')))),
                  Padding(
                    padding: EdgeInsets.only(top: _height * 1.5),
                    child: Divider(
                      color: Colors.grey,
                      indent: 45,
                      endIndent: 45,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _height * 15),
                    child: Container(
                        child: Text('About us',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xfff27186)))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _height * 2),
                    child: Container(
                        //color: Colors.transparent,
                        width: _width * 80,
                        height: _height * 55,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: ListView(
                          children: <Widget>[
                            Text('daddasdadasdasdasdasdaddasdadasdasdasdasdaddasdadasdasdasdasdaddasdadasdasdasdasdaddasdadasdasdasdasdaddasdadasdasdasdasdaddasdadasdasdasdasdaddasdadasdasdasdasdaddasdadasdasdasdasdaddasdadasdasdasdasdaddasdadasdasdasdasdaddasdadasdasdasdas',
                            style: TextStyle(color: Color(0xff3979b7))),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
