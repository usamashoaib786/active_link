import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ShiftListScreen/map_screen.dart';
import 'package:active_link/View/ShiftListScreen/shift_detail_screen.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:geolocator/geolocator.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';

class ShiftListScreen extends StatefulWidget {
  const ShiftListScreen({super.key});

  @override
  State<ShiftListScreen> createState() => _ShiftListScreenState();
}

class _ShiftListScreenState extends State<ShiftListScreen> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  bool filter = false;
  bool filter1 = false;
  bool filter2 = false;

  var finalResponse;
  Position? _currentPosition;

  Future<bool> _getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.openLocationSettings();
        await ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
      }
      if (permission == LocationPermission.always) {
        return true;
      }

      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    _getLocationPermission();

    shiftList();

    super.initState();
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    print("j bjdfbjjbfjb$hasPermission");
    if (!hasPermission) return;
    // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
    // .then((Position position) {
    // setState(() => _currentPosition = position);
    // }).catchError((e) {
    // debugPrint(e);
    // });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: "Shift List",
          trailing: false,
          click: false,
        ),
        body: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 30, bottom: 10),
                  child: Row(
                    children: [
                      AppButton.appButton("Today", onTap: () {
                        todayShifts();
                      },
                          height: 22,
                          textColor: AppTheme.whiteColor,
                          width: 82,
                          backgroundColor: filter == true
                              ? const Color(0xff1149D0)
                              : const Color.fromARGB(255, 169, 187, 228)),
                      const SizedBox(
                        width: 10,
                      ),
                      AppButton.appButton("Upcoming", onTap: () {
                        upcomingShift();
                      },
                          height: 22,
                          textColor: AppTheme.whiteColor,
                          width: 82,
                          backgroundColor: filter1 == true
                              ? const Color(0xff1149D0)
                              : const Color.fromARGB(255, 169, 187, 228)),
                      const SizedBox(
                        width: 10,
                      ),
                      AppButton.appButton("Completed", onTap: () {
                        completeShift();
                      },
                          height: 22,
                          textColor: AppTheme.whiteColor,
                          width: 82,
                          backgroundColor: filter2 == true
                              ? const Color(0xff1149D0)
                              : const Color.fromARGB(255, 169, 187, 228)),
                      const Spacer(),
                      Icon(
                        Icons.search,
                        color: AppTheme.txtColor,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    color: AppTheme.txtColor,
                  ),
                )
              ],
            ),
            finalResponse == null
                ? SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child:
                          CircularProgressIndicator(color: AppTheme.appColor),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: finalResponse["shifts"].length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(
                                right: 20.0, left: 20, top: 10),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 10,
                                child: SizedBox(
                                    height: 230,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          customRow(
                                            text1: "Shift Name",
                                            text2:
                                                "${finalResponse["shifts"][index]["shift_name"]}",
                                          ),
                                          customRow(
                                              text1: "Client name ",
                                              text2:
                                                  "${finalResponse["shifts"][index]["f_name"]} ${finalResponse["shifts"][index]["l_name"]}"),
                                          customRow(
                                              text1: "Shift date ",
                                              text2:
                                                  "${finalResponse["shifts"][index]["shift_date"]}"),
                                          customRow(
                                              text1: "Shift start time ",
                                              text2:
                                                  "${finalResponse["shifts"][index]["shift_start_time"]}"),
                                          customRow(
                                              text1: "Shift end time ",
                                              text2:
                                                  "${finalResponse["shifts"][index]["shift_end_time"]}"),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppText.appText("Status",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  textColor:
                                                      AppTheme.blackColor),
                                              finalResponse["shifts"][index]
                                                              ["shift_break"] ==
                                                          "2" &&
                                                      finalResponse["shifts"][index]["shift_complete"] ==
                                                          null
                                                  ? AppButton.appButton("Complete",
                                                      onTap: () {
                                                      push(
                                                          context,
                                                          MapScreen(
                                                              breakIn: false,
                                                              id: finalResponse[
                                                                          "shifts"]
                                                                      [index][
                                                                  "shift_id"]));
                                                    },
                                                      height: 22,
                                                      textColor:
                                                          AppTheme.whiteColor,
                                                      width: 90,
                                                      backgroundColor: const Color(
                                                          0xff1149D0))
                                                  : finalResponse["shifts"][index]
                                                              ["shift_start"] ==
                                                          "1"
                                                      ? finalResponse["shifts"][index]["shift_complete"] ==
                                                              "1"
                                                          ? AppButton.appButton(
                                                              "Completed",
                                                              height: 22,
                                                              textColor: AppTheme
                                                                  .whiteColor,
                                                              width: 90,
                                                              backgroundColor: const Color(0xff28B705))
                                                          : Row(
                                                              children: [
                                                                AppButton.appButton(
                                                                    finalResponse["shifts"][index]["shift_break"] ==
                                                                            "1"
                                                                        ? "Unbreak"
                                                                        : "Break",
                                                                    onTap: () {
                                                                  if (finalResponse["shifts"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "shift_break"] !=
                                                                      "1") {
                                                                    breakApi(
                                                                        id: finalResponse["shifts"][index]
                                                                            [
                                                                            "shift_id"]);
                                                                  } else {
                                                                    unBreakApi(
                                                                        id: finalResponse["shifts"][index]
                                                                            [
                                                                            "shift_id"]);
                                                                  }
                                                                },
                                                                    height: 22,
                                                                    textColor:
                                                                        AppTheme
                                                                            .whiteColor,
                                                                    width: 80,
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xffF32184)),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                AppButton.appButton(
                                                                    "Complete",
                                                                    onTap: () {
                                                                  push(
                                                                      context,
                                                                      MapScreen(
                                                                          breakIn:
                                                                              false,
                                                                          id: finalResponse["shifts"][index]
                                                                              [
                                                                              "shift_id"]));
                                                                },
                                                                    height: 22,
                                                                    textColor:
                                                                        AppTheme
                                                                            .whiteColor,
                                                                    width: 80,
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xff00BFA5))
                                                              ],
                                                            )
                                                      : AppButton.appButton("CLock In", onTap: () {
                                                          push(
                                                              context,
                                                              MapScreen(
                                                                  breakIn: true,
                                                                  id: finalResponse[
                                                                              "shifts"]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "shift_id"]));
                                                          // _getCurrentLocation();
                                                          // showMapDialog(
                                                          //     context);

                                                          //
                                                        }, height: 22, textColor: AppTheme.whiteColor, width: 80, backgroundColor: const Color(0xff1149D0))
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppText.appText("Action",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  textColor:
                                                      AppTheme.blackColor),
                                              GestureDetector(
                                                onTap: () {
                                                  push(
                                                      context,
                                                      ShiftDetailScreen(
                                                          shiftId: finalResponse[
                                                                      "shifts"]
                                                                  [index]
                                                              ["shift_id"]));
                                                },
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadiusDirectional
                                                              .circular(100),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: const Color(
                                                              0xff1A0B8F))),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.visibility,
                                                      color: Color(0xff1A0B8F),
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ))));
                      },
                    ),
                  ),
          ],
        ));
  }

  void shiftList() async {
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
      response = await dio.get(path: AppUrls.shiftList);
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
            finalResponse = responseData["Data"];

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

  void todayShifts() async {
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
      response = await dio.get(path: AppUrls.todatShift);
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
            filter2 = false;
            filter = true;
            filter1 = false;
            finalResponse = responseData["Data"];

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

  void upcomingShift() async {
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
      response = await dio.get(path: AppUrls.upcomingShift);
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
            filter2 = false;
            filter = false;
            filter1 = true;

            finalResponse = responseData["Data"];

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

  void completeShift() async {
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
      response = await dio.get(path: AppUrls.completeShift);
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
            filter2 = true;
            filter = false;
            filter1 = false;

            finalResponse = responseData["Data"];

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
            textColor: AppTheme.blackColor),
      ],
    );
  }

  void breakApi({id}) async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {"id": id};
    try {
      response = await dio.post(path: AppUrls.shiftBreak, data: params);
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
            shiftList();
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

  void unBreakApi({id}) async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {"id": id};
    try {
      response = await dio.post(path: AppUrls.shiftUnBreak, data: params);
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
            shiftList();
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
