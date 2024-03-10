import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ClientDataEntry/ProgressLogList/progree_log_add.dart';
import 'package:active_link/View/ClientDataEntry/ProgressLogList/progress_log_api.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:active_link/config/keys/pref_keys.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressLogList extends StatefulWidget {
  const ProgressLogList({super.key});

  @override
  State<ProgressLogList> createState() => _ProgressLogListState();
}

class _ProgressLogListState extends State<ProgressLogList> {
  var selectedClient = "Select Client";
  var selectedState = "Select State";
  DateTime? startDate;
  DateTime? endDate;
  late AppDio dio;
  AppLogger logger = AppLogger();
  final progressApiService = ProgressApiServices();

  bool _isLoading = false;
  var finalResponse;
  var apiClientresponse;
  var statesResponse;
  var staffResponse;
  var idResponse;
  var nameResponse;

  final ExpansionTileController clientController = ExpansionTileController();
  final ExpansionTileController stateController = ExpansionTileController();
  var pAdd;
  var pEdit;
  var pView;
  var clientId;
  var stateId;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getClients();
    getProgressLogList();
    super.initState();
  }

  getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pAdd = prefs.getString(PrefKey.pLogAdd);
      pEdit = prefs.getString(PrefKey.pLogEdit);
      pView = prefs.getString(PrefKey.pLogView);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        title: "Progress Log List",
        trailing: pAdd == "on" ? true : false,
        img: "assets/images/Vector.png",
        onTap: () {
          push(
              context,
              ProgressLogAdd(
                staffRes: staffResponse,
                stateRes: statesResponse,
                clientRes: apiClientresponse,
                name: nameResponse,
                id: idResponse,
              ));
        },
      ),
      body: apiClientresponse == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 1,
                          width: 1,
                        ),
                        AppButton.appButton("Search", onTap: () {
                          search();
                        },
                            width: 235,
                            height: 36,
                            borderColor: const Color(0xff3EB1B1),
                            textColor: const Color(0xff3EB1B1)),
                        GestureDetector(
                          onTap: () {
                            progressApiService.progressLogs(
                                dio: dio, context: context);
                          },
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset("assets/images/image 18.png"),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AppText.appText("Select Clients",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: const Color(0xff666666)),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: screenWidth,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFFDDDDDD)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: ExpansionTile(
                        controller: clientController,
                        title: AppText.appText(
                          '$selectedClient',
                          textColor: const Color(0xFF666666),
                          fontSize: 14,
                        ),
                        children: [
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: apiClientresponse.length,
                              itemBuilder: (context, index) {
                                return customRow(
                                    onTap: () {
                                      setState(() {
                                        if (clientController.isExpanded) {
                                          clientController.collapse();
                                        } else {
                                          clientController.expand();
                                        }
                                        selectedClient =
                                            "${apiClientresponse[index]["f_name"]}  ${apiClientresponse[index]["l_name"]}";
                                        clientId = apiClientresponse[index]
                                            ["cl_unq_no"];
                                      });
                                    },
                                    txt:
                                        "${apiClientresponse[index]["f_name"]}  ${apiClientresponse[index]["l_name"]}");
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AppText.appText("Select State",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: const Color(0xff666666)),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: screenWidth,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFFDDDDDD)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: ExpansionTile(
                        controller: stateController,
                        title: AppText.appText(
                          '$selectedState',
                          textColor: const Color(0xFF666666),
                          fontSize: 14,
                        ),
                        children: [
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: statesResponse.length,
                              itemBuilder: (context, index) {
                                return customRow(
                                    onTap: () {
                                      setState(() {
                                        if (stateController.isExpanded) {
                                          stateController.collapse();
                                        } else {
                                          stateController.expand();
                                        }
                                        selectedState =
                                            "${statesResponse[index]["state_name"]}";
                                        stateId =
                                            statesResponse[index]["state_id"];
                                      });
                                    },
                                    txt:
                                        "${statesResponse[index]["state_name"]}");
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText(
                              'From Date *',
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
                                height: 40,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFFDDDDDD)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText(
                              'To Date *',
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
                                height: 40,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFFDDDDDD)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
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
                      height: 15,
                    ),
                    finalResponse == null
                        ? const Center(child: const CircularProgressIndicator())
                        : ListView.builder(
                            physics: const ScrollPhysics(),
                            itemCount: finalResponse["data"].length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var response = finalResponse["data"];
                              return IncidentLogContainer(
                                data: response[index],
                                name: nameResponse,
                                staffRes: staffResponse,
                                stateRes: statesResponse,
                                clientRes: apiClientresponse,
                                id: idResponse,
                                showEdit: pEdit,
                                showView: pView,
                              );
                            },
                          ),
                  ],
                ),
              ),
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

  void getProgressLogList() async {
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
      response = await dio.get(path: AppUrls.progressLogList);
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
            finalResponse = responseData;
            idResponse = finalResponse["staffdetails"][0]["id"];
            nameResponse = finalResponse["staffdetails"][0]["full_name"];

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

  void getClients() async {
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
            apiClientresponse = responseData["clients"];
            statesResponse = responseData["state"];
            staffResponse = responseData["staffdata"];
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

  void search() async {
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
      "pogress_search_client_id": clientId,
      "pogress_search_state_id": stateId,
      "pogress_search_date_from": startDate,
      "pogress_search_date_to": endDate,
    };
    try {
      response = await dio.post(path: AppUrls.searchProgress, data: params);
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
            finalResponse = responseData;
            print("object$finalResponse");
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

class IncidentLogContainer extends StatefulWidget {
  final data;
  final name;
  final stateRes;
  final staffRes;
  final clientRes;
  final id;
  final showEdit;
  final showView;
  const IncidentLogContainer(
      {super.key,
      this.data,
      this.name,
      this.clientRes,
      this.id,
      this.staffRes,
      this.stateRes,
      this.showEdit,
      this.showView});

  @override
  State<IncidentLogContainer> createState() => _IncidentLogContainerState();
}

class _IncidentLogContainerState extends State<IncidentLogContainer> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, top: 10),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            child: Container(
                height: 170,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customRow(
                        text1: "Refrence",
                        text2: "${widget.data["client_pogress_id"]}",
                      ),
                      customRow(
                          text1: "Client ",
                          text2:
                              "${widget.data["f_name"]} ${widget.data["l_name"]}"),
                      customRow(text1: "Created By ", text2: "${widget.name}"),
                      customRow(
                          text1: "Entry Date ",
                          text2: "${widget.data["pogress_created"]}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.appText("Action",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: AppTheme.blackColor),
                          Row(
                            children: [
                              widget.showView == "on"
                                  ? actionContainer(
                                      onTap: () {
                                        push(
                                            context,
                                            ProgressLogAdd(
                                              staffRes: widget.staffRes,
                                              stateRes: widget.stateRes,
                                              clientRes: widget.clientRes,
                                              name: widget.name,
                                              id: widget.id,
                                              showButton: false,
                                              edit: true,
                                              logId: widget
                                                  .data["client_pogress_id"],
                                            ));
                                      },
                                      icon: Icons.visibility,
                                      color: const Color(0xff1A0B8F))
                                  : SizedBox.shrink(),
                              const SizedBox(
                                width: 10,
                              ),
                              widget.showEdit == "on"
                                  ? actionContainer(
                                      onTap: () {
                                        push(
                                            context,
                                            ProgressLogAdd(
                                              showButton: true,
                                              edit: true,
                                              staffRes: widget.staffRes,
                                              stateRes: widget.stateRes,
                                              clientRes: widget.clientRes,
                                              name: widget.name,
                                              id: widget.id,
                                              logId: widget
                                                  .data["client_pogress_id"],
                                            ));
                                      },
                                      icon: Icons.edit,
                                      color: const Color(0xff1A0B8F))
                                  : SizedBox.shrink()
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ))));
  }

  Widget customRow({text1, text2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.appText("$text1",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: AppTheme.blackColor),
        AppText.appText("$text2",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: const Color(0xFF666666)),
      ],
    );
  }

  Widget actionContainer({icon, color, onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(100),
            border: Border.all(width: 1, color: color)),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 15,
          ),
        ),
      ),
    );
  }
}
