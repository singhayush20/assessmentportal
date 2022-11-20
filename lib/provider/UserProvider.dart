import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/UserModel.dart';
import 'package:assessmentportal/Service/UserService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  SharedPreferences? sharedPreferences;
  late LoadingStatus loadingStatus;

  var image;
  UserProvider() {}
  UserProvider.initialze(SharedPreferences sf) {
    _initializePrefs(sf);
    loadingStatus = LoadingStatus.NOT_STARTED;
  }
  void _initializePrefs(SharedPreferences sf) {
    log('Initializing sharedPreferences');
    sharedPreferences = sf;
    log('Shared preference initialized');
  }

  User? user;
  UserService userService = UserService();
  Future<void> saveUserDetails(
      {required String username, required String token}) async {
    print('UserProvider: Loading and saving user details');
    loadingStatus = LoadingStatus.LOADING;
    // notifyListeners();
    Map<String, dynamic> userDetails =
        await userService.loadUserByUsername(username: username, token: token);
    log('UserProvider: userDetails obtained: $userDetails');
    userDetails = userDetails['data'];
    user = User.saveUser(
        firstName: userDetails['firstName'],
        lastName: userDetails['lastName'],
        password: userDetails['password'],
        email: userDetails['email'],
        phoneNumber: userDetails['phone'],
        userName: userDetails['username'],
        profile: userDetails['profile'],
        roles: userDetails['roles']);
    sharedPreferences!.setString(USERNAME, user!.userName);
    sharedPreferences!.setString(EMAIL, user!.email);
    image = CachedNetworkImage(
      imageUrl: 'enter image url',
      placeholder: (context, url) =>
          new Image.asset('images/DefaultProfileImage.jpg'),
      errorWidget: (context, url, error) =>
          new Image.asset('images/DefaultProfileImage.jpg'),
    );
    // _sharedPreferences!.setString("firstName", user!.firstName);
    // _sharedPreferences!.setString("lastName", user!.lastName);
    // _sharedPreferences!.setString("phone", user!.phoneNumber);
    loadingStatus = LoadingStatus.COMPLETED;
    notifyListeners();
  }
}
