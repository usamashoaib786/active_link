import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/AdminDocuments/inner_document.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';

class AdminDocumentScreen extends StatefulWidget {
  const AdminDocumentScreen({super.key});

  @override
  State<AdminDocumentScreen> createState() => _AdminDocumentScreenState();
}

class _AdminDocumentScreenState extends State<AdminDocumentScreen> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  var finalResponse;

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
      appBar: CustomAppBar(
        title: "Document list for testing",
      ),
      body: finalResponse == null
          ? Center(
              child: CircularProgressIndicator(
              color: AppTheme.appColor,
            ))
          : ListView.builder(
              itemCount: finalResponse.length,
              itemBuilder: (context, index) {
                return DocumentContainer(
                  documentData: finalResponse[index],
                );
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

    try {
      response = await dio.get(path: AppUrls.adminDocument);
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
            finalResponse = responseData["doc_cat_list"];
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

class DocumentContainer extends StatefulWidget {
  final documentData;
  const DocumentContainer({super.key, this.documentData});

  @override
  State<DocumentContainer> createState() => _DocumentContainerState();
}

class _DocumentContainerState extends State<DocumentContainer> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, top: 10),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            child: SizedBox(
                height: 120,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customRow(
                        text1: "Folder Name",
                        text2: "${widget.documentData["cat_name"]}",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.appText("View Documents",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: AppTheme.blackColor),
                          GestureDetector(
                            onTap: () {
                              push(
                                  context,
                                  InnerDocumentList(
                                    docId: "${widget.documentData["adc_id"]}",
                                  ));
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(100),
                                  border: Border.all(
                                      width: 1,
                                      color: const Color(0xff1A0B8F))),
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
                      ),
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
            textColor: AppTheme.blackColor),
      ],
    );
  }
}
