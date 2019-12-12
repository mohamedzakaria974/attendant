import 'package:attendant/helpers/Constants.dart';
import 'package:attendant/model/Attendant.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  static Future<Attendant> login({String url, Map requestBody}) async {
    var absoluteURL = '$baseURL$url';
    //encode Map to JSON {request body}
    var body = json.encode(requestBody);

    var response = await http.post(absoluteURL,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      print(response.body);
      Map responseData = json.decode(response.body);
      Attendant attendant;
      if (responseData.containsKey('attendantObj'))
        attendant = Attendant.fromJson(responseData['attendantObj']);
      else
        attendant = Attendant.fromJson(json.decode(response.body));
//      addAtendantData(attendant: json.decode(response.body));
      addAtendantData(attendant: attendant.toMap());
      return attendant;
    } else {
      return null;
    }
  }

  static addAtendantData({Map attendant}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('current_user_id', attendant['USER_ID'].toString());
    String user = json.encode(attendant);
    preferences.setString('attendant', user);
  }
}
