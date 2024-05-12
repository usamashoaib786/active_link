import 'dart:io';
import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_field.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ProfileScreen/compilence.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  var finalResponse;
  File? imagePath;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getProfile();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(
        click: false,
        title: "Profile",
      ),
      body: finalResponse == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    Container(
                      height: 260,
                      width: screenWidth,
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Container(
                              height: 210,
                              width: screenWidth,
                              color: AppTheme.appColor,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0, right: 30, top: 30),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            push(context,
                                                const CompilanceScreen());
                                          },
                                          child: customContainer(
                                              img:
                                                  "assets/images/Test Passed.png"),
                                        ),
                                        customContainer(
                                            img: "assets/images/Pencil.png"),
                                      ],
                                    ),
                                    finalResponse == null
                                        ? const SizedBox()
                                        : Align(
                                            alignment: Alignment.topCenter,
                                            child: AppText.appText(
                                                "${finalResponse["user_details"]["full_name"]}",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                textColor: AppTheme.whiteColor),
                                          ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: AppText.appText("2 Months Old",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          textColor: AppTheme.whiteColor),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        column1(
                                            txt1: "Shifts Completed",
                                            txt2: "6"),
                                        Container(
                                          height: 60,
                                          width: 1,
                                          color: AppTheme.whiteColor,
                                        ),
                                        column1(
                                            txt1: "Progress Added", txt2: "12"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 212,
                              height: 43,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFD9D9D9)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Center(
                                child: AppText.appText("Basic Info",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppTheme.blackColor),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                    color: AppTheme.whiteColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: finalResponse == null
                                      ? const Padding(
                                          padding: EdgeInsets.all(25.0),
                                          child: CircularProgressIndicator(),
                                        )
                                      : imagePath != null
                                          ? Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  color: AppTheme.txtColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  image: DecorationImage(
                                                      image:
                                                          FileImage(imagePath!),
                                                      fit: BoxFit.cover)),
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectImageFrom();
                                                },
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: Colors.white,
                                                    ),
                                                    child: Icon(
                                                      Icons.camera_enhance,
                                                      color: AppTheme.appColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  color: AppTheme.txtColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          "https://portaltest.thebrandwings.com/${finalResponse["user_details"]["upload_path"]}/${finalResponse["user_details"]["image"]}"),
                                                      fit: BoxFit.cover)),
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectImageFrom();
                                                },
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: Colors.white,
                                                    ),
                                                    child: Icon(
                                                      Icons.camera_enhance,
                                                      color: AppTheme.appColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    finalResponse == null
                        ? const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          )
                        : infoCOlumn(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton.appButton("Update", onTap: () {
                          if (_nameController.text.isNotEmpty &&
                              _dobController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _genderController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty &&
                              _phoneController.text.isNotEmpty) {
                            updateProfile();
                          } else {
                            showSnackBar(context, "Please fill complete form");
                          }
                        },
                            textColor: AppTheme.whiteColor,
                            backgroundColor: const Color(0xff00BFA5),
                            height: 30,
                            width: 110),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _selectImageFrom() {
    var selectImageOption = CupertinoActionSheet(
      title: const Text(
        "Select Image",
        style: TextStyle(fontSize: 20.0),
      ),
      message: const Text("Select image from"),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text("Gallery"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);

            _getImage(ImageSource.gallery);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text("Cancel"),
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    showCupertinoModalPopup(
        context: context, builder: (_) => selectImageOption);
  }

  _getImage([source = ImageSource.gallery]) async {
    try {
      final ImagePicker picker = ImagePicker();
      var image = await picker.pickImage(
        source: source,
      );
      print("jbdjbfedjfj$image");
      if (image != null) {
        setState(() {
          imagePath = File(image.path);
        });
      } else {
        showSnackBar(context, "Something went wrong, please try again!");
      }
    } on PlatformException catch (e) {
      showSnackBar(context, "${e.message}");
    } on Exception catch (e) {
      showSnackBar(context, "${e.toString()}");
    } on Error catch (e) {
      showSnackBar(context, "${e.toString()}");
    } catch (e) {
      showSnackBar(context, "${e.toString()}");
    }
  }

  void updateProfile() async {
    setState(() {});
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    String path = imagePath!.path; // Assuming _image is your image file
    print("f4nf4o4ofno${finalResponse["user_details"]["upload_path"]}");
    FormData formData = FormData.fromMap({
      "full_name": _nameController.text,
      "password": _passwordController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "dob": _dobController.text,
      "upload_path": finalResponse["user_details"]["upload_path"],
      "gender": _genderController.text,
      "image": await MultipartFile.fromFile(path),
    });
    try {
      response = await dio.post(path: AppUrls.updateProfile, data: formData);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "User logged in somewhere else..");
        setState(() {
          _isLoading = false;
          pushUntil(context, const LogInScreen());
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
            showSnackBar(context, "Profile update successfully.");

            getProfile();
          });
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

  void getProfile() async {
    setState(() {});
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.

    try {
      response = await dio.get(
        path: AppUrls.profile,
      );
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "User logged in somewhere else..");
        setState(() {
          _isLoading = false;
          pushUntil(context, const LogInScreen());
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
            finalResponse = responseData;
            _nameController.text = finalResponse["user_details"]["full_name"];
            _emailController.text = finalResponse["user_details"]["email"];
            _genderController.text = finalResponse["user_details"]["gender"];
            _dobController.text = finalResponse["user_details"]["dob"];
            _phoneController.text = finalResponse["user_details"]["phone"];
            _passwordController.text =
                finalResponse["user_details"]["password"];
          });
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

  Widget customContainer({img}) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("$img")),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 1.5, color: AppTheme.whiteColor)),
    );
  }

  Widget column1({txt1, txt2}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppText.appText("$txt1",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: AppTheme.whiteColor),
        const SizedBox(
          height: 10,
        ),
        AppText.appText("$txt2",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: AppTheme.whiteColor),
      ],
    );
  }

  Widget infoCOlumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customField1(
            lable: "Full Name",
            controller: _nameController,
          ),
          customField1(lable: "Email", controller: _emailController),
          customField1(lable: "Phone", controller: _phoneController),
          customField1(lable: "Gender", controller: _genderController),
          customField1(lable: "Date of Birth", controller: _dobController),
          customField(
              lable: "State",
              txt: finalResponse["staff_details_crud_model"][0]["state_name"]),
          customField(
              lable: "Region",
              txt: finalResponse["staff_details_crud_model"][0]["region_name"]),
          customField(
              lable: "Unit",
              txt: finalResponse["staff_details_crud_model"][0]["unit_name"]),
          customField(
              lable: "Registration Id",
              txt: finalResponse["user_details"]["registration_id"]),
          customField1(lable: "Password", controller: _passwordController),
          customField(
              lable: "Role",
              txt: finalResponse["staff_details_crud_model"][0]["role_name"]),
        ],
      ),
    );
  }

  Widget customField({txt, lable}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.appText("$lable",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: AppTheme.blackColor),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: AppTheme.txtColor)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
              child: AppText.appText("$txt ",
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  Widget customField1({txt, lable, controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.appText("$lable",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: AppTheme.blackColor),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
              height: 50,
              child: AppField(
                textEditingController: controller,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                borderRadius: BorderRadius.circular(10),
              ))
        ],
      ),
    );
  }
}
