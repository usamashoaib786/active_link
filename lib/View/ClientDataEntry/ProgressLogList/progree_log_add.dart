import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_field.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ClientDataEntry/ProgressLogList/progress_log.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgressLogAdd extends StatefulWidget {
  final showButton;
  final stateRes;
  final staffRes;
  final clientRes;
  final name;
  final id;
  final edit;
  final logId;
  const ProgressLogAdd(
      {super.key,
      this.showButton,
      this.clientRes,
      this.staffRes,
      this.stateRes,
      this.name,
      this.id,
      this.edit,
      this.logId});

  @override
  State<ProgressLogAdd> createState() => _ProgressLogAddState();
}

class _ProgressLogAddState extends State<ProgressLogAdd> {
  DateTime? entryDate;
  bool _showQuestions = false;
  bool _progressNote = false;
  bool _competition = false;

  var selectedHierarchy = "Hierarchy";
  var selectedRegion = "Region";
  var selectedUnit = "Unit";
  var selectedClient = "Select Client";
  var stateId;
  var regionId;
  var unitId;
  var clientId;
  List<String?> _answers = List.filled(13, null);
  TextEditingController _progressController = TextEditingController();
  final ExpansionTileController clientController = ExpansionTileController();
  List<bool> _showTextField = List.generate(13, (_) => false);
  List<TextEditingController> _textControllers = List.generate(
    13,
    (_) => TextEditingController(),
  );

  List shiftLogElementQuestion = [
    "Authorized Substance use Protocol Adhered to",
    "Behavioural/Emotional Issues",
    "Chore Plan Followed",
    "Daily Planner Adhered To",
    "Education- Has The Client Attended School Today?",
    "Exercise Plan Followed",
    "Incident Log Completed",
    "Medication Administered As Prescribed",
    "Menu/Diet Plan Followed",
    "Personal Care Routine Followed",
    "PRN Administered",
    "Reinforcement Point Achieved",
    "Wake Up Routine Followed",
  ];
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  var finalResponse;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    if (widget.edit == true) {
      getLogDetail();
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("enfin3fi3nn${widget.clientRes.length}");
    return Scaffold(
        appBar: const CustomAppBar(
          title: "Progress Log Add",
        ),
        body: widget.edit == true
            ? _isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : bodyColumn()
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
            expandedTile(txt: "$selectedClient"),
            CustomText(txt: "Entry Date"),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                width: screenWidth,
                height: 40,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.appText(
                          entryDate == null
                              ? "DD/MM/YYYY"
                              : DateFormat('MM-dd-yyyy').format(entryDate!),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: entryDate == null
                              ? AppTheme.txtColor
                              : AppTheme.txtColor),
                      Icon(
                        Icons.calendar_month,
                        color: AppTheme.txtColor,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomText(txt: "Hierarchy *"),
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
                    textColor: const Color(0xff555555)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _showQuestions = !_showQuestions; // Toggle visibility
                      });
                    },
                    child: customContainer(
                        txt: "Shift Log Elements", width: 167.0)),
                _showQuestions == false
                    ? const SizedBox.shrink()
                    : SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 13,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${shiftLogElementQuestion[index]}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: "1", // Yes = 1
                                        groupValue: _answers[index],
                                        onChanged: (String? value) {
                                          setState(() {
                                            _answers[index] = value;
                                            _showTextField[index] =
                                                value == "1";
                                          });
                                        },
                                      ),
                                      const Text('Yes'),
                                      Radio<String>(
                                        value: "2", // No = 0
                                        groupValue: _answers[index],
                                        onChanged: (String? value) {
                                          setState(() {
                                            _answers[index] = value;
                                            _showTextField[index] = false;
                                          });
                                        },
                                      ),
                                      const Text('No'),
                                    ],
                                  ),
                                  Visibility(
                                    visible: _showTextField[index],
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      child: AppField(
                                        borderRadius: BorderRadius.circular(20),
                                        textEditingController:
                                            _textControllers[index],
                                        hintText: 'Notes',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _progressNote = !_progressNote; // Toggle visibility
                      });
                    },
                    child:
                        customContainer(txt: "Progress Notes", width: 145.0)),
                if (_progressNote)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.appText("Progress Notes"),
                        const SizedBox(
                          height: 10,
                        ),
                        AppField(
                            borderRadius: BorderRadius.circular(10),
                            textEditingController: _progressController)
                      ],
                    ),
                  ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _competition = !_competition; // Toggle visibility
                      });
                    },
                    child: customContainer(
                        txt: "Cometition & Sign-off", width: 190.0)),
                _competition == false
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText("Staff Member"),
                            const SizedBox(
                              height: 10,
                            ),
                            AppText.appText("${widget.name}")
                          ],
                        ),
                      )
              ],
            ),
            widget.showButton == false
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 35.0),
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
                                        context, "Please select Client Again");
                                  } else {
                                    updateProgressForm();
                                  }
                                } else {
                                  if (clientId == null) {
                                    showSnackBar(
                                        context, "Please select Client");
                                  } else {
                                    saveProgressForm();
                                  }
                                }
                              },
                                  textColor: AppTheme.whiteColor,
                                  backgroundColor: const Color(0xff00BFA5),
                                  height: 30,
                                  width: 110),
                              const SizedBox(
                                width: 15,
                              ),
                              AppButton.appButton("Cancel",
                                  textColor: AppTheme.whiteColor,
                                  backgroundColor: const Color(0xffF32184),
                                  height: 30,
                                  width: 110),
                            ],
                          ),
                  ),
          ],
        ),
      ),
    );
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
          await dio.post(path: AppUrls.getProgressLogDetail, data: params);
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
            var finalData = responseData["data"][0];
            selectedClient = "${finalData["f_name"]} ${finalData["l_name"]}";
            selectedHierarchy = "${finalData["state_name"]}";
            selectedRegion = "${finalData["region_name"]}";
            selectedUnit = "${finalData["unit_name"]}";
            String dateString = finalData['pogress_date'];
            entryDate = DateTime.parse(dateString);
            _progressController.text = finalData["Progress_Notes"];
            _answers[0] = finalData["Authorised_Substance_Use"];
            _answers[1] = finalData["Emotional_Issues"];
            _answers[2] = finalData["Chore_Plan_Followed"];
            _answers[3] = finalData["Daily_Planner_Adhered"];
            _answers[4] = finalData["Education_Has"];
            _answers[5] = finalData["Exercise_Plan_Followed"];
            _answers[6] = finalData["Incident_Log_Completed"];
            _answers[7] = finalData["Medication_Administered"];
            _answers[8] = finalData["Diet_Plan_Followed"];
            _answers[9] = finalData["Personal_Care_Routine"];
            _answers[10] = finalData["PRN_Administered"];
            _answers[11] = finalData["Reinforcement_Points"];
            _answers[12] = finalData["Wake_Up_Routine"];
            _textControllers[0].text =
                finalData["Authorised_Substance_Use_notes"];
            if (_textControllers[0].text != "") {
              _showTextField[0] = true;
            }
            _textControllers[1].text = finalData["Emotional_Issues_notes"];
            if (_textControllers[1].text != "") {
              _showTextField[1] = true;
            }
            _textControllers[2].text = finalData["Chore_Plan_Followed_notes"];
            if (_textControllers[2].text != "") {
              _showTextField[2] = true;
            }
            _textControllers[3].text = finalData["Daily_Planner_Adhered_notes"];
            if (_textControllers[3].text != "") {
              _showTextField[3] = true;
            }
            _textControllers[4].text = finalData["Education_Has_notes"];
            if (_textControllers[4].text != "") {
              _showTextField[4] = true;
            }
            _textControllers[5].text =
                finalData["Exercise_Plan_Followed_notes"];
            if (_textControllers[5].text != "") {
              _showTextField[5] = true;
            }
            _textControllers[6].text =
                finalData["Incident_Log_Completed_notes"];
            if (_textControllers[6].text != "") {
              _showTextField[6] = true;
            }
            _textControllers[7].text =
                finalData["Medication_Administered_notes"];
            if (_textControllers[7].text != "") {
              _showTextField[7] = true;
            }
            _textControllers[8].text = finalData["Diet_Plan_Followed_notes"];
            if (_textControllers[8].text != "") {
              _showTextField[8] = true;
            }
            _textControllers[9].text = finalData["Personal_Care_Routine_notes"];
            if (_textControllers[9].text != "") {
              _showTextField[9] = true;
            }
            _textControllers[10].text = finalData["PRN_Administered_notes"];
            if (_textControllers[10].text != "") {
              _showTextField[10] = true;
            }
            _textControllers[11].text = finalData["Reinforcement_Points_notes"];
            if (_textControllers[11].text != "") {
              _showTextField[11] = true;
            }
            _textControllers[12].text = finalData["Wake_Up_Routine_notes"];
            if (_textControllers[12].text != "") {
              _showTextField[12] = true;
            }

            // print("vjdjjevwjvjwb$finalData");
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

  void saveProgressForm() async {
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
      "pogress_client_id": clientId,
      "pogress_date": entryDate,
      'Authorised_Substance_Use': _answers[0],
      "Emotional_Issues": _answers[1],
      "Chore_Plan_Followed": _answers[2],
      "Daily_Planner_Adhered": _answers[3],
      "Education_Has": _answers[4],
      "Exercise_Plan_Followed": _answers[5],
      "Incident_Log_Completed": _answers[6],
      "Medication_Administered": _answers[7],
      "Diet_Plan_Followed": _answers[8],
      "Personal_Care_Routine": _answers[9],
      "PRN_Administered": _answers[10],
      "Reinforcement_Points": _answers[11],
      "Wake_Up_Routine": _answers[12],
      "Authorised_Substance_Use_notes": _textControllers[0].text,
      "Emotional_Issues_notes": _textControllers[1].text,
      "Chore_Plan_Followed_notes": _textControllers[2].text,
      "Daily_Planner_Adhered_notes": _textControllers[3].text,
      "Education_Has_notes": _textControllers[4].text,
      "Exercise_Plan_Followed_notes": _textControllers[5].text,
      "Incident_Log_Completed_notes": _textControllers[6].text,
      "Medication_Administered_notes": _textControllers[7].text,
      "Diet_Plan_Followed_notes": _textControllers[8].text,
      "Personal_Care_Routine_notes": _textControllers[9].text,
      "PRN_Administered_notes": _textControllers[10].text,
      "Reinforcement_Points_notes": _textControllers[11].text,
      "Wake_Up_Routine_notes": _textControllers[12].text,
      "Progress_Notes": _progressController.text,
      "pogress_client_state": stateId,
      "pogress_client_region": regionId,
      "pogress_client_unit": unitId,
      "pogress_admin_id": widget.id,
      "pogress_created_by": widget.name,
    };
    try {
      response = await dio.post(path: AppUrls.saveProgress, data: params);
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
            push(context, ProgressLogList());
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

  Widget customContainer({txt, double? width}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        height: 40,
        width: width,
        decoration: const BoxDecoration(color: Color(0xFFDAF1F3)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(
                Icons.add,
                color: Color(0xFF3EB1B1),
              ),
              const SizedBox(
                width: 5,
              ),
              AppText.appText("$txt",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: const Color(0xFF3EB1B1))
            ],
          ),
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
          textColor: const Color(0xff555555)),
    );
  }

  Widget expandedTile({txt}) {
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
        controller: clientController,
        title: AppText.appText(
          '$txt',
          textColor: const Color(0xFF666666),
          fontSize: 14,
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.clientRes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (clientController.isExpanded) {
                        clientController.collapse();
                      } else {
                        clientController.expand();
                      }
                      selectedClient =
                          "${widget.clientRes[index]["f_name"]}  ${widget.clientRes[index]["l_name"]}";
                      selectedHierarchy =
                          "${widget.clientRes[index]["state_name"]} ";
                      selectedRegion =
                          "${widget.clientRes[index]["region_name"]} ";
                      selectedUnit = "${widget.clientRes[index]["unit_name"]} ";
                      stateId = widget.clientRes[index]["state_id"];
                      regionId = widget.clientRes[index]["region_id"];
                      unitId = widget.clientRes[index]["unit_id"];
                      clientId = "${widget.clientRes[index]["cl_unq_no"]}";
                    });
                  },
                  child: customRow(
                      txt:
                          "${widget.clientRes[index]["f_name"]}  ${widget.clientRes[index]["l_name"]}"));
            },
          )
        ],
      ),
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
      initialDate: entryDate ?? DateTime.now(),
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
    if (picked != null && picked != entryDate) {
      setState(() {
        entryDate = picked;
      });
    }
  }

  void updateProgressForm() async {
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
      "pogress_client_id": clientId,
      "old_pogress_client_id": clientId,
      "client_pogress_id": widget.logId,
      "pogress_date": entryDate,
      'Authorised_Substance_Use': _answers[0],
      "Emotional_Issues": _answers[1],
      "Chore_Plan_Followed": _answers[2],
      "Daily_Planner_Adhered": _answers[3],
      "Education_Has": _answers[4],
      "Exercise_Plan_Followed": _answers[5],
      "Incident_Log_Completed": _answers[6],
      "Medication_Administered": _answers[7],
      "Diet_Plan_Followed": _answers[8],
      "Personal_Care_Routine": _answers[9],
      "PRN_Administered": _answers[10],
      "Reinforcement_Points": _answers[11],
      "Wake_Up_Routine": _answers[12],
      "Authorised_Substance_Use_notes": Null,
      "Emotional_Issues_notes": Null,
      "Chore_Plan_Followed_notes": Null,
      "Daily_Planner_Adhered_notes": Null,
      "Education_Has_notes": Null,
      "Exercise_Plan_Followed_notes": Null,
      "Incident_Log_Completed_notes": Null,
      "Medication_Administered_notes": Null,
      "Diet_Plan_Followed_notes": Null,
      "Personal_Care_Routine_notes": Null,
      "PRN_Administered_notes": Null,
      "Reinforcement_Points_notes": Null,
      "Wake_Up_Routine_notes": Null,
      "Progress_Notes": _progressController.text,
      "pogress_client_state": stateId,
      "pogress_client_region": regionId,
      "pogress_client_unit": unitId,
      "pogress_admin_id": widget.id,
      "pogress_created_by": widget.name,
    };
    try {
      response = await dio.post(path: AppUrls.updateProgress, data: params);
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
