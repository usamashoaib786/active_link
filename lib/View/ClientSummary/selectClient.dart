import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ClientSummary/client_summary.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';

class selectedClient extends StatefulWidget {
  const selectedClient({super.key});

  @override
  State<selectedClient> createState() => _selectedClientState();
}

class _selectedClientState extends State<selectedClient> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  var finalResponse;
  var apiClientresponse;
  var statesResponse;
  var staffResponse;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Client Summary",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.appText("Select Client",
                textColor: const Color(0xff3EB1B1),
                fontSize: 16,
                fontWeight: FontWeight.w400),
            const SizedBox(
              height: 10,
            ),
            apiClientresponse == null
                ? Container(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.appColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: apiClientresponse.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            push(
                                context,
                                ClientSummary(
                                    id: apiClientresponse[index]["cl_unq_no"]));
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1,
                                    color: const Color.fromARGB(
                                        255, 181, 181, 181))),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: AppText.appText(
                                  "${apiClientresponse[index]["f_name"]} ${apiClientresponse[index]["m_name"]} ${apiClientresponse[index]["f_name"]}"),
                            ),
                          ),
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
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
}
