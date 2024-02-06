import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/widgets/others/app_field.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/forgot_password.dart';
import 'package:active_link/View/BottomNavigationbar/navigationbar.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/utils.dart';
import '../../config/app_urls.dart';
import '../../config/keys/pref_keys.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen();

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool check = false;
  bool _isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      height: screenHeight,
      width: screenWidth,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.21, -0.98),
          end: Alignment(-0.21, 0.98),
          colors: [Color(0xB58E0FD7), Color(0xFFCC60F2)],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.appText("Login",
                  textColor: AppTheme.whiteColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w700),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 550,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/Rectangle.png"),
                          fit: BoxFit.contain)),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: screenWidth - 80,
                          height: 330,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText.appText(
                                'Hello!',
                                textColor: const Color(0xffAC51E0),
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                              const SizedBox(height: 20),
                              CustomAppFormField(
                                  texthint: "Email or Phone ",
                                  controller: _emailController),
                              CustomAppPasswordfield(
                                  texthint: "Password",
                                  controller: _passwordController),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  // Add your forgot password logic here
                                  push(context, ForgotPasswordScreen());
                                },
                                child: AppText.appText(
                                  'Forgot Password ?',
                                  textColor: const Color(0xFF666666),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (_emailController.text.isNotEmpty) {
                                  if (_passwordController.text.isNotEmpty) {
                                    logIn();
                                  } else {
                                    showSnackBar(context, "Enter Password");
                                  }
                                } else {
                                  showSnackBar(context, "Enter email");
                                }
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/polygon.png"),
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: _isLoading == true
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Image(
                                          image: AssetImage(
                                              "assets/images/arrowButton.png")),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText.appText("New User ?  ",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.whiteColor),
                  AppText.appText("Signup",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.whiteColor),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  void logIn() async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };
    try {
      response = await dio.post(path: AppUrls.login, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          setState(() {
            _isLoading = false;
          });

          return;
        } else {
          setState(() {
            _isLoading = false;
          });
          var token = responseData["staff_details"][0]["auth_token"];
          var adminId = responseData["staff_details"][0]["admin_id"];
          var regId = responseData["staff_details"][0]["registration_id"];


          print("var   ${token}");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(PrefKey.authorization, token ?? '');
          prefs.setString(PrefKey.adminId, adminId ?? '');
          prefs.setString(PrefKey.regId, regId ?? '');

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavView(),
              ),
              (route) => false);
        }
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }

}
   


// fin() async{
//    SharedPreferences pref =   await SharedPreferences.getInstance();
//     pref.setString("authorization", "ahmad");
//     pref.getString("authorizaton");
//     pref.remove("authorization");
//     pref.clear();
// }