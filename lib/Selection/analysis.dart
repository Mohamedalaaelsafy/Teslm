import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tslm/Size/size.dart';
import 'package:tslm/model/user.dart';

import 'package:http/http.dart' as http;





class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
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
    return Scaffold(
       backgroundColor: Color(0xffe8eff7),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[ 
          SizedBox(height:_height*10),
          Container( 
           // padding: EdgeInsets.only(left:150) ,
            child: Center(child: Text('Reading Analysis' , style: TextStyle(fontSize: 20),)),
          ),
          SizedBox(height: _height*2,),
          FutureBuilder(
                               future: readingHistory(),
                               builder: (BuildContext context , AsyncSnapshot snapshot){
                                 if(snapshot.data == null){
                                   return Center(
                                     child: Container(
                                       height:33,
                                       width:33,
                                       child: CircularProgressIndicator(),
                                     ),
                                   );
                                 }
                                 else if(snapshot.data.last.heartbeat - snapshot.data[snapshot.data.length-2].heartbeat <= 10  && snapshot.data.last.heartbeat - snapshot.data[snapshot.data.length-2].heartbeat  >= 1){
                                   return Text('Normal'); 
                                 }
                                 else if(snapshot.data.last.heartbeat == snapshot.data[snapshot.data.length-2].heartbeat){
                                   print(snapshot.data.last.heartbeat);
                                   print( snapshot.data[snapshot.data.length-2].heartbeat); 
                                   return Text('Normal');
                                 }else if(snapshot.data.last.heartbeat - snapshot.data[snapshot.data.length-2].heartbeat > 10){
                                   return Text('High');
                                 }
                                 
                                 else{
                                   return Text('high');
                                 }
                               },
                             ),
                             SizedBox(height: _height*2,),

                                   Container(
                    width: _width * 40,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          // _saveDataToHistory();
                          Navigator.pop(context);
                        },
                        child: Text('Close',
                            style: TextStyle(color: Colors.white)),
                        color: Color(0xfff27186)),
                  ),
        ],
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

}