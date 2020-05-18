import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tslm/Navigation.dart';
import 'package:tslm/Selection/Status.dart';
import 'package:tslm/rest_api/rest_api.dart';
import 'package:tslm/userAction/login.dart';
import 'package:tslm/Size/size.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

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
    _getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    double _width = ScreenSize.safeBlockHorizontal;
    double _height = ScreenSize.safeBlockVertical;
    name.text = userdata != null ? '${userdata["name"]}' : '';
    phoneNumber.text = userdata != null ? '${userdata["phoneNumber"]}' : '';
    email.text = userdata != null ? '${userdata["email"]}' : '';
    return Scaffold(
      backgroundColor: Color(0xffe8eff7),
      // key: _scaffoldKey,
      body: Form(
        //    key: _formKey,

        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Container(
                height: _height * 5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: ExactAssetImage('assets/logo_full.png'))),
              ),
            ),
            SizedBox(
              height: _height * 2,
            ),
            Container(
                child: Center(
                    child: Divider(
              indent: 40,
              endIndent: 40,
              thickness: 1,
              color: Colors.grey,
            ))),
            SizedBox(
              height: _height * 15,
            ),
            Center(
                child: Text('Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfff27186),
                    ))),
            SizedBox(
              height: _height * 5.5,
            ),
            Center(
              child: Container(
                height: _height * 5,
                width: _width * 80,
                child: TextFormField(
                  onChanged: (_) {
                    _updateName();
                  },
                  style: new TextStyle(color: Colors.black),
                  validator: (input) =>
                      input.length < 6 ? 'Please Enter a valid password' : null,
                  controller: name,
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: _height, left: _width * 3),
                    filled: true,
                    hintStyle: TextStyle(
                        // fontSize: 13,
                        color: Color(0xFFbdc6cf),
                        fontWeight: FontWeight.w500),
                    fillColor: Colors.white,
                    hintText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color(0xff3979b7)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _height * 1.5,
            ),
            Center(
              child: Container(
                height: _height * 5,
                width: _width * 80,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  onChanged: (_) {
                    _updateNumber();
                  },
                  style: new TextStyle(color: Colors.black),
                  validator: (input) =>
                      input.length < 6 ? 'Please Enter a valid password' : null,
                  controller: phoneNumber,
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: _height, left: _width * 3),
                    filled: true,
                    hintStyle: TextStyle(
                        //fontSize: 13,
                        color: Color(0xFFbdc6cf),
                        fontWeight: FontWeight.w500),
                    fillColor: Colors.white,
                    hintText: 'email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color(0xff3979b7)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _height * 1.5,
            ),
            Center(
              child: Container(
                height: _height * 5,
                width: _width * 80,
                child: TextFormField(
                  onChanged: (_) {
                    _updateEmail();
                  },
                  style: new TextStyle(color: Colors.black),
                  validator: (input) =>
                      input.length < 6 ? 'Please Enter a valid password' : null,
                  controller: email,
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: _height, left: _width * 3),
                    filled: true,
                    hintStyle: TextStyle(
                        //   fontSize: 13,
                        color: Color(0xFFbdc6cf),
                        fontWeight: FontWeight.w500),
                    fillColor: Colors.white,
                    hintText: 'PhoneNumber',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color(0xff3979b7)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    height: _height * 4,
                    width: _width * 30,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          // _getdata();
                          _save();
                        },
                        child: Text('update',
                            style: TextStyle(color: Colors.white)),
                        color: Color(0xfff27186)),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Center(
                  child: Container(
                    height: _height * 4,
                    width: _width * 30,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          // _getdata();
                          _logout();
                        },
                        child: Text('logout',
                            style: TextStyle(color: Colors.white)),
                        color: Color(0xfff27186)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _updateName() {
    userdata["name"] = name.text;
  }

  void _updateNumber() {
    userdata["phoneNumber"] = phoneNumber.text;
  }

  void _updateEmail() {
    userdata["email"] = email.text;
  }

  void _save() async {
    Dialogs.showLoadingDialog(
        context, _keyLoader, 'Saving your updates...', 0, false);

    var data = {
      "name": name.text,
      "phoneNumber": phoneNumber.text,
      "email": email.text
    };

    await CallApi().postData(data, '/user/' + '${userdata["_id"]}');

    SharedPreferences storage = await SharedPreferences.getInstance();

    var jsonString = storage.getString("user");
    var yourJson = json.decode(jsonString);
    print('${yourJson['name']}');
    yourJson['name'] = name.text;
    yourJson['phoneNumber'] = phoneNumber.text;
    yourJson['email'] = email.text;

    storage.setString("user", jsonEncode(yourJson));
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Navigation(
                  name: name.text,
                )));
  }

  _logout() async {
    SharedPreferences storage = await SharedPreferences.getInstance();

    storage.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }
}
