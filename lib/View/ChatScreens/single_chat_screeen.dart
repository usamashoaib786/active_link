import 'dart:io';

import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ChatScreens/pic_view.dart';
import 'package:active_link/View/ProfileScreen/compilence.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class PersonChatSreen extends StatefulWidget {
  final id;
  final myId;
  final name;

  PersonChatSreen({super.key, this.id, this.myId, this.name});

  @override
  _PersonChatSreenState createState() => _PersonChatSreenState();
}

class _PersonChatSreenState extends State<PersonChatSreen> {
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  var finalResponse;

  String? _pickedFilePath;

  Future<void> pickDocument() async {
    final path = await FlutterDocumentPicker.openDocument(
        params: FlutterDocumentPickerParams(
            allowedFileExtensions: ['pdf', 'png', 'jpeg', 'txt', 'docx', 'jpg'],
            invalidFileNameSymbols: ['/']));
    if (path != null) {
      setState(() {
        _pickedFilePath = path;
        print("electedfilePath${_pickedFilePath}");
      });
    }
  }

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("k3 r3krn3r3 ${_pickedFilePath}");
    return Scaffold(
      appBar: CustomAppBar(
        title: "${widget.name}",
      ),
      body: GestureDetector(
        onTap: () {
          // Unfocus the text field when tapping anywhere else on the page
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Column(
              children: [
                finalResponse == null
                    ? Container(
                        height: MediaQuery.of(context).size.height - 170,
                        child: const Center(child: CircularProgressIndicator()))
                    : Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: finalResponse.length,
                          itemBuilder: (context, index) {
                            if (finalResponse[index]["chat_from_id"] ==
                                widget.myId) {
                              return _buildMessageBubble(
                                user: true,
                                message: finalResponse[index]["content"],
                                img: finalResponse[index]["attachment_name"],
                              );
                            } else {
                              return _buildMessageBubble(
                                  user: false,
                                  message: finalResponse[index]["content"],
                                  img: finalResponse[index]["attachment_name"]);
                            }
                          },
                        ),
                      ),
                _buildUserInput(),
              ],
            ),
            if (_pickedFilePath != null)
              Positioned(
                bottom: 70,
                right: 0,
                left: 0,
                child: Card(
                  elevation: 20,
                  child: Container(
                    color: Colors.amber,
                    height: 200,
                    width: 200,
                    child: _buildSelectedImage(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble({user, message, img}) {
    return Column(
      children: [
        Container(
            alignment: user ? Alignment.centerRight : Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: message != ""
                ? Container(
                    constraints:
                        const BoxConstraints(maxWidth: 250, minWidth: 80),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: user
                          ? const Color.fromARGB(255, 196, 167, 212)
                          : const Color(0xffEAEAEA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$message",
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                : img != ""
                    ? Card(
                        elevation: 10,
                        child: GestureDetector(
                           onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FullSizeImageUrlScreen(
                                  imageUrl:
                                      "https://portaltest.thebrandwings.com//upload/attachment/$img",
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 170,
                            width: 170,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "https://portaltest.thebrandwings.com//upload/attachment/$img",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink()),
      ],
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: const Color(0xffECECEC),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.68,
              child: TextField(
                autofocus: false,
                controller: _textEditingController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Message ...',
                ),
              ),
            ),
            InkWell(
              onTap: () {
                final userMessage = _textEditingController.text;
                if (userMessage.isNotEmpty || _pickedFilePath != null) {
                  sendMessage(message: _textEditingController.text);
                  _textEditingController.clear();
                  _pickedFilePath = null;
                }
              },
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset(
                    "assets/images/image 9.png",
                    fit: BoxFit.cover,
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () {
                  pickDocument();
                },
                child: const Icon(
                  Icons.attachment,
                  size: 30,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImage() {
    return _pickedFilePath != null
        ? Image.file(
            File(_pickedFilePath!),
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          )
        : Container(); // Or any default placeholder widget
  }

  void getChat() async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For success ful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.

    Map<String, dynamic> params = {
      "id": widget.id,
      "myId": widget.myId,
    };

    try {
      response =
          await dio.post(path: AppUrls.getSinglePersonChat, data: params);
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
            finalResponse = responseData["contacts"];

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

  void sendMessage({message}) async {
    setState(() {
      _isLoading = true;
    });
    print("object${message}");
    var response;
    int responseCode200 = 200; // For success ful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    String fileName =
        _pickedFilePath == null ? "" : _pickedFilePath!.split('/').last;
    FormData formData = FormData.fromMap({
      "mes": "$message",
      "e_id": widget.id,
      "myId": widget.myId,
      "attachmentfile": _pickedFilePath == null
          ? ""
          : await MultipartFile.fromFile(_pickedFilePath!, filename: fileName),
    });

    try {
      response = await dio.post(path: AppUrls.sendMessage, data: formData);
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
            getChat();
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
