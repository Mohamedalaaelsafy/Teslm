import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tslm/model/user.dart';
import 'package:tslm/Size/size.dart';

class ProgilePage extends StatefulWidget {
  @override
  _ProgilePageState createState() => _ProgilePageState();
}

class _ProgilePageState extends State<ProgilePage> {
  User user = User();
  var userdata;
  void _getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userjson = localStorage.getString("user");
    var user = json.decode(userjson);
    setState(() {
      userdata = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    double _width = ScreenSize.safeBlockHorizontal;
    double _height = ScreenSize.safeBlockVertical;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss  EEE d MMM').format(now);
    return Scaffold(
      backgroundColor: Color(0xffe8eff7),
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
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
                  SizedBox(height: _height * 5),
                  ListTile(
                    leading: Container(
                      height: _height * 10,
                      width: _width * 30,
                      child: Center(
                        child: CircleAvatar(
                          radius: 140,
                          child: Image.asset(
                            'assets/—Pngtree—business white shirt white-collar male_4154888.png',
                            fit: BoxFit.cover,
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(userdata != null ? '${userdata["name"]}' : '',
                        style: TextStyle(
                            color: Color(0xff3979b7),
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    subtitle: Text(
                        userdata != null ? '${userdata["email"]}' : '',
                        style: TextStyle(color: Color(0xff3979b7))),
                  ),
                  Container(
                      child: Center(
                          child: Divider(
                              indent: 40,
                              endIndent: 40,
                              thickness: 1,
                              color: Colors.grey))),
                  SizedBox(
                    height: _height * 2.5,
                  ),
                  Row(
                    // textDirection: TextDirection,
                    children: <Widget>[
                      SizedBox(
                        width: _width * 15,
                      ),
                      Image.asset('assets/calendar.png',
                          scale: 33, color: Color(0xff3979b7)),
                      SizedBox(
                        width: 8,
                      ),
                      Text('06 April 1988',
                          style: TextStyle(color: Color(0xff3979b7))),
                      SizedBox(
                        width: _width * 20,
                      ),
                      Image.asset(
                        'assets/business.png',
                        scale: 33,
                        color: Color(0xff3979b7),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('75 KG', style: TextStyle(color: Color(0xff3979b7))),
                    ],
                  ),
                  SizedBox(
                    height: _height * 2.5,
                  ),
                  Row(
                    //textDirection: TextDirection.ltr,
                    children: <Widget>[
                      SizedBox(
                        width: 60,
                      ),
                      Image.asset(
                        'assets/maps-and-flags.png',
                        scale: 33,
                        color: Color(0xff3979b7),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Cairo,Egypt',
                          style: TextStyle(color: Color(0xff3979b7))),
                      SizedBox(
                        width: 90,
                      ),
                      Image.asset('assets/ruler.png',
                          scale: 33, color: Color(0xff3979b7)),
                      SizedBox(
                        width: 8,
                      ),
                      Text('180 cm',
                          style: TextStyle(color: Color(0xff3979b7))),
                    ],
                  ),
                  SizedBox(
                    height: _height * 2.5,
                  ),
                  Container(
                      child: Center(
                          child: Divider(
                    indent: 40,
                    endIndent: 40,
                    thickness: 1,
                  ))),
                  SizedBox(
                    height: _height * 2.5,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 60,
                      ),
                      Image.asset(
                        'assets/icons-06.png',
                        scale: 10,
                        color: Color(0xff3979b7),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Cairo,Egypt',
                          style: TextStyle(color: Color(0xff3979b7))),
                    ],
                  ),
                  SizedBox(
                    height: _height * 2.5,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 60,
                      ),
                      Icon(Icons.markunread,
                          size: 15, color: Color(0xff3979b7)),
                      SizedBox(
                        width: 12,
                      ),
                      Text('$formattedDate',
                          style: TextStyle(color: Color(0xff3979b7))),
                    ],
                  ),
                  SizedBox(
                    height: _height * 2.5,
                  ),
                  Container(
                      child: Center(
                          child: Divider(
                    indent: 40,
                    endIndent: 40,
                    thickness: 1,
                  ))),
                  SizedBox(
                    height: _height * 2.5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: _width * 15),
                    child: Container(
                        alignment: Alignment.topLeft,
                        child: Text('Medical history',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xfff27186)))),
                  ),
                  SizedBox(
                    height: _height,
                  ),
                  Container(
                    // color: Colors.white,
                    width: _width * 80,
                    height: _height * 55,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: FutureBuilder(
                      future: readingHistory(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Center(
                            child: Container(
                              height: 33,
                              width: 33,
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Color(0xfff27186))),
                            ),
                          );
                        } else if (snapshot.data.length == 0) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 120),
                              child: Text(
                                "No Data is saved",
                                style: TextStyle(color: Color(0xfff27186)),
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Text(
                                  '${snapshot.data[index].heartbeat}',
                                  style: TextStyle(
                                      fontSize: 25, color: Color(0xff3979b7)),
                                ),
                                title: Text(
                                  "${snapshot.data[index].date}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff3979b7)),
                                ),
                                onTap: () {},
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<UserHistory>> readingHistory() async {
    var data = await http.get("https://heartbeatsproject.herokuapp.com/user/" +
        "${userdata['_id']}/");
    var jsonData = json.decode(data.body);
    List<UserHistory> users = [];
    var newJsonData = jsonData['User']['user_history'];
    for (var u in newJsonData) {
      UserHistory user = UserHistory(u['heart_Beat'], u['date']);
      users.add(user);
    }
     print(users.last.heartbeat);
     print(users[users.length-2].heartbeat); 
    return users;
  }

  showDialoug(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ok'))
            ],
          );
        });
  }
}
