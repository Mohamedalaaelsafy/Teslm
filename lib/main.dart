import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tslm/Navigation.dart';
import 'package:tslm/SplashScreen/screen.dart';
import 'package:tslm/userAction/login.dart';
import 'package:tslm/userAction/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var token = localStorage.getString('token');
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Color(0xff0084AD)),
    debugShowCheckedModeBanner: false,
    home: token == null ? Screen() : Navigation(),
    routes: {
      '/SplashScreen': (context) => Screen(),
      '/LoginScreen': (context) => Login(),
      '/RegisterScreen': (context) => Register(),
      '/NavigationScreen': (context) => Navigation(),
    },
  ));
}
