import 'dart:async';
import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class CompilanceScreen extends StatefulWidget {
  const CompilanceScreen({super.key});

  @override
  State<CompilanceScreen> createState() => _CompilanceScreenState();
}

class _CompilanceScreenState extends State<CompilanceScreen> {
  List expireDate = [];
  List specified = [];
  bool _isLoading = false;
  double _progress = 0.0;
  var finalResponse;
  AppLogger logger = AppLogger();
  late AppDio dio;
  List<String?> _pickedFilePaths = List.generate(5, (index) => null);
  final List txt1 = [
    "Signature",
    "Driving License",
    "First Aid",
    "Walking With Children",
    "Other Documents"
  ];

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getCompilence();
    super.initState();
  }

  Future<void> pickDocument({required int index}) async {
    print("jbrf4flk4bfkl4$index");
    final path = await FlutterDocumentPicker.openDocument(
        params: FlutterDocumentPickerParams(
            allowedFileExtensions: ['pdf', 'png', 'jpeg', 'txt', 'docx', 'jpg'],
            invalidFileNameSymbols: ['/']));
    print("ndkfnenkfneknfnk$path");

    if (path != null && index >= 0 && index < _pickedFilePaths.length) {
      setState(() {
        _pickedFilePaths[index] = path;
        print("bejbflebfje${_pickedFilePaths[index]}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    print("kvnkkfnvfvnfvn${_pickedFilePaths}");

    return Scaffold(
        appBar: const CustomAppBar(
          title: "Compliance",
          trailing: true,
          img: "assets/images/image 42.png",
        ),
        body: _isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 20.0,
                                  left: 20,
                                ),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 10,
                                    child: SizedBox(
                                        height: 200,
                                        width: screenWidth,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              customRow(
                                                text1: "Catagory",
                                                text2: "${txt1[index]}",
                                              ),
                                              customRow(
                                                  text1: "Expires At",
                                                  text2:
                                                      "${expireDate[index]}"),
                                              customRow(
                                                  text1: "Last update ",
                                                  text2: "N/A"),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText.appText("Status",
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      textColor:
                                                          AppTheme.blackColor),
                                                  AppButton.appButton(
                                                    specified[index] == ""
                                                        ? "Not Specified"
                                                        : "Download",
                                                    onTap: () async {
                                                      if (specified[index] !=
                                                          "") {
                                                        FileDownloader
                                                            .downloadFile(
                                                          url:
                                                              "https://portaltest.thebrandwings.com/${finalResponse["upload_path"]}${specified[index]}",
                                                          notificationType:
                                                              NotificationType
                                                                  .all,
                                                          onProgress: (fileName,
                                                              progress) {
                                                            setState(() {
                                                              _progress =
                                                                  progress;
                                                            });
                                                          },
                                                          onDownloadCompleted:
                                                              (path) {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return const DownloadSuccessPopup(
                                                                  msg1:
                                                                      "Successfully",
                                                                );
                                                              },
                                                            );
                                                          },
                                                          onDownloadError:
                                                              (errorMessage) {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return const DownloadSuccessPopup(
                                                                  msg1:
                                                                      "Failed",
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );

                                                        //   final status =
                                                        //       await Permission.storage
                                                        //           .request();
                                                        //           print("objectbj$status");
                                                        //   if (status.isGranted) {
                                                        //     final externalDir =
                                                        //         await getExternalStorageDirectory();

                                                        //     } else {
                                                        //    showSnackBar(context, "Please enable gallery permission");
                                                        //   }
                                                      }
                                                    },
                                                    height: 22,
                                                    width: 120,
                                                    textColor:
                                                        AppTheme.whiteColor,
                                                    backgroundColor:
                                                        specified[index] != ""
                                                            ? Colors.blue
                                                            : const Color(
                                                                0xFFFF0D0D),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText.appText("Upload",
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      textColor:
                                                          AppTheme.blackColor),
                                                  AppButton.appButton("Upload",
                                                      onTap: () {
                                                    pickDocument(index: index);
                                                  },
                                                      height: 22,
                                                      width: 120,
                                                      textColor:
                                                          AppTheme.whiteColor,
                                                      backgroundColor:
                                                          specified[index] != ""
                                                              ? Colors.blue
                                                              : const Color(
                                                                  0xFFFF0D0D))
                                                ],
                                              ),
                                              _pickedFilePaths[index] == null
                                                  ? const SizedBox.shrink()
                                                  : AppText.appText(
                                                      "${_pickedFilePaths[index]}")
                                            ],
                                          ),
                                        )))),
                          );
                        },
                      ),
                      _isLoading == true
                          ? const Center(child: CircularProgressIndicator())
                          : AppButton.appButton("Update", onTap: () {
                              uploadFile();
                            },
                              textColor: AppTheme.whiteColor,
                              backgroundColor: const Color(0xff00BFA5),
                              height: 30,
                              width: 100)
                    ],
                  ),
                ),
              ));
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

  Future<void> uploadFile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<MultipartFile> files = [];
      List<String> keys = [];

      for (int i = 0; i < _pickedFilePaths.length; i++) {
        if (_pickedFilePaths[i] != null) {
          String fileName = _pickedFilePaths[i]!.split('/').last;
          String key =
              getKeyForIndex(i); // Define a method to get key for index i
          keys.add(key);
          files.add(await MultipartFile.fromFile(
            _pickedFilePaths[i]!,
            filename: fileName,
          ));
        }
      }

      FormData formData = FormData.fromMap(Map.fromEntries(List.generate(
          keys.length, (index) => MapEntry(keys[index], files[index]))));
      formData.fields
          .add(MapEntry("upload_path", finalResponse["upload_path"]));

      Response response = await dio.post(
        path: AppUrls.uploadDocument,
        data: formData,
      );

      if (response.statusCode == 200) {
        showSnackBar(context, "${response.data["message"]}");
        setState(() {
          _isLoading = false;
          _pickedFilePaths = List.generate(5, (index) => null);
          getCompilence();
        });
      } else {
        showSnackBar(context, "${response.data["message"]}");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      showSnackBar(context, "${error}");
      setState(() {
        _isLoading = false;
      });
    }
  }

  String getKeyForIndex(int index) {
    switch (index) {
      case 0:
        return 'signature';
      case 1:
        return 'driving_licence';
      case 2:
        return 'first_aid';
      case 3:
        return 'walking_with_children';
      case 4:
        return 'other_documents';
      default:
        throw Exception('Invalid index');
    }
  }

  void getCompilence() async {
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
      response = await dio.get(
        path: AppUrls.profile,
      );
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
            finalResponse = responseData["user_details"];
            specified = [
              "${finalResponse["signature"]}",
              "${finalResponse["driving_licence"]}",
              "${finalResponse["first_aid"]}",
              "${finalResponse["walking_with_children"]}",
              "${finalResponse["other_documents"]}",
            ];
            expireDate = [
              "N/A",
              "${finalResponse["dl_exp_date"]}",
              "${finalResponse["first_aid_exp_date"]}",
              "${finalResponse["walking_with_children_exp_date"]}",
              "N/A"
            ];
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

class DownloadSuccessPopup extends StatefulWidget {
  final msg1;

  const DownloadSuccessPopup({super.key, required this.msg1});

  @override
  State<DownloadSuccessPopup> createState() => _DownloadSuccessPopupState();
}

class _DownloadSuccessPopupState extends State<DownloadSuccessPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.appColor,
      title: AppText.appText('Download ${widget.msg1}',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          textColor: AppTheme.whiteColor),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton.appButton(
              "Ok",
              borderColor: AppTheme.whiteColor,
              textColor: AppTheme.whiteColor,
              height: 40,
              radius: 1,
              width: 70,
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ],
    );
  }
}
