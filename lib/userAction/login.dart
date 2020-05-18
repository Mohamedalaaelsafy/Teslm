import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tslm/rest_api/rest_api.dart';
import 'package:tslm/Size/size.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _loading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
        backgroundColor: Color(0xffe8eff7),
        key: _scaffoldKey,
        body: widgets(context));
  }

  Widget widgets(BuildContext context) {
    ScreenSize().init(context);
    double _width = ScreenSize.safeBlockHorizontal;
    double _height = ScreenSize.safeBlockVertical;
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: _height * 5),
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
            height: _height * 2,
            indent: 40,
            endIndent: 40,
            thickness: 1,
            color: Colors.grey,
          ))),
          SizedBox(
            height: _height * 20,
          ),
          Center(
              child: Text('Sign In',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xfff27186),
                  ))),
          SizedBox(
            height: _height * 3,
          ),
          Center(
            child: Container(
                height: _height * 5,
                width: _width * 80,
                child: emailWidget(context)),
          ),
          SizedBox(
            height: _height * 1.5,
          ),
          Center(
            child: Container(
                height: _height * 5,
                width: _width * 80,
                child: passwordWidget(context)),
          ),
          SizedBox(
            height: _height,
          ),
          Padding(
            padding: EdgeInsets.only(top: _height * 4),
            child: Center(
              child: Container(
                  height: _height * 4,
                  width: _width * 30,
                  decoration: BoxDecoration(),
                  child: _loading
                      ? Center(
                          child: Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        ))
                      : RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          onPressed: () {
                            _login();
                          },
                          child: Text('SIGN IN',
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 0.8),
                          color: Color(0xfff27186),
                        )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: _height * 30),
            child: Center(
                child: Text(
              'You don\'t have an account ?',
              style: TextStyle(color: Color(0xff3979b7)),
            )),
          ),
          Padding(
            padding: EdgeInsets.only(top: _height),
            child: Center(
              child: GestureDetector(
                child: Text(
                  'Please Sign up',
                  style: TextStyle(color: Color(0xff3979b7)),
                ),
                onTap: () {
                  Future.microtask(() => Navigator.pushReplacementNamed(
                      context, '/RegisterScreen'));
                  // Navigator.pushNamed(context, '/RegisterScreen');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailWidget(BuildContext context) {
    return TextFormField(
      style: new TextStyle(color: Colors.black),
      validator: (input) =>
          input.length < 6 ? 'Please Enter a valid password' : null,
      controller: email,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 4, left: 10),
        filled: true,
        hintStyle:
            TextStyle(color: Color(0xFFbdc6cf), fontWeight: FontWeight.w500),
        fillColor: Colors.white,
        hintText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Color(0xff3979b7)),
        ),
      ),
    );
  }

  Widget passwordWidget(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.left,
      style: new TextStyle(color: Colors.black),
      controller: password,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 4, left: 10),
        filled: true,
        hintStyle: TextStyle(
            // fontSize: 13,
            color: Color(0xFFbdc6cf),
            fontWeight: FontWeight.w500),
        fillColor: Colors.white,
        hintText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Color(0xff3979b7)),
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _loading = true;
    });

    var data = {'email': email.text, 'password': password.text};

    var response = await CallApi().postData(data, '/user/login');

    var body = json.decode(response.body);

    var user;
    var token;
    var name1;
    if (response.statusCode == 200) {
      user = jsonDecode(response.body);
      user = body['user'];

      name1 = body['user']['name'];

      token = jsonDecode(response.body);
      token = body["token"];

      SharedPreferences storage = await SharedPreferences.getInstance();
      storage.setString("token", token);
      storage.setString("user", json.encode(user));
      storage.setString("name", name1);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/NavigationScreen', (Route<dynamic> route) => false);
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        content: Row(
          children: <Widget>[
            Container(
              child: Icon(Icons.warning),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'invalid email or password',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ));
    }
    setState(() {
      _loading = false;
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 20,
          ),
          Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                "Loading...",
                style: TextStyle(fontSize: 15),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
