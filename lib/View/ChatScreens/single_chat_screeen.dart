import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

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

  String _pickedFilePath = '';

  Future<void> pickDocument() async {
    final path = await FlutterDocumentPicker.openDocument(
        params: FlutterDocumentPickerParams(
            allowedFileExtensions: ['JPG'], invalidFileNameSymbols: ['/']));
            print("ndkfnenkfneknfnk$path");
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
    return Scaffold(
      appBar: CustomAppBar(
        title: "${widget.name}",
      ),
      body: GestureDetector(
        onTap: () {
          // Unfocus the text field when tapping anywhere else on the page
          FocusScope.of(context).unfocus();
        },
        child: Column(
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
                              message: finalResponse[index]["content"]);
                        } else {
                          return _buildMessageBubble(
                              user: false,
                              message: finalResponse[index]["content"]);
                        }
                      },
                    ),
                  ),
            // AppText.appText("$_pickedFilePath", textColor: Colors.amber),
            _buildUserInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble({user, message}) {
    return Container(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: user
              ? const Color.fromARGB(255, 196, 167, 212)
              : const Color(0xffEAEAEA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "$message",
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            // if (message.media != null) ...[
            //   for (var media in message.media!)
            //     Card(
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(15)),
            //       elevation: 5,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           ClipRRect(
            //               borderRadius: BorderRadius.circular(15),
            //               child: Image.network(media.image)),
            //           Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Column(
            //               children: [
            //                 Text(
            //                   media.title,
            //                   style: const TextStyle(
            //                       fontWeight: FontWeight.w700, fontSize: 16),
            //                 ),
            //                 const SizedBox(
            //                   height: 5,
            //                 ),
            //                 GestureDetector(
            //                     onTap: () async {},
            //                     child: Text(
            //                       media.link,
            //                       style: const TextStyle(
            //                           color:
            //                               Color.fromARGB(255, 108, 142, 170)),
            //                     )),
            //               ],
            //             ),
            //           ),
            //           const SizedBox(
            //             height: 5,
            //           )
            //         ],
            //       ),
            //     ),

            // ],
          ],
        ),
      ),
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
                if (userMessage.isNotEmpty) {
                  sendMessage();
                  _textEditingController.clear();
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
                  print("djjj4bj");
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

  void _selectFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        String? filePath = result.files.single.path;
        // Here, you can handle the selected file, such as sending it in the chat
        // You might want to implement your logic for sending the file
        // For demonstration, printing the file path
        print("Selected file path: $filePath");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
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

  void sendMessage() async {
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
      "mes": _textEditingController.text,
      "e_id": widget.id,
      "myId": widget.myId
    };

    try {
      response = await dio.post(path: AppUrls.sendMessage, data: params);
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
