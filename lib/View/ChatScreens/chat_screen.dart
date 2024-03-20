import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ChatScreens/single_chat_screeen.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:active_link/config/keys/pref_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/app_logger.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  var finalResponse;
  var regId;
  var adminId;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getRegId();
    getChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("bbfkjbfbjlblk$regId");
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomBar(
        controller: _searchController,
        onNotificationTap: () {
          getSearchChat();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                push(
                    context,
                    PersonChatSreen(
                      id: adminId,
                      myId: regId,
                      name: "Admin",
                    ));
              },
              child: SizedBox(
                height: 70,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20),
                  child: Row(children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/admin.png"),
                          fit: BoxFit.fill,
                        ),
                        shape: OvalBorder(),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: const ShapeDecoration(
                                color: Color(0xFF28B604),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText.appText(
                          'Admin',
                          textColor: const Color(0xFF666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        AppText.appText(
                          '',
                          textColor: const Color(0xFF5C5C5C),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        )
                      ],
                    ),
                    Spacer(),
                  ]),
                ),
              ),
            ),
            finalResponse == null
                ? CircularProgressIndicator()
                : Container(
                    height: MediaQuery.of(context).size.height - 70,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: finalResponse.length,
                      itemBuilder: (context, index) {
                        return chatContainer(data: finalResponse[index]);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget chatContainer({data}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        push(
            context,
            PersonChatSreen(
              id: data["registration_id"],
              myId: regId,
              name: data["full_name"],
            ));
      },
      child: SizedBox(
        height: 70,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20),
          child: Row(children: [
            Container(
              width: 50,
              height: 50,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(data["image"] == ""
                      ? "https://via.placeholder.com/50x50"
                      : "https://portaltest.thebrandwings.com/${data["upload_path"]}/${data["image"]}"),
                  fit: BoxFit.fill,
                ),
                shape: OvalBorder(),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: const ShapeDecoration(
                        color: Color(0xFF28B604),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.appText(
                  '${data["full_name"]}',
                  textColor: const Color(0xFF666666),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(
                  height: 5,
                ),
                AppText.appText(
                  '',
                  textColor: const Color(0xFF5C5C5C),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void getSearchChat() async {
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
      "search_term": _searchController.text,
    };
    try {
      response = await dio.post(path: AppUrls.searchChats, data: params);
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

  void getChats() async {
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
        path: AppUrls.chats,
      );
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

  getRegId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      regId = prefs.get(PrefKey.regId);
      adminId = prefs.get(PrefKey.adminId);
      print("object$adminId");
    });
  }
}

class CustomBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight = 90.0;
  final controller;
  final Function() onNotificationTap;

  const CustomBar({required this.onNotificationTap, this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1.00, -0.07),
          end: Alignment(-1, 0.07),
          colors: [Color(0xA8CC60F2), Color(0xFFB854F2)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppTheme.whiteColor),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xffB563E4),
                  ),
                ),
              ),
            ),
            Container(
              width: screenWidth * 0.7,
              height: 40,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: TextField(
                controller: controller,
                onSubmitted: (value) {
                  if (onNotificationTap != null) {
                    onNotificationTap();
                  }
                },
                autofocus: false,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(7),
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search here...",
                    isDense: true,
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 1,
              width: 1,
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}
