import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_field.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ToDoNotes/to_do_notes.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditToDo extends StatefulWidget {
  final data;
  const EditToDo({super.key, this.data});

  @override
  State<EditToDo> createState() => _EditToDoState();
}

class _EditToDoState extends State<EditToDo> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  Color? selectedColor; // Default color

  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;

  @override
  void initState() {
    dio = AppDio(context);
    _nameController.text = widget.data["note_subject"];
    _descController.text = widget.data["note_content"];
    convertHexColor(hexColor: widget.data["note_color"]);
    logger.init();
    super.initState();
  }

  void changeColor(Color color) {
    setState(() {
      print("bbfkrnfk$color");
      selectedColor = color;
    });
  }

  Color convertHexColor({hexColor}) {
    if (hexColor != null && hexColor.isNotEmpty) {
      if (hexColor.length == 7 && hexColor.startsWith('#')) {
        setState(() {
          selectedColor = Color(int.parse('0xff${hexColor.substring(1)}'));
        });
      }
    }
    // Return a default color if the input is invalid
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Add To Do Notes",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.appText("Subject Name *",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: const Color(0xff555555)),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                  height: 40,
                  width: screenWidth,
                  child: AppField(
                    textEditingController: _nameController,
                    borderRadius: BorderRadius.circular(5),
                    borderSideColor: const Color(0xffDDDDDD),
                    padding: const EdgeInsets.all(10),
                    hintText: "James Anderson",
                    hintTextColor: const Color.fromARGB(255, 164, 163, 163),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )),
              const SizedBox(
                height: 15,
              ),
              AppText.appText("Note Highlighter",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: const Color(0xff555555)),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Pick a color'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: selectedColor!,
                              onColorChanged: changeColor,
                              showLabel: true,
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Done'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Container(
                  height: 40,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xffDDDDDD),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 20,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: selectedColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: const Color(0xffDDDDDD),
                          )),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              AppText.appText("Description",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: const Color(0xff555555)),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: _descController,
                hintText: "Enter the Description",
                lines: 6,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton.appButton("Save", onTap: () {
                    updateToDo();
                  },
                      textColor: AppTheme.whiteColor,
                      backgroundColor: Color(0xff00BFA5),
                      height: 30,
                      width: 110),
                  const SizedBox(
                    width: 10,
                  ),
                  AppButton.appButton("Cancel", onTap: () {
                   
                    _nameController.text = widget.data["note_subject"];
                    _descController.text = widget.data["note_content"];
                    convertHexColor(hexColor: widget.data["note_color"]);
                  
                  },
                      textColor: AppTheme.whiteColor,
                      backgroundColor: Color(0xFFF32184),
                      height: 30,
                      width: 110),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateToDo() async {
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
      "note_id":widget.data["note_id"],
      "note_subject": _nameController.text,
      "note_content": _descController.text,
      "note_color": "#${selectedColor!.value.toRadixString(16).substring(2)}"
    };
    try {
      response = await dio.post(path: AppUrls.updateToDo, data: params);
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
            pushReplacement(context, ToDoNotesScreen());
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
