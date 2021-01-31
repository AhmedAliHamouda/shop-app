import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http-exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authTimer;
  var _userName;
  Map<String,dynamic> _userData={
    'userName':'',
    'userImageUrl':'',
  };

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get userName{
    return _userName;
  }

  Map<String,dynamic> get userData{
    return _userData;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> _authenticate(
      {String email, String password, String urlSegment}) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBLgM4P06u6ihF4RAzR7x2PUYfvkC7gW-w';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expireData': _expireDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp({String email, String password}) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: 'signUp',
    );
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> addUserName(String userName,String userImageUrl) async {
    //final urlById = 'https://shopapp-af8c9-default-rtdb.firebaseio.com/userFavoites/$userId/$id.json?auth=$authToken';
    final url =
        'https://shopapp-af8c9-default-rtdb.firebaseio.com/users/$_userId.json?auth=$_token';
    await http.post(url,
        body: json.encode({
          'userName': userName,
          'userImageUrl':userImageUrl,
        }));
    //notifyListeners();
  }

  Future<void> getUserName() async {

    final url =
        'https://shopapp-af8c9-default-rtdb.firebaseio.com/users/$_userId.json?auth=$_token';
    final responseData = await http.get(url);
    final extractedData =
        json.decode(responseData.body) as Map<String, dynamic>;
    if(extractedData == null){
      return;
    }
    else{
    extractedData.forEach((userNameId, usernameData) {
      _userData['userName'] = usernameData['userName'];
      _userData['userImageUrl']=usernameData['userImageUrl'];

    });  }
    //notifyListeners();
    //print(username);
  }

  //////////////////////////////////////////

  Future<void> login({String email, String password}) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: 'signInWithPassword',
    );
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userDataGotten =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(userDataGotten['expireData']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userDataGotten['token'];
    _userId = userDataGotten['userId'];
    _expireDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    //pref.remove('userData');
    pref.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  /////////////////////////////////////////////////////////////////////////////

  Future<void> signUpUser({String email, String password}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final newUser = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((error) {
      throw HttpException(error.toString());
    });
    // Future<String> getIdToaken() async {
    //   String idToken = await _auth.currentUser.getIdToken();
    //   print(idToken);
    // }
    //
    // getIdToaken();
    print(_auth.currentUser.uid);
  }

  Future<void> loginUser({String email, String password}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final newUser = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error) {
      throw HttpException(error.toString());
    });
    // Future<String> getIdToaken() async {
    //   String idToken = await _auth.currentUser.getIdToken();
    //   print(idToken);
    // }
    //
    // getIdToaken();
    print(_auth.currentUser.uid);
  }
}
