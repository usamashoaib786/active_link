import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShiftDetailScreen extends StatefulWidget {
  final bool? completed;
  final shiftId;
  const ShiftDetailScreen({super.key, this.completed, this.shiftId});

  @override
  State<ShiftDetailScreen> createState() => _ShiftDetailScreenState();
}

class _ShiftDetailScreenState extends State<ShiftDetailScreen> {
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
    shiftDetail();
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
          title: "Shift Details",
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
                                text1: "Shift name ",
                                text2: "${finalResponse['shift_name']}",
                              ),
                              customRow(
                                  text1: "Client Name ",
                                  text2:
                                      "${finalResponse['f_name']} ${finalResponse['l_name']}"),
                              customRow(
                                  text1: "Shift Date",
                                  text2: "${finalResponse['shift_date']}"),
                              customRow(
                                  text1: "Start time",
                                  text2:
                                      "${finalResponse['shift_start_time']}"),
                              customRow(
                                  text1: "End Time",
                                  text2: "${finalResponse['shift_end_time']}"),
                              customRow(
                                  text1: "Clocked in",
                                  text2: "${finalResponse['clocked_in']}"),
                              customRow(
                                  text1: "Clocked out",
                                  text2: "${finalResponse['clocked_out']}"),
                              const SizedBox(
                                height: 10,
                              ),
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

  void shiftDetail() async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {"id": widget.shiftId};
    try {
      response = await dio.post(path: AppUrls.shiftDetail, data: params);
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
            finalResponse = responseData["Data"]["shifts"][0];
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
}
