import 'dart:isolate';
import 'dart:ui';

import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ProfileScreen/compilence.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class InnerDocumentList extends StatefulWidget {
  final docId;
  const InnerDocumentList({super.key, this.docId});

  @override
  State<InnerDocumentList> createState() => _InnerDocumentListState();
}

class _InnerDocumentListState extends State<InnerDocumentList> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  var finalResponse;
  double _progress = 0.0;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    adminDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Document list",
      ),
      body: finalResponse == null
          ? Center(
              child: CircularProgressIndicator(
              color: AppTheme.appColor,
            ))
          : ListView.builder(
              itemCount: finalResponse.length,
              itemBuilder: (context, index) {
                return
                    // DocumentContainer(
                    //   documentData: finalResponse[index],
                    // );
                    Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20, top: 10),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 10,
                            child: SizedBox(
                                height: 120,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      customRow(
                                        text1: "Folder Name",
                                        text2:
                                            "${finalResponse[index]["cat_name"]}",
                                      ),
                                      customRow(
                                          text1: "Document name ",
                                          text2:
                                              "${finalResponse[index]["doc_name"]}"),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText.appText("Download Document",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppTheme.blackColor),
                                          GestureDetector(
                                            onTap: () async {
                                              FileDownloader.downloadFile(
                                                url:
                                                    "https://portaltest.thebrandwings.com/upload/admin_doc/${finalResponse[index]["document"]}",
                                                notificationType:
                                                    NotificationType.all,
                                                onProgress:
                                                    (fileName, progress) {
                                                  setState(() {
                                                    _progress = progress;
                                                  });
                                                },
                                                onDownloadCompleted: (path) {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return const DownloadSuccessPopup(
                                                        msg1: "Successfully",
                                                      );
                                                    },
                                                  );
                                                },
                                                onDownloadError:
                                                    (errorMessage) {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return const DownloadSuccessPopup(
                                                        msg1: "Failed",
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            child: SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: Image.asset(
                                                  "assets/images/Download & Upload Documents Icon.png"),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ))));
              },
            ),
    );
  }

  void adminDocument() async {
    setState(() {});
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {"id": widget.docId};
    try {
      response = await dio.post(path: AppUrls.documents, data: params);
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
            finalResponse = responseData["documents"];
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
}
