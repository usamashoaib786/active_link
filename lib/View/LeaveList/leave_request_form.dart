import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_field.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/LeaveList/leave_list.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:active_link/config/keys/pref_keys.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveRequestForm extends StatefulWidget {
  const LeaveRequestForm({super.key});

  @override
  State<LeaveRequestForm> createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  var selectedLeave = "Annual Leave";
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController _descController = TextEditingController();
  bool check = false;
  bool _isLoading = false;
  late AppDio dio;
  var adminId;
  AppLogger logger = AppLogger();
  final ExpansionTileController typeController = ExpansionTileController();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getAdminId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Leave Request Form",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.appText(
                'Type of leave *',
                textColor: const Color(0xFF666666),
                fontSize: 14,
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: screenWidth,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: ExpansionTile(
                  controller: typeController,
                  title: AppText.appText(
                    '$selectedLeave',
                    textColor: const Color(0xFF666666),
                    fontSize: 14,
                  ),
                  children: [
                    customRow(
                        txt: "Sick Leave",
                        onTap: () {
                          setState(() {
                            if (typeController.isExpanded) {
                              typeController.collapse();
                            } else {
                              typeController.expand();
                            }
                            selectedLeave = "Sick Leave";
                          });
                        }),
                    customRow(
                        txt: "Casual Leave",
                        onTap: () {
                          setState(() {
                            if (typeController.isExpanded) {
                              typeController.collapse();
                            } else {
                              typeController.expand();
                            }
                            selectedLeave = "Casual Leave";
                          });
                        }),
                    customRow(
                        txt: "Annual Leave",
                        onTap: () {
                          setState(() {
                            if (typeController.isExpanded) {
                              typeController.collapse();
                            } else {
                              typeController.expand();
                            }
                            selectedLeave = "Annual Leave";
                          });
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText(
                        'Start Date *',
                        textColor: const Color(0xFF666666),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          width: 115,
                          height: 30,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFDDDDDD)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: AppTheme.txtColor,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                AppText.appText(
                                    startDate == null
                                        ? "DD/MM/YYYY"
                                        : DateFormat('MM-dd-yyyy')
                                            .format(startDate!),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textColor: startDate == null
                                        ? AppTheme.txtColor
                                        : AppTheme.txtColor),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText(
                        'End Date *',
                        textColor: const Color(0xFF666666),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate1(context);
                        },
                        child: Container(
                          width: 115,
                          height: 30,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFDDDDDD)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: AppTheme.txtColor,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                AppText.appText(
                                    endDate == null
                                        ? "DD/MM/YYYY"
                                        : DateFormat('MM-dd-yyyy')
                                            .format(endDate!),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textColor: endDate == null
                                        ? AppTheme.txtColor
                                        : AppTheme.txtColor),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              AppText.appText(
                'Description *',
                textColor: const Color(0xFF666666),
                fontSize: 14,
              ),
              const SizedBox(
                height: 40,
              ),
                CustomTextField(
                  controller: _descController,
                  hintText: "Enter the Description",
                  lines: 6,
                ),
              const SizedBox(
                height: 40,
              ),
              _isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.appColor,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        button(
                            txt: "Save",
                            color: Color(0xff00BFA5),
                            ontap: () {
                              leaveRequest();
                            }),
                        const SizedBox(
                          width: 20,
                        ),
                        button(txt: "Cancel", color: Color(0xffF32184))
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget button({txt, ontap, color}) {
    return AppButton.appButton("$txt",
        onTap: ontap,
        textColor: AppTheme.whiteColor,
        backgroundColor: color,
        height: 30,
        width: 100);
  }

  Widget customRow({txt, onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            AppText.appText(
              '$txt',
              textColor: const Color(0xFF666666),
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppTheme.appColor, // Change the primary color
            colorScheme: ColorScheme.light(
                primary: AppTheme.appColor), // Change overall color scheme
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppTheme.appColor, // Change the primary color
            colorScheme: ColorScheme.light(
                primary: AppTheme.appColor), // Change overall color scheme
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  getAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      adminId = prefs.getString(PrefKey.adminId);
    });
  }

  void leaveRequest() async {
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
      "leave_type": selectedLeave,
      "leave_start": startDate,
      "leave_end": endDate,
      "leave_content": _descController.text,
      "admin_id": adminId
    };
    try {
      response = await dio.post(path: AppUrls.leaveRequest, data: params);
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
          pushUntil(context, LogInScreen());

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
            pushReplacement(context, LeaveListScreen());
            showSnackBar(context, "${responseData["message"]}");
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
}
