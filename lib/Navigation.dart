import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tslm/Selection/Status.dart';
import 'package:tslm/Selection/about_us.dart';
import 'package:tslm/Selection/edit.dart';
import 'package:tslm/Selection/emergency_test.dart';
import 'package:tslm/Selection/profile_page.dart';
import 'package:tslm/Size/size.dart';

class Navigation extends StatefulWidget {
  final name;
  final phoneNumbaer;
  const Navigation({Key key, this.name, this.phoneNumbaer}) : super(key: key);
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final _pages = [
    AboutUsTest(),
    ProgilePage(),
    Test1(),
    EmergencyText(),
    Edit()
  ];
  int _currentTab = 2;
  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    double _width = ScreenSize.safeBlockHorizontal;
    double _height = ScreenSize.safeBlockVertical;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    return Scaffold(
      extendBody: true,
      body: _pages[_currentTab],
      bottomNavigationBar: RotatedBox(
        quarterTurns: 2,
        child: ClipPath(
          child: new Container(
            height: _height * 13.5,
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            child: RotatedBox(
                quarterTurns: 2,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: _height * 4.5),
                    child: CupertinoTabBar(
                      inactiveColor: Color(0xfff27186),
                      border: Border.all(color: Colors.transparent),
                      backgroundColor: Colors.white,
                      currentIndex: _currentTab,
                      onTap: (int index) {
                        setState(() {
                          _currentTab = index;
                        });
                      },
                      activeColor: Color(0xfff27186),
                      items: [
                        BottomNavigationBarItem(
                          icon: Padding(
                              padding: EdgeInsets.only(
                                  top: _height * 3, left: _width * 3),
                              child: Container(
                                  height: _height * 3,
                                  child: Image.asset(
                                    'assets/about-us.png',
                                    color: Color(0xff3979b7),
                                  ))),
                          //   title: Text('about us')
                        ),
                        BottomNavigationBarItem(
                            icon: Container(
                                height: _height * 3,
                                child: Image.asset(
                                  'assets/icons-03.png',
                                  color: Color(0xff3979b7),
                                ))),
                        BottomNavigationBarItem(
                          icon: Padding(
                              padding: EdgeInsets.only(bottom: _height * 2),
                              child: Container(
                                  height: _height * 4,
                                  child: Image.asset(
                                    'assets/icons-02.png',
                                    color: Color(0xfff27186),
                                  ))),
                        ),
                        BottomNavigationBarItem(
                            icon: Container(
                                height: _height * 3.5,
                                child: Image.asset(
                                  'assets/icons-04.png',
                                  color: Color(0xff3979b7),
                                ))),
                        BottomNavigationBarItem(
                          icon: Padding(
                              padding: EdgeInsets.only(
                                  top: _height * 3, right: _width * 3.2),
                              child: Container(
                                  height: _height * 2.5,
                                  child: Icon(
                                    Icons.settings,
                                    color: Color(0xff3979b7),
                                    size: 25,
                                  ))),
                          // title: Text('.' , style:TextStyle( fontSize: 20))
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          clipper: RoundedClipper(),
        ),
      ),
    );
  }
}

class RoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 70);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 70);
    path.lineTo(size.width, .0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
