import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/Navigation/BottomNavigation.dart';
import 'package:assessmentportal/NewtworkUtil/API.dart';
import 'package:assessmentportal/Register%20and%20Login/ForgetPassword.dart';
import 'package:assessmentportal/Register%20and%20Login/RegisterScren.dart';
import 'package:assessmentportal/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  late UserProvider userProvider;
  bool isPasswordVisible = false;
  late SharedPreferences _sharedPreferences;
  void initializePreference() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initializePreference();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final API api = API();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                  height: height * 0.1,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Quizzo',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                  height: height * 0.05,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Form(
                      key: _formKey,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: constraints.maxHeight * 0.2,
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller: _usernameController,
                                  obscureText: false,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Username cannot be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Username",
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.circleUser,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              //====PASSWORD====
                              SizedBox(
                                height: constraints.maxHeight * 0.2,
                              ),
                              Container(
                                height: constraints.maxHeight * 0.2,
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: !isPasswordVisible,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Password cannot be empty';
                                    } else if (value.length < 8) {
                                      return "Password must be at least 8 characters long";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.lock,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        (isPasswordVisible)
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )),
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.2,
                  ),
                  height: height * 0.05,
                  child: ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> result = await api.loginUser(
                        username: _usernameController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      String code = result['code'];
                      if (code == '2000') {
                        String token = result['token'];
                        token = Bearer + token;
                        log('Saving token and setting login status to true $token');
                        _sharedPreferences.setString(BEARER_TOKEN, token);
                        // await userProvider.saveUserDetails(
                        //     username: _usernameController.text.trim(),
                        //     token: token);
                        _sharedPreferences.setString(
                            "username", _usernameController.text.trim());
                        _sharedPreferences.setBool(IS_LOGGED_IN, true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigation(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login Successful!'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login Failed!'),
                          ),
                        );
                      }
                    },
                    child: const FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 80,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                    height: height * 0.05,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgetPassword(),
                                ),
                              );
                            },
                            child: const FittedBox(
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                  fontSize: 100,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                            child: FittedBox(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 100,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
