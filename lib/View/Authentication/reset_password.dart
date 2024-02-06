import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_field.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen();

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool check = false;

  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
        home: Scaffold(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText.appText(
                            'Reset Password',
                            textColor: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          CustomAppFormField(
                              texthint: "Email or Phone ",
                              controller: _emailController),
                          AppButton.appButton("Send Password Reset Link",
                              backgroundColor: AppTheme.appColor,
                              height: 40,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textColor: AppTheme.whiteColor)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
