import 'dart:io';

import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_field.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ClientDataEntry/IncidentLog/incident_log_list.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class IncidentLogAdd extends StatefulWidget {
  final showButton;
  final logId;
  final edit;

  const IncidentLogAdd({super.key, this.showButton, this.edit, this.logId});

  @override
  State<IncidentLogAdd> createState() => _IncidentLogAddState();
}

class _IncidentLogAddState extends State<IncidentLogAdd> {
  DateTime? dateOccurred;
  DateTime? dateReported;
  TextEditingController _timeOpenController = TextEditingController();
  TextEditingController _timeCloseControllerTwo = TextEditingController();
  TextEditingController _involvedcontroller = TextEditingController();
  TextEditingController _actionController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  var selectedClient = "Select Client";
  var selectedHierarchy = "Hierarchy";
  var selectedRegion = "Region";
  var selectedUnit = "Unit";
  var selctedIncidentCategory = "Select Incident Category";
  var selectedSeverity = "Select Severity";
  var selectedStaffInvolved = "Select Staff";
  var selectedReportedBy = "Select Reported By";
  var clientId;
  var staffId;
  var reportStaffId;
  var stateId;
  var regionId;
  var unitId;

  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  var finalResponse;
  var apiClientresponse;
  final ExpansionTileController clientontroller = ExpansionTileController();
  final ExpansionTileController catagoryController = ExpansionTileController();
  final ExpansionTileController severityController = ExpansionTileController();
  final ExpansionTileController staffInvolvedController =
      ExpansionTileController();
  final ExpansionTileController reportedByController =
      ExpansionTileController();

  List incidentCategory = [
    "Abuse/Neglect Emotional",
    "Behaviour of Concern",
    "Medication Client",
    "Abuse/Neglect Financial",
    "Disclosure of Concern",
    "Medication Pharmacy",
    "Abuse/Neglect Physical",
    "Abuse/Neglect Sexual",
    "Medication Staff",
    "Disclosure of Concern Sexual",
    "OSH",
    "Physical Aggretion",
    "Adverse Publicity Potentiol",
    "Health Concern",
    "Property Damage",
    "Assault/Physical",
    "Assault/Sexual",
    "Illness",
    "Unauthorized RP",
    "Injury",
    "Verbal Aggretion",
    "Authorized Restrictive Practices PRN"
  ];

  List severity = [
    "High Impact",
    "Low Impact",
    "Major",
    "Minor",
    "Moderate",
    "Not Significant",
    "Severe"
  ];
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    if (widget.edit == true) {
      getLogDetail();
    }
    incidentFormData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        bottomNavigationBar: widget.showButton == false
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.appColor,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton.appButton("Save", onTap: () {
                            if (widget.edit == true) {
                              if (clientId == null) {
                                showSnackBar(
                                    context, "Please select Client again");
                              } else {
                                updateIncidentForm();
                              }
                            } else {
                              if (clientId != null &&
                                  staffId != null &&
                                  reportStaffId != null &&
                                  selectedSeverity != "Select Severity" &&
                                  selctedIncidentCategory !=
                                      "Select Incident Category" &&
                                  dateOccurred != null &&
                                  dateReported != null &&
                                  _timeOpenController.text.isNotEmpty &&
                                  _timeCloseControllerTwo.text.isNotEmpty) {
                                saveIncidentForm();
                              } else {
                                showSnackBar(context, "Fill Complete Form");
                              }
                            }
                          },
                              textColor: AppTheme.whiteColor,
                              backgroundColor: Color(0xff00BFA5),
                              height: 30,
                              width: 110),
                          const SizedBox(
                            width: 15,
                          ),
                          AppButton.appButton("Cancel",
                              textColor: AppTheme.whiteColor,
                              backgroundColor: Color(0xffF32184),
                              height: 30,
                              width: 110),
                        ],
                      ),
              ),
        appBar: const CustomAppBar(
          title: "Incident Log Add",
        ),
        body: widget.edit == true
            ? _isLoading == true
                ? Center(child: CircularProgressIndicator())
                : bodyColumn()
            : finalResponse == null
                ? Center(child: CircularProgressIndicator())
                : bodyColumn());
  }

  Widget bodyColumn() {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(txt: "Select Clients"),
            expandedTile(
                txt: "$selectedClient", tile: 1, controller: clientontroller),
            CustomText(txt: "Hierarchy"),
            Container(
              height: 50,
              width: screenWidth,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                child: AppText.appText(
                    "$selectedHierarchy->$selectedRegion->$selectedUnit",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff555555)),
              ),
            ),
            // expandedTile(txt: "$selectedHierarchy->$selectedRegion->$selectedUnit"),

            CustomText(txt: "Incident Category"),
            expandedTile(
                txt: "$selctedIncidentCategory",
                tile: 2,
                controller: catagoryController),
            CustomText(txt: "Severity"),
            expandedTile(
                txt: "$selectedSeverity",
                tile: 3,
                controller: severityController),
            CustomText(txt: "Staff involoved"),
            expandedTile(
                txt: "$selectedStaffInvolved",
                tile: 4,
                controller: staffInvolvedController),
            CustomText(txt: "Reported by"),
            expandedTile(
                txt: "$selectedReportedBy",
                tile: 5,
                controller: reportedByController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(txt: "Date Occurred"),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Container(
                        width: 115,
                        height: 40,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFDDDDDD)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                  dateOccurred == null
                                      ? "DD/MM/YYYY"
                                      : DateFormat('MM-dd-yyyy')
                                          .format(dateOccurred!),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  textColor: dateOccurred == null
                                      ? AppTheme.txtColor
                                      : AppTheme.txtColor),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomText(txt: "Time Occurred"),
                    SizedBox(
                        height: 40,
                        width: 100,
                        child: AppField(
                          onTap: () {
                            _selectTime(context);
                          },
                          readOnly: true,
                          textEditingController: _timeOpenController,
                          borderRadius: BorderRadius.circular(5),
                          borderSideColor: Color(0xffDDDDDD),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                        )),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(txt: "Date Reported"),
                    GestureDetector(
                      onTap: () {
                        _selectDate1(context);
                      },
                      child: Container(
                        width: 115,
                        height: 40,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFDDDDDD)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                  dateReported == null
                                      ? "DD/MM/YYYY"
                                      : DateFormat('MM-dd-yyyy')
                                          .format(dateReported!),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  textColor: dateReported == null
                                      ? AppTheme.txtColor
                                      : AppTheme.txtColor),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomText(txt: "Time Reported"),
                    SizedBox(
                        height: 40,
                        width: 100,
                        child: AppField(
                          onTap: () {
                            _selectTimeTwo(context);
                          },
                          readOnly: true,
                          textEditingController: _timeCloseControllerTwo,
                          borderRadius: BorderRadius.circular(5),
                          borderSideColor: Color(0xffDDDDDD),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                        )),
                  ],
                )
              ],
            ),
            CustomText(txt: "Description of Incident"),
            CustomTextField(
              lines: 3,
              controller: _descController,
              hintText: "",
            ),
            CustomText(txt: "People involved in Incident"),
            CustomTextField(
              lines: 3,
              controller: _involvedcontroller,
              hintText: "",
            ),
            CustomText(txt: "Action taken"),
            CustomTextField(
              lines: 3,
              controller: _actionController,
              hintText: "",
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomText({txt}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: AppText.appText("$txt",
          fontSize: 14,
          fontWeight: FontWeight.w400,
          textColor: Color(0xff555555)),
    );
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
      initialDate: dateOccurred ?? DateTime.now(),
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
    if (picked != null && picked != dateOccurred) {
      setState(() {
        dateOccurred = picked;
      });
    }
  }

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateReported ?? DateTime.now(),
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
    if (picked != null && picked != dateReported) {
      setState(() {
        dateReported = picked;
      });
    }
  }

  Widget expandedTile({txt, tile, controller}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: ExpansionTile(
        controller: controller,
        title: AppText.appText(
          '$txt',
          textColor: const Color(0xFF666666),
          fontSize: 14,
        ),
        children: [
          Container(
            height: 150,
            child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: tile == 1
                  ? apiClientresponse.length
                  : tile == 2
                      ? incidentCategory.length
                      : tile == 3
                          ? severity.length
                          : tile == 4
                              ? finalResponse.length
                              : finalResponse.length,
              itemBuilder: (context, index) {
                return customRow(
                  onTap: () {
                    if (tile == 1) {
                      setState(() {
                        if (clientontroller.isExpanded) {
                          clientontroller.collapse();
                        } else {
                          clientontroller.expand();
                        }
                        selectedClient =
                            "${apiClientresponse[index]["f_name"]}  ${apiClientresponse[index]["l_name"]}";
                        selectedHierarchy =
                            "${apiClientresponse[index]["state_name"]}";
                        stateId = apiClientresponse[index]["state_id"];
                        regionId = apiClientresponse[index]["region_id"];
                        unitId = apiClientresponse[index]["unit_id"];

                        selectedRegion =
                            "${apiClientresponse[index]["region_name"]}";
                        selectedUnit =
                            "${apiClientresponse[index]["unit_name"]}";
                        clientId = "${apiClientresponse[index]["cl_unq_no"]}";
                      });
                    } else if (tile == 2) {
                      setState(() {
                        if (catagoryController.isExpanded) {
                          catagoryController.collapse();
                        } else {
                          catagoryController.expand();
                        }
                        selctedIncidentCategory = "${incidentCategory[index]}";
                      });
                    } else if (tile == 3) {
                      setState(() {
                        if (severityController.isExpanded) {
                          severityController.collapse();
                        } else {
                          severityController.expand();
                        }
                        selectedSeverity = "${severity[index]}";
                      });
                    } else if (tile == 4) {
                      setState(() {
                        if (staffInvolvedController.isExpanded) {
                          staffInvolvedController.collapse();
                        } else {
                          staffInvolvedController.expand();
                        }
                        selectedStaffInvolved =
                            "${finalResponse[index]["full_name"]}";
                        staffId = "${finalResponse[index]["id"]}";
                      });
                    } else {
                      setState(() {
                        if (reportedByController.isExpanded) {
                          reportedByController.collapse();
                        } else {
                          reportedByController.expand();
                        }
                        selectedReportedBy =
                            "${finalResponse[index]["full_name"]}";
                        reportStaffId = "${finalResponse[index]["id"]}";
                      });
                    }
                  },
                  txt: tile == 1
                      ? "${apiClientresponse[index]["f_name"]}  ${apiClientresponse[index]["l_name"]}"
                      : tile == 2
                          ? "${incidentCategory[index]}"
                          : tile == 3
                              ? "${severity[index]}"
                              : tile == 4
                                  ? "${finalResponse[index]["full_name"]}"
                                  : "${finalResponse[index]["full_name"]}",
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      // helpText: "9:00",
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeOpenController.text = picked.format(context);
      });
    }
  }

  Future<void> _selectTimeTwo(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeCloseControllerTwo.text = picked.format(context);
      });
    }
  }

  void incidentFormData() async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.

    try {
      response = await dio.get(path: AppUrls.getIncidentForm);
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
            finalResponse = responseData["staffdata"];
            apiClientresponse = responseData["clients"];

            print("hwcvhvefvjkvk$finalResponse");
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

  void saveIncidentForm() async {
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
      "incident_client_id": clientId,
      "incident_client_state": stateId,
      "incident_client_region": regionId,
      "incident_client_unit": unitId,
      "incident_category": selctedIncidentCategory,
      "incident_severity": selectedSeverity,
      "staff_reported_id": reportStaffId,
      "people_involved": _involvedcontroller.text,
      "staff_involved_id": staffId,
      "date_occured": dateOccurred,
      "time_occured": _timeOpenController.text,
      "date_reported": dateReported,
      "time_reported": _timeCloseControllerTwo.text,
      "incident_description": _descController.text,
      "action_taken": _actionController.text
    };
    try {
      response = await dio.post(path: AppUrls.saveIncidentForm, data: params);
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
            showSnackBar(context, "Save Form Sucessfully");
            pushReplacement(context, IncidentLogList());
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

  void getLogDetail() async {
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
      "id": widget.logId,
    };
    try {
      response =
          await dio.post(path: AppUrls.getIncidentLogDetail, data: params);
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
            var finalData = responseData["data"][0];
            var finalData1 = responseData["createdby"][0];
            selectedClient = "${finalData["f_name"]} ${finalData["l_name"]}";
            selectedHierarchy = "${finalData["state_name"]}";
            selectedRegion = "${finalData["region_name"]}";
            selectedUnit = "${finalData["unit_name"]}";
            selctedIncidentCategory = "${finalData["incident_category"]}";
            selectedSeverity = "${finalData["incident_severity"]}";
            String dateString = finalData['date_occured'];
            dateOccurred = DateTime.parse(dateString);
            String dateString1 = finalData['date_reported'];
            dateReported = DateTime.parse(dateString1);
            _timeOpenController.text = finalData["time_occured"];
            _timeCloseControllerTwo.text = finalData["time_reported"];
            _descController.text = finalData["incident_description"];
            _involvedcontroller.text = finalData["people_involved"];

            _actionController.text = finalData["action_taken"];
            selectedStaffInvolved = finalData["full_name"];
            selectedReportedBy = finalData1["full_name"];
            _isLoading = false;
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

  void updateIncidentForm() async {
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
      "incident_client_id": clientId,
      "client_incident_id": widget.logId,
      "incident_client_state": stateId,
      "incident_client_region": regionId,
      "incident_client_unit": unitId,
      "incident_category": selctedIncidentCategory,
      "incident_severity": selectedSeverity,
      "staff_reported_id": reportStaffId,
      "people_involved": _involvedcontroller.text,
      "staff_involved_id": staffId,
      "date_occured": dateOccurred,
      "time_occured": _timeOpenController.text,
      "date_reported": dateReported,
      "time_reported": _timeCloseControllerTwo.text,
      "incident_description": _descController.text,
      "action_taken": _actionController.text
    };
    try {
      response = await dio.post(path: AppUrls.updateIncidentForm, data: params);
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
            showSnackBar(context, "Save Form Sucessfully");
            getLogDetail();
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
