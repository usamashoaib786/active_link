import 'dart:isolate';
import 'dart:ui';
import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CompilanceScreen extends StatefulWidget {
  final data;
  const CompilanceScreen({super.key, this.data});

  @override
  State<CompilanceScreen> createState() => _CompilanceScreenState();
}

class _CompilanceScreenState extends State<CompilanceScreen> {
  List expireDate = [];
  List specified = [];
  ReceivePort _receivePort = ReceivePort();
  int _progress = 0;
  static downloadingCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("Downloading");
    sendPort!.send([id, status, progress]);
  }

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
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "Downloading");
    _receivePort.listen((message) {
      setState(() {
        _progress = message[2];
      });
      print(_progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
    specified = [
      "${widget.data["signature"]}",
      "${widget.data["driving_licence"]}",
      "${widget.data["first_aid"]}",
      "${widget.data["walking_with_children"]}",
      "${widget.data["other_documents"]}",
    ];
    expireDate = [
      "N/A",
      "${widget.data["dl_exp_date"]}",
      "${widget.data["first_aid_exp_date"]}",
      "${widget.data["walking_with_children_exp_date"]}",
      "N/A"
    ];

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
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
                                  borderRadius: BorderRadius.circular(10)),
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
                                            text2: "${expireDate[index]}"),
                                        customRow(
                                            text1: "Last update ",
                                            text2: "N/A"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText.appText("Status",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                textColor: AppTheme.blackColor),
                                            AppButton.appButton(
                                                specified[index] == ""
                                                    ? "Not Specified"
                                                    : "Download",
                                                onTap: () async {
                                              if (specified[index] != "") {
                                                final status = await Permission
                                                    .storage
                                                    .request();
                                                if (status.isGranted) {
                                                  final externalDir =
                                                      await getExternalStorageDirectory();
                                                  FlutterDownloader.enqueue(
                                                    url:
                                                        "https://portaltest.thebrandwings.com/${widget.data["upload_path"]}${specified[index]}",
                                                    savedDir: externalDir!.path,
                                                    fileName: "Download",
                                                    showNotification: true,
                                                    openFileFromNotification:
                                                        true,
                                                  );
                                                } else {
                                                  print("Permission Denied");
                                                }
                                              }
                                            },
                                                height: 22,
                                                width: 120,
                                                textColor: AppTheme.whiteColor,
                                                backgroundColor:
                                                    specified[index] != ""
                                                        ? Colors.blue
                                                        : const Color(
                                                            0xFFFF0D0D))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText.appText("Upload",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                textColor: AppTheme.blackColor),
                                            AppButton.appButton("Upload",
                                                onTap: () {
                                              pickDocument(index: index);
                                            },
                                                height: 22,
                                                width: 120,
                                                textColor: AppTheme.whiteColor,
                                                backgroundColor:
                                                    specified[index] != ""
                                                        ? Colors.blue
                                                        : const Color(
                                                            0xFFFF0D0D))
                                          ],
                                        ),
                                        _pickedFilePaths[index] == null
                                            ? SizedBox.shrink()
                                            : AppText.appText(
                                                "${_pickedFilePaths[index]!}")
                                      ],
                                    ),
                                  )))),
                    );
                  },
                ),
                AppButton.appButton("Update", onTap: () {
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
    try {
      String fileName1 = _pickedFilePaths[0]!.split('/').last;
      String fileName2 = _pickedFilePaths[1]!.split('/').last;
      String fileName3 = _pickedFilePaths[2]!.split('/').last;
      String fileName4 = _pickedFilePaths[3]!.split('/').last;
      String fileName5 = _pickedFilePaths[4]!.split('/').last;

      FormData formData = FormData.fromMap({
        'signature': await MultipartFile.fromFile(
          _pickedFilePaths[0]!,
          filename: fileName1,
        ),
        'driving_licence': await MultipartFile.fromFile(
          _pickedFilePaths[1]!,
          filename: fileName2,
        ),
        'first_aid': await MultipartFile.fromFile(
          _pickedFilePaths[2]!,
          filename: fileName3,
        ),
        'walking_with_children': await MultipartFile.fromFile(
          _pickedFilePaths[3]!,
          filename: fileName4,
        ),
        'other_documents': await MultipartFile.fromFile(
          _pickedFilePaths[4]!,
          filename: fileName5,
        ),
        "upload_path": widget.data["upload_path"]
      });

      Response response =
          await dio.post(path: AppUrls.uploadDocument, data: formData);

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading file: $error');
    }
  }
}
