import 'dart:async';

import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/AdminDocuments/document_screen.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ChatScreens/chat_screen.dart';
import 'package:active_link/View/ClientDataEntry/IncidentLog/incident_log_list.dart';
import 'package:active_link/View/ClientDataEntry/ProgressLogList/progress_log.dart';
import 'package:active_link/View/ClientDataEntry/behaviourLog/behaviour_log.dart';
import 'package:active_link/View/ClientSummary/selectClient.dart';
import 'package:active_link/View/HomeScreen/provider.dart';
import 'package:active_link/View/LeaveList/leave_list.dart';
import 'package:active_link/View/LeaveList/leave_request_form.dart';
import 'package:active_link/View/ProfileScreen/profile_screen.dart';
import 'package:active_link/View/ShiftListScreen/complete_shift_screen.dart';
import 'package:active_link/View/ShiftListScreen/shift_screen.dart';
import 'package:active_link/View/TaskManagement/complete_task.dart';
import 'package:active_link/View/TaskManagement/task_details.dart';
import 'package:active_link/View/TaskManagement/task_list.dart';
import 'package:active_link/View/ToDoNotes/to_do_notes.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_urls.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<List<Color>> gradients = [
    [const Color(0xFFBD06A8), const Color(0x21BD05A7)], // Gradient 1
    [const Color(0xFF09C7A6), const Color.fromARGB(133, 220, 227, 226)],
    [const Color(0xFF06BD7D), const Color(0x0006BD7D)],
    [const Color(0xFFFFA351), const Color(0x7EFFA351), const Color(0x00FFA351)],
    [const Color(0xFF0A85C7), const Color(0x000A85C7)],
    [const Color(0xFFFFA351), const Color(0x7EFFA351), const Color(0x00FFA351)],
    [const Color(0xFF06BD7D), const Color(0x0006BD7D)],
  ];

  var finalResponse;
  final List img = [
    "assets/images/My Shifts (2).png",
    "assets/images/Completed Shifts.png",
    "assets/images/My Shifts (2).png",
    "assets/images/Completed Shifts.png",
    "assets/images/Behaviour Registered.png",
    "assets/images/Apply Leave.png",
    "assets/images/Progress Log.png",
  ];

  final List txt = [
    "Assigned Task",
    "Completed Task",
    "My Shifts",
    "Completed Shifts",
    "Behaviour Registered",
    "Leave List",
    "Progress List",
  ];
  List screens = [
    const ShiftListScreen(),
    const MyHomePage(),
    const ProfileScreen(),
  ];
  PermissionStatus? _permissionStatus;
  late AppDio dio;
  AppLogger logger = AppLogger();
  var notificationResponse;
  bool _isLoading = false;
  int _counter = 0;
  late Timer _timer;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    homePageApi();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final open = Provider.of<NotifyProvider>(context);
    return Scaffold(
      appBar: GradientAppBar(
        onNotificationTap: () {
          showNotificationPopup(
              context: context, response: notificationResponse);
        },
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(context, const ChatScreen());
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Image.asset("assets/images/image 33.png"),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              homePageApi();
            },
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, top: 15, bottom: 15),
                    child: GestureDetector(
                      onTap: () {
                        index == 0
                            ? push(context, const TaskList())
                            : index == 1
                                ? push(context, const CompletedTaskScreen())
                                : index == 2
                                    ? push(context, const ShiftListScreen())
                                    : index == 3
                                        ? push(
                                            context, const CompletedShiftList())
                                        : index == 4
                                            ? push(context,
                                                const BehaviourLogList())
                                            : index == 5
                                                ? push(context,
                                                    const LeaveListScreen())
                                                : index == 6
                                                    ? push(context,
                                                        const ProgressLogList())
                                                    : Null;
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 10,
                        child: Container(
                          width: 350,
                          height: 127,
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                                begin: const Alignment(0.00, -1.00),
                                end: const Alignment(0, 1),
                                colors: gradients[index]),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage("${img[index]}"))),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                AppText.appText("${txt[index]}",
                                    textColor: AppTheme.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                const Spacer(),
                                finalResponse == null
                                    ? const Text("")
                                    : AppText.appText(
                                        index == 0
                                            ? "${finalResponse["taskcount"]}"
                                            : index == 1
                                                ? "${finalResponse["completedtaskcount"]}"
                                                : index == 2
                                                    ? "${finalResponse["shiftcount"]}"
                                                    : index == 3
                                                        ? "${finalResponse["completedshiftscount"]}"
                                                        : index == 4
                                                            ? "${finalResponse["behaviourcount"]}"
                                                            : index == 5
                                                                ? "${finalResponse["leavecount"]}"
                                                                : index == 6
                                                                    ? "${finalResponse["progresscount"]}"
                                                                    : "",
                                        textColor: AppTheme.whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  void getNotification() async {
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
      response = await dio.get(path: AppUrls.notifications);
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
            notificationResponse = responseData["notifications"];
            print("kefnklefnkenkfk$notificationResponse");
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

  void homePageApi() async {
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
      response = await dio.get(path: AppUrls.homePage);
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
            getNotification();
            _isLoading = false;
            finalResponse = responseData;
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

  void showNotificationPopup({response, context}) {
    print("bfjebfejbfbef${response.length}");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                height: 400,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.appText(
                              "Notifications",
                              textColor: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            GestureDetector(
                              onTap: () {
                                clearNotification();
                                setState(() {
                                  response.length = 0;
                                });
                              },
                              child: AppText.appText(
                                "Clear All",
                                textColor: const Color(0xFF1A31BB),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xFFDDDDDD),
                      ),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: response.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (response[index]["notification_type"] ==
                                    "task") {
                                  push(
                                      context,
                                      TaskDetailsScreen(
                                        taskId: response[index]["id"],
                                      ));
                                } else if (response[index]
                                        ["notification_type"] ==
                                    "leave") {
                                  push(context, const LeaveListScreen());
                                } else if (response[index]
                                        ["notification_type"] ==
                                    "incident") {
                                  push(context, const IncidentLogList());
                                } else if (response[index]
                                        ["notification_type"] ==
                                    "behaviour") {
                                  push(context, const BehaviourLogList());
                                } else {
                                  push(context, const ProgressLogList());
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height: 60,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xFFDDDDDD),
                                            width: 1))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                            "assets/images/notify.png"),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.62,
                                        child: AppText.appText(
                                          "${response[index]["message"]}",
                                          overflow: TextOverflow.ellipsis,
                                          textColor: const Color(0xFF666666),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void clearNotification() async {
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
      response = await dio.get(path: AppUrls.clearNotification);
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
            // finalResponse = responseData;
            getNotification();
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

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight = 70.0;
  final Function() onNotificationTap;
  // Callback function

  const GradientAppBar({required this.onNotificationTap});
  @override
  Widget build(BuildContext context) {
    final open = Provider.of<NotifyProvider>(context);

    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1.00, -0.07),
          end: Alignment(-1, 0.07),
          colors: [Color(0xA8CC60F2), Color(0xFFB854F2)],
        ),
      ),
      child: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: IconButton(
                icon: const Icon(
                  Icons.menu,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                if (onNotificationTap != null) {
                  onNotificationTap();
                }
              },
              child: SizedBox(
                height: 35,
                width: 35,
                child: Stack(
                  children: [
                    const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.notifications,
                          size: 35,
                          color: Colors.white,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0, top: 5),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xffFF0D0D)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool tile1 = false;
  bool tile2 = false;
  bool tile3 = false;
  bool _isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 95.0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Drawer(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText.appText("Admin Menu",
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        textColor: AppTheme.blackColor)
                  ],
                ),
                Divider(
                  color: AppTheme.blackColor,
                ),
                ListTile(
                  onTap: () {
                    push(context, const ShiftListScreen());
                  },
                  leading: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/Shift Details.png")),
                  title: AppText.appText('Shift Details',
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
                ListTile(
                  leading: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/Admin Documents.png")),
                  title: AppText.appText('Admin Documents',
                      fontSize: 14, fontWeight: FontWeight.w400),
                  onTap: () {
                    push(context, const AdminDocumentScreen());
                  },
                ),
                ListTile(
                  leading: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/Task Management.png")),
                  title: AppText.appText('Task Management',
                      fontSize: 14, fontWeight: FontWeight.w400),
                  onTap: () {
                    setState(() {
                      if (tile1 == false) {
                        tile1 = true;
                      } else {
                        tile1 = false;
                      }
                    });
                  },
                  trailing: Icon(
                    tile1 == false
                        ? Icons.keyboard_arrow_right_outlined
                        : Icons.keyboard_arrow_down_sharp,
                    size: 20,
                    color: AppTheme.blackColor,
                  ),
                ),
                tile1 == true
                    ? ListTile(
                        leading: const Icon(
                          Icons.more_horiz,
                          size: 30,
                        ),
                        title: AppText.appText('Assigned Task List',
                            fontSize: 14, fontWeight: FontWeight.w400),
                        onTap: () {
                          push(context, const TaskList());
                        },
                      )
                    : const SizedBox.shrink(),
                tile1 == true
                    ? ListTile(
                        leading: const Icon(
                          Icons.more_horiz,
                          size: 30,
                        ),
                        title: AppText.appText('Completed Task List',
                            fontSize: 14, fontWeight: FontWeight.w400),
                        onTap: () {
                          push(context, const CompletedTaskScreen());
                        },
                      )
                    : const SizedBox.shrink(),
                ListTile(
                  leading: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/To Do Notes.png")),
                  title: AppText.appText('To Do Notes',
                      fontSize: 14, fontWeight: FontWeight.w400),
                  onTap: () {
                    push(context, const ToDoNotesScreen());
                  },
                  trailing: Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 20,
                    color: AppTheme.blackColor,
                  ),
                ),
                ListTile(
                  leading: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/Leave Apply.png")),
                  title: AppText.appText('Leave Managements',
                      fontSize: 14, fontWeight: FontWeight.w400),
                  onTap: () {
                    setState(() {
                      if (tile2 == false) {
                        tile2 = true;
                      } else {
                        tile2 = false;
                      }
                    });
                  },
                  trailing: Icon(
                    tile2 == false
                        ? Icons.keyboard_arrow_right_outlined
                        : Icons.keyboard_arrow_down_sharp,
                    size: 20,
                    color: AppTheme.blackColor,
                  ),
                ),
                tile2 == true
                    ? ListTile(
                        leading: const Icon(
                          Icons.more_horiz,
                          size: 30,
                        ),
                        title: AppText.appText('Leave List',
                            fontSize: 14, fontWeight: FontWeight.w400),
                        onTap: () {
                          push(context, const LeaveListScreen());
                        },
                      )
                    : const SizedBox.shrink(),
                tile2 == true
                    ? ListTile(
                        leading: const Icon(
                          Icons.more_horiz,
                          size: 30,
                        ),
                        title: AppText.appText('Leave Request Form',
                            fontSize: 14, fontWeight: FontWeight.w400),
                        onTap: () {
                          push(context, const LeaveRequestForm());
                        },
                      )
                    : const SizedBox.shrink(),
                ListTile(
                  leading: SizedBox(
                      height: 30,
                      width: 30,
                      child:
                          Image.asset("assets/images/Client Data Entry.png")),
                  title: AppText.appText('Client data Entry',
                      fontSize: 14, fontWeight: FontWeight.w400),
                  onTap: () {
                    setState(() {
                      if (tile3 == false) {
                        tile3 = true;
                      } else {
                        tile3 = false;
                      }
                    });
                  },
                  trailing: Icon(
                    tile3 == false
                        ? Icons.keyboard_arrow_right_outlined
                        : Icons.keyboard_arrow_down_sharp,
                    size: 20,
                    color: AppTheme.blackColor,
                  ),
                ),
                tile3 == true
                    ? ListTile(
                        leading: const Icon(
                          Icons.more_horiz,
                          size: 30,
                        ),
                        title: AppText.appText('Behaviour Log',
                            fontSize: 14, fontWeight: FontWeight.w400),
                        onTap: () {
                          push(context, const BehaviourLogList());
                        },
                      )
                    : const SizedBox.shrink(),
                tile3 == true
                    ? ListTile(
                        leading: const Icon(
                          Icons.more_horiz,
                          size: 30,
                        ),
                        title: AppText.appText('Incident Log',
                            fontSize: 14, fontWeight: FontWeight.w400),
                        onTap: () {
                          push(context, const IncidentLogList());
                        },
                      )
                    : const SizedBox.shrink(),
                tile3 == true
                    ? ListTile(
                        leading: const Icon(
                          Icons.more_horiz,
                          size: 30,
                        ),
                        title: AppText.appText('Client Notes',
                            fontSize: 14, fontWeight: FontWeight.w400),
                        onTap: () {
                          push(context, const ProgressLogList());
                        },
                      )
                    : const SizedBox.shrink(),
                ListTile(
                  leading: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/Client Summary.png")),
                  title: AppText.appText('Client Summary',
                      fontSize: 14, fontWeight: FontWeight.w400),
                  onTap: () {
                    push(context, const selectedClient());
                  },
                ),
                ListTile(
                  leading: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/Log Out.png")),
                  title: AppText.appText('Logout',
                      fontSize: 14, fontWeight: FontWeight.w400),
                  onTap: () {
                    logOut();
                  },
                ),
              ],
            ),
          )),
    );
  }

  void logOut() async {
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
      response = await dio.post(path: AppUrls.logOut);
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
          });
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.clear();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LogInScreen(),
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
