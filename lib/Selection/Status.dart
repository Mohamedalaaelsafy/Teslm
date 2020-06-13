 import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tslm/Selection/analysis.dart';
import 'dart:async';
import 'package:tslm/Size/size.dart';
import 'package:tslm/model/user.dart';
import 'package:tslm/rest_api/rest_api.dart';
import 'package:tslm/sqflite/dbhelper.dart';
import 'package:tslm/sqflite/sqlmode.dart';
import 'package:http/http.dart' as http;

class Test1 extends StatefulWidget {
  final name;
  final phoneNumbaer;
  const Test1({Key key, this.name, this.phoneNumbaer}) : super(key: key);
  @override
  _Test1State createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  User user = User();
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  var userdata;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
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

  location() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}  + and + ${position.longitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);

    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    var lat = position.latitude;
    var lon = position.longitude;
    print("${first.featureName} : ${first.addressLine}");
  }

  _emergencyMSG() async {
    Dialogs.showLoadingDialog(
        context, _keyLoader, 'Sending Message...', 0, false);
    await location().then((_) async {
      SmsSender sender = new SmsSender();
      for (var i = 0; i < noteList.length; i++) {
        List subjects = ["${noteList[i].description}"];
        for (String sName in subjects) {
          print(sName);
          await sender.sendSms(SmsMessage(sName, 'Help!'));
        }
      }
    });
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    _showDialoug('Done');
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    double _width = ScreenSize.safeBlockHorizontal;
    double _height = ScreenSize.safeBlockVertical;
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      backgroundColor: Color(0xffe8eff7),
      body: Container(
        child: SingleChildScrollView(
          child: AnimationLimiter(
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
                  SizedBox(height: _height * 4.5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
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
                          title: Text(
                              userdata != null ? '${userdata["name"]}' : '',
                              style: TextStyle(
                                  color: Color(0xff3979b7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          subtitle: Text(
                              userdata != null ? '${userdata["email"]}' : '',
                              style: TextStyle(color: Color(0xff3979b7))),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      child: Center(
                          child: Divider(
                    indent: 40,
                    endIndent: 40,
                    thickness: 1,
                    color: Colors.grey,
                  ))),
                  SizedBox(height: _height * 4),
                  Center(
                    child: Text('Heart Rate',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xfff27186),
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _height * 3.5),
                    child: Container(
                      height: _height * 20,
                      width: _width * 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: Center(
                              child: Container(
                                //  width: _width * 85 ,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                        image: ExactAssetImage(
                                            "assets/heartrate.gif"))),
                              ),
                            ),
                          ),
                          Positioned(
                            child: StreamBuilder(
                              stream: Stream.periodic(Duration(seconds: 30))
                                  .asyncMap((i) => _getReading()),
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: _width * 70, top: _height),
                                    child: Container(
                                      // height: 33,
                                      // width: 33,
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Color(0xfff27186))),
                                    ),
                                  );
                                } else if (snapshot.data.heartbeat == 40) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          left: _width * 70, top: _height - 4),
                                      child: CircularPercentIndicator(
                                        radius: 40.0,
                                        lineWidth: 4.0,
                                        percent: snapshot.data.heartbeat / 100,
                                        center: Text(
                                            "${snapshot.data.heartbeat}",
                                            style: TextStyle(
                                                color: Colors.yellow[800])),
                                        progressColor: Colors.yellow[800],
                                      ));
                                } else if (snapshot.data.heartbeat < 40) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          left: _width * 70, top: _height - 4),
                                      child: CircularPercentIndicator(
                                        radius: 40.0,
                                        lineWidth: 4.0,
                                        percent: snapshot.data.heartbeat / 100,
                                        center: Text(
                                            "${snapshot.data.heartbeat}",
                                            style: TextStyle(
                                                color: Colors.red[800])),
                                        progressColor: Colors.red[800],
                                      ));
                                } else if (snapshot.data.heartbeat == 100) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          left: _width * 70, top: _height - 4),
                                      child: CircularPercentIndicator(
                                        radius: 40.0,
                                        lineWidth: 4.0,
                                        percent: 1,
                                        center: Text(
                                            "${snapshot.data.heartbeat}",
                                            style: TextStyle(
                                                color: Colors.yellow[800])),
                                        progressColor: Colors.yellow[800],
                                      ));
                                } else if (snapshot.data.heartbeat > 100) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          left: _width * 70, top: _height - 4),
                                      child: CircularPercentIndicator(
                                        radius: 40.0,
                                        lineWidth: 4.0,
                                        percent: 1,
                                        center: new Icon(
                                          Icons.warning,
                                          color: Colors.red[600],
                                          size: 18,
                                        ),
                                        progressColor: Colors.red[600],
                                      ));
                                }else
                                  //getdata();
                                  //  _readingHistory();
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          left: _width * 70, top: _height - 4),
                                      child: CircularPercentIndicator(
                                        radius: 40.0,
                                        lineWidth: 4.0,
                                        percent: snapshot.data.heartbeat / 100,
                                        center: new Text(
                                            "${snapshot.data.heartbeat}"),
                                        progressColor: Color(0xfff27186),
                                      ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height,
                  ),
                  Container(
                    width: _width * 40,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          // _saveDataToHistory();
                          checkValue();
                        },
                        child: Text('Check',
                            style: TextStyle(color: Colors.white)),
                        color: Color(0xfff27186)),
                  ),
                  Container(
                      width: _width * 40,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            _emergencyMSG();
                          },
                          child: Text('Send Emergency SMS',
                              style: TextStyle(color: Colors.white)),
                          color: Colors.black)),
                  SizedBox(
                    height: _height * 7,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text('About' , style: TextStyle(fontSize: 22 ),),
                        SizedBox(height: 10,),
                        Container(
                          child: Text(
                            'sdasdadasdasdasdasdas'
                          ),
                        ),
                         Container(
                    width: _width * 60,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          // _saveDataToHistory();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Analysis()));
                        },
                        child: Text('Analysis',
                            style: TextStyle(color: Colors.white)),
                        color: Color(0xfff27186)),
                  ),
                      ],
                    ),
                  )
                  // Container(
                  //   width: 400,
                  //   height: 300,
                  //   child: DefaultTabController(
                  //       length: 2,
                  //       child: Scaffold(
                  //         backgroundColor: Color(0xffe8eff7),
                  //         appBar: PreferredSize(
                  //           preferredSize: Size.fromHeight(17),
                  //           child: TabBar(
                  //               unselectedLabelColor: Color(0xfff27186),
                  //               indicatorSize: TabBarIndicatorSize.label,
                  //               indicator: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(50),
                  //                   color: Colors.white),
                  //               tabs: [
                  //                 Tab(
                  //                   child: Container(
                  //                     decoration: BoxDecoration(
                  //                         borderRadius:
                  //                             BorderRadius.circular(50),
                  //                         border: Border.all(
                  //                             color: Colors.white, width: 1)),
                  //                     child: Align(
                  //                       alignment: Alignment.center,
                  //                       child: Text("Heart Rate",
                  //                           style: TextStyle(
                  //                               color: Color(0xfff27186))),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Tab(
                  //                   child: Container(
                  //                     decoration: BoxDecoration(
                  //                         borderRadius:
                  //                             BorderRadius.circular(50),
                  //                         border: Border.all(
                  //                             color: Colors.white, width: 1)),
                  //                     child: Align(
                  //                       alignment: Alignment.center,
                  //                       child: Text("Analsys",
                  //                           style: TextStyle(
                  //                               color: Color(0xfff27186))),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ]),
                  //         ),
                  //         body: TabBarView(children: [

                            
                  //            FutureBuilder(
                  //              future: readingHistory(),
                  //              builder: (BuildContext context , AsyncSnapshot snapshot){
                  //                if(snapshot.data == null){
                  //                  return Center(
                  //                    child: Container(
                  //                      height:33,
                  //                      width:33,
                  //                      child: CircularProgressIndicator(),
                  //                    ),
                  //                  );
                  //                }
                  //                else if(snapshot.data.last.heartbeat - snapshot.data[snapshot.data.length-2].heartbeat <= 10  && snapshot.data.last.heartbeat - snapshot.data[snapshot.data.length-2].heartbeat  >= 1){
                  //                  return Text('normal normal'); 
                  //                }
                  //                else if(snapshot.data.last.heartbeat == snapshot.data[snapshot.data.length-2].heartbeat){
                  //                  print(snapshot.data.last.heartbeat);
                  //                  print( snapshot.data[snapshot.data.length-2].heartbeat); 
                  //                  return Text('normal');
                  //                }
                                 
                  //                else{
                  //                  return Text('normalsassas');
                  //                }
                  //              },
                  //            ),
                  //           //Center(child: Text('Nothing to show')),
                  //           Center(child: Text('Nothing to show')),
                  //         ]), 
                  //       )),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<User> _getReading() async {
    final response =
        await CallApi().getData('/user/' + '5ec2db1a80c9a300041a8113/');
    final body = json.decode(response.body);
    var heartRate = body["User"]["heartBeat"];
    var data = {"heart_Beat": heartRate};
    await CallApi().postData(data, '/user/history/' + '${userdata['_id']}/');
    return User.fromJson(body);
  }

  // Future saveData() async {
  //   await _getReading().then((value) async {
  //     num _data;

  //     setState(() {
  //       _data = value.heartbeat;
  //     });

  //     var data = {"heart_Beat": _data};

  //     await CallApi().postData(data, '/user/history/' + '${userdata['_id']}/');
  //     Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  //     return _data;
  //   });
  // }


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
          var beforelast =users[users.length-2].heartbeat;
      var last = users.last;
            
      if(beforelast == last){

      }
    // print(users.last.heartbeat);
    return users;
  }

  readingAnalysis()async{
    await readingHistory().then((users){
      var beforelast =users[users.length-2].heartbeat;
    
    });
  }

  checkValue() async {
    await _getReading().then((value) {
      if (value.heartbeat <= 40) {
        return _showDialoug('low');
      } else if (value.heartbeat >= 100) {
        return _showDialoug('high');
      } else {
        _showDialoug('Normal');
      }
    });
  }

  // _saveDataToHistory() async {
  //   Dialogs.showLoadingDialog(context, _keyLoader, 'Saving....', 0, false);
  //   final response =
  //       await CallApi().getData('/user/' + '5ec2db1a80c9a300041a8113/');
  //   final body = json.decode(response.body);
  //   num heartRate = body["User"]["heartBeat"];
  //   num _new1;
  //   setState(() {
  //     _new1 = heartRate;
  //   });
  //   print(_new1);
  //   var data = {"heart_Beat": _new1};
  //   await CallApi().postData(data, '/user/history/' + '${userdata['_id']}/');
  //   Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  //   _showDialoug('data successfully saved');
  // }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  _showDialoug(text) {
    showDialog(
        context: context,
        builder: (dcontext) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
          });
          return WillPopScope(
            onWillPop: () async => true,
            child: AlertDialog(
              content: Container(
                  height: 45,
                  child: Center(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //SizedBox(width: 30),
                      Text(text, style: TextStyle(color: Colors.black)),
                      SizedBox(width: 5),
                      // Icon(
                      //   Icons.done,
                      //   color: Colors.black,
                      // )
                    ],
                  ))),
            ),
          );
        });
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key,
      String details, int seconds, bool n) async {
    n = true;
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(
            Duration(seconds: seconds),
          );
          return new WillPopScope(
              onWillPop: () async => true,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.black)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(details, style: TextStyle(color: Colors.black))
                      ]),
                    )
                  ]));
        });
  }
}
