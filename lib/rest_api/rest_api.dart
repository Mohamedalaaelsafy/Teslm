import 'dart:convert';
import 'package:http/http.dart' as http;

class CallApi{
  final String _url = 'https://heartbeatsproject.herokuapp.com';

  postData(data , apiurl)async{
    var fullUrl = _url + apiurl;
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders()
    );
  }

  getData(apiurl) async{
    var fullUrl = _url + apiurl;
    return await http.get(
      fullUrl ,
      headers: _setHeaders()
    );
  }

_setHeaders()=>{
  'Content-type' : 'application/json',
  'Accept'       : 'application/json',
};
 
} 