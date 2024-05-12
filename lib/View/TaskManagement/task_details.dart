
import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/TaskManagement/complete_task.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailsScreen extends StatefulWidget {
  final bool? completed;
  final taskId;
  const TaskDetailsScreen({super.key, this.completed, this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  var finalResponse;
  String dateTime = "";
  String? textStartTyme;
  String? textEndTyme;
  var timeResponse;
  Duration totalWorkingHours = Duration.zero;
  int? hours;
  int? min;
  int? sec;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getCurrentDateTime();
    completedTaskDetail();
    super.initState();
  }

  getCurrentDateTime() {
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
    dateTime = "$cdate $tdata ";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: const CustomAppBar(
          title: "Task Details",
        ),
        body: finalResponse == null
            ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.appColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                    right: 20.0, left: 20, top: 10, bottom: 10),
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 10,
                    child: SizedBox(
                        width: screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Column(
                            children: [
                              customRow(
                                text1: "Customer name ",
                                text2:
                                    "${finalResponse['f_name']} ${finalResponse['l_name']}",
                              ),
                              customRow(
                                  text1: "Task Name ",
                                  text2: "${finalResponse['task_name']}"),
                              customRow(
                                  text1: "Assigned Date",
                                  text2: "${finalResponse['createdd']}"),
                              widget.completed == true
                                  ? customRow(
                                      text1: "Completed Task",
                                      text2: "${finalResponse['createdd']}")
                                  : const SizedBox.shrink(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText.appText("Job Description",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppTheme.blackColor),
                                  Container(
                                      width: screenWidth * 0.4,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        width: 1,
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AppText.appText(
                                            "${finalResponse['job_desc']}"),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              customRow(
                                  text1: "Total working hours",
                                  text2: "${hours} hour ${min}min ${sec} sec"),
                              widget.completed == false
                                  ? finalResponse == null
                                      ? const SizedBox.shrink()
                                      : SizedBox(
                                          width: screenWidth,
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.start,
                                            spacing: 15,
                                            runSpacing: 15,
                                            children: [
                                              AppButton.appButton("CLock In",
                                                  onTap: () {
                                                if (timeResponse.length == 0) {
                                                  clockInApi();
                                                } else {
                                                  if (timeResponse[
                                                          timeResponse.length -
                                                              1]["end_time"] !=
                                                      null) {
                                                    clockInApi();
                                                  }
                                                }
                                              },
                                                  backgroundColor: timeResponse
                                                              .length ==
                                                          0
                                                      ? const Color(0xfF1149D0)
                                                      : timeResponse[timeResponse
                                                                          .length -
                                                                      1][
                                                                  "end_time"] !=
                                                              null
                                                          ? const Color(
                                                              0xFF1149D0)
                                                          : const Color(
                                                              0x7F1149D0),
                                                  textColor:
                                                      AppTheme.whiteColor,
                                                  width: 80,
                                                  height: 30),
                                              timeResponse.length == 0
                                                  ? const SizedBox.shrink()
                                                  : AppButton.appButton("Stop",
                                                      onTap: () async {
                                                      await getCurrentDateTime();
                                                      clockStopApi(
                                                          tc_id: timeResponse[
                                                              timeResponse
                                                                      .length -
                                                                  1]["tc_id"]);
                                                    },
                                                      backgroundColor: timeResponse[
                                                                      timeResponse
                                                                              .length -
                                                                          1]
                                                                  [
                                                                  "end_time"] ==
                                                              null
                                                          ? const Color(
                                                              0xFF1149D0)
                                                          : const Color(
                                                              0x7F1149D0),
                                                      textColor:
                                                          AppTheme.whiteColor,
                                                      width: 80,
                                                      height: 30),
                                              timeResponse.length == 0
                                                  ? const SizedBox.shrink()
                                                  : AppButton.appButton(
                                                      "Click to complete",
                                                      onTap: () {
                                                      clickToComplete();
                                                    },
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF00BFA5),
                                                      textColor:
                                                          AppTheme.whiteColor,
                                                      width: 127,
                                                      height: 30)
                                            ],
                                          ),
                                        )
                                  : const SizedBox.shrink(),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: timeResponse.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        timeResponse == null
                                            ? const SizedBox.shrink()
                                            : customRow(
                                                text1: "Start Time",
                                                text2:
                                                    "${timeResponse[index]["start_time"]}",
                                                color2:
                                                    const Color(0xFF28B604)),
                                        customRow(
                                          text1: "End Time",
                                          text2:
                                              "${timeResponse[index]["end_time"]}",
                                          color2: const Color(0xFFFF0C0C),
                                        ),
                                        timeResponse[index]["end_time"] == null
                                            ? SizedBox.shrink()
                                            : workFor(
                                                startTime: timeResponse[index]
                                                    ["start_time"],
                                                endTime: timeResponse[index]
                                                    ["end_time"],
                                              ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        )))));
  }

  Widget customRow({text1, text2, color1, color2}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.appText("$text1",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: color1 ?? AppTheme.blackColor),
            AppText.appText("$text2",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: color2 ?? AppTheme.blackColor),
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  void completedTaskDetail() async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {"taskid": widget.taskId};
    try {
      response =
          await dio.post(path: AppUrls.completedTaskDetail, data: params);
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
            finalResponse = responseData["task_details"][0];
            timeResponse = responseData["timming"];
            calculateTotalTime(response: responseData["timming"]);
            print("hwcvhvefvjkvk$timeResponse");
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

  void clockInApi() async {
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
      "tym": dateTime,
      "t_id": widget.taskId,
    };
    try {
      response = await dio.post(path: AppUrls.clockIn, data: params);
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
            completedTaskDetail();
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

  void clockStopApi({tc_id}) async {
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
      "tym": dateTime,
      "t_id": widget.taskId,
      "tc_id": tc_id
    };
    try {
      response = await dio.post(path: AppUrls.clockStop, data: params);
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
            completedTaskDetail();
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

  void clickToComplete() async {
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
      "t_id": widget.taskId,
    };
    try {
      response = await dio.post(path: AppUrls.complete, data: params);
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
            pushReplacement(context, const CompletedTaskScreen());
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

  calculateTotalTime({response}) {
    for (var entry in response) {
     if (entry['end_time']!= null) {
        String startTime = entry['start_time'];
      String endTime = entry['end_time'];

      DateTime start = DateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime);
      DateTime end = DateFormat("yyyy-MM-dd HH:mm:ss").parse(endTime);

      Duration diff = end.difference(start);
      totalWorkingHours += diff;
      print("jbfjbefk$totalWorkingHours");
     }
    }
    hours = totalWorkingHours.inHours;
    min = totalWorkingHours.inMinutes.remainder(60);
    sec = totalWorkingHours.inSeconds.remainder(60);
  }

  Widget workFor({startTime, endTime}) {
    DateTime start = DateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime);
    DateTime end = DateFormat("yyyy-MM-dd HH:mm:ss").parse(endTime);

    Duration difference = end.difference(start);

    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);
    int seconds = difference.inSeconds.remainder(60);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.appText("Worked for",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: AppTheme.blackColor),
            AppText.appText('$hours hour $minutes min $seconds sec',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: AppTheme.blackColor),
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
