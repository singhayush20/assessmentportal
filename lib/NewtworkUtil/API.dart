import 'dart:developer';
import 'dart:io';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/UserModel.dart';
import 'package:dio/dio.dart';

class API {
  final sendEmailOTPUrl =
      "${domain}/assessmentportal/authenticate/verifyemail/sendotp";
  final verifyEmailOTPUrl =
      "${domain}/assessmentportal/authenticate/verifyemail/verify-otp";

  final registerNormalUserUrl =
      "${domain}/assessmentportal/authenticate/register/normal";
  final registerAdminUserUrl =
      "$domain/assessmentportal/authenticate/register/admin?key=adminKey";
  final forgetPasswordSendOTPUrl =
      "$domain/assessmentportal/authenticate/verifyemail/reset-password-otp";
  final verifyForgetPasswordSendOTPUrl =
      "$domain/assessmentportal/authenticate/verifyemail/reset-password";
  final loginUserUrl = "$domain/assessmentportal/authenticate/login";
  final loadUserByUsernameUrl = "$domain/assessmentportal/users/";
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> loginUser(
      {required String username, required String password}) async {
    Map<String, dynamic> data = {
      "username": "$username",
      "password": "$password"
    };
    log("Logging in user for: $data $loginUserUrl");
    Response response = await _dio.post(loginUserUrl, data: data);
    log("Logging in response: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> sendEmailVerificationOTP(
      {required String? email}) async {
    Map<String, dynamic> data = {"email": email!};
    Response response = await _dio.post(sendEmailOTPUrl, queryParameters: data);
    log("send email verification otp: Response obtained: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> verifyEmailVerificationOTP(
      {required String? email, required String? otp}) async {
    Map<String, dynamic> data = {"email": email, "otp": int.parse(otp!)};
    log("Sending verify email otp data: $data");
    Response response =
        await _dio.post(verifyEmailOTPUrl, queryParameters: data);
    log("verify email verification otp: Response obtained $response");
    return response.data;
  }

  Future<Map<String, dynamic>> registerNormalUser({required User user}) async {
    Map<String, dynamic> data = {
      "username": user.userName,
      "password": user.password,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "enabled": "true",
      "phone": user.phoneNumber,
      "profile": "sample.jpg"
    };
    Response response = await _dio.post(registerNormalUserUrl, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> registerAdminUser({required User user}) async {
    Map<String, dynamic> data = {
      "username": user.userName,
      "password": user.password,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "enabled": "true",
      "phone": user.phoneNumber,
      "profile": "sample.jpg"
    };
    Response response = await _dio.post(registerNormalUserUrl, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> sendForgotPasswordVerificationOTP(
      {required String? email}) async {
    Map<String, dynamic> data = {"email": email!};
    log('Sending forget password otp for: $data');
    Response response =
        await _dio.post(forgetPasswordSendOTPUrl, queryParameters: data);
    log("send forgot password verification otp: Response obtained: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> resetPasswordAndVerifyOTP({
    required String? email,
    required String? password,
    required int? otp,
  }) async {
    Map<String, dynamic> data = {
      "email": email!,
      "otp": otp!,
      "password": password!
    };
    Response response =
        await _dio.post(verifyForgetPasswordSendOTPUrl, queryParameters: data);
    log("send forgot password verification otp: Response obtained: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> loadUserByUsername(
      {required String username, required String token}) async {
    username = username.trim();
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    // options.headers = {
    //   "Authorization": token,
    // };
    log("Loading user for username: $username header: ${options.headers}");
    Response response =
        await _dio.get(loadUserByUsernameUrl + username, options: options);
    log("Response obtained for loadUserByUsername $response");
    return response.data;
  }
}
