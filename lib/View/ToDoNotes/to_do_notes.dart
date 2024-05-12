import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ToDoNotes/add_todo.dart';
import 'package:active_link/View/ToDoNotes/edit_todo.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';

class ToDoNotesScreen extends StatefulWidget {
  const ToDoNotesScreen({super.key});

  @override
  State<ToDoNotesScreen> createState() => _ToDoNotesScreenState();
}

class _ToDoNotesScreenState extends State<ToDoNotesScreen> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  var finalResponse;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    toDoList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "All To Do List",
        trailing: true,
        img: "assets/images/plus.png",
        onTap: () {
          push(context, const AddToDoList());
        },
      ),
      body: finalResponse == null
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: finalResponse.length,
              itemBuilder: (context, index) {
                return DocumentContainer(
                  listData: finalResponse[index],
                );
              },
            ),
    );
  }

  void toDoList() async {
    setState(() {});
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    try {
      response = await dio.get(path: AppUrls.toDoList);
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
            finalResponse = responseData["to_do_list"];
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
  final listData;
  const DocumentContainer({super.key, this.listData});

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
                        text1: "Note",
                        text2: "${widget.listData["note_subject"]}",
                      ),
                      customRow(
                          text1: "Date ",
                          text2: "${widget.listData["note_created"]}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.appText("Action",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: AppTheme.blackColor),
                          Row(
                            children: [
                              getColorContainer(
                                  hexColor: widget.listData["note_color"]),
                              const SizedBox(
                                width: 10,
                              ),
                              actionContainer(
                                  onTap: () {
                                    _showMyDialog();
                                  },
                                  icon: Icons.visibility,
                                  color: const Color(0xff1A0B8F)),
                              const SizedBox(
                                width: 10,
                              ),
                              actionContainer(
                                  onTap: () {
                                    push(context,
                                        EditToDo(data: widget.listData));
                                  },
                                  icon: Icons.edit,
                                  color: const Color(0xff1A0B8F)),
                            ],
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

  Widget getColorContainer({hexColor}) {
    Color color = Color(int.parse(hexColor.replaceFirst('#', '0xFF')));

    return Container(
      width: 25,
      height: 25,
      decoration: ShapeDecoration(
        color: color,
        shape: const OvalBorder(),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.appText(
                    "${widget.listData["note_subject"]}",
                    textColor: const Color(0xFF00BFA5),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 30,
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFD9D9D9),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 97,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1,
                  color: Color(0xFFD9D9D9),
                  
                )),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppText.appText("${widget.listData["note_content"]}"),
                ),
              )
            ],
          )),
        );
      },
    );
  }
}
