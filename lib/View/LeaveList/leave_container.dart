import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:flutter/material.dart';

class LeaveContainer extends StatefulWidget {
  final leaveData;
  final staffName;
  const LeaveContainer({
    super.key,
    this.leaveData,
    this.staffName,
  });

  @override
  State<LeaveContainer> createState() => _LeaveContainerState();
}

class _LeaveContainerState extends State<LeaveContainer> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, top: 10),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            child: Container(
                height: 220,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customRow(
                        text1: "Staff Id",
                        text2: "${widget.leaveData["staff_id"]}",
                      ),
                      customRow(
                          text1: "Staff Name ", text2: "${widget.staffName}"),
                      customRow(
                          text1: "Leave Type ",
                          text2: "${widget.leaveData["leave_type"]}"),
                      customRow(
                          text1: "Start Date ",
                          text2: "${widget.leaveData["leave_start"]}"),
                      customRow(
                          text1: "End Date ",
                          text2: "${widget.leaveData["leave_end"]}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.appText("Status",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: AppTheme.blackColor),
                          AppButton.appButton(
                              "${widget.leaveData["leave_status"]}",
                              height: 21,
                              width: 80,
                              textColor: AppTheme.whiteColor,
                              backgroundColor:
                                  widget.leaveData["leave_status"] == "pending"
                                      ? const Color(0xFF7F21F3)
                                      : const Color(0xff00BFA5))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.appText("Action",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: AppTheme.blackColor),
                          GestureDetector(
                            onTap: () {
                              _showMyDialog();
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(100),
                                  border: Border.all(
                                      width: 1,
                                      color: const Color(0xFF7F21F3))),
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
                      )
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
            textColor: Color(0xFF666666)),
      ],
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SingleChildScrollView(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.appText(
                    "${widget.leaveData["leave_type"]}",
                    textColor: Colors.black,
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
              AppText.appText(
                'Start Date To End Date: ${widget.leaveData["leave_start"]} - ${widget.leaveData["leave_end"]}',
                textColor: Color(0xFF5C5C5C),
                fontSize: 10,
                fontWeight: FontWeight.w400,
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
                  child:
                      AppText.appText("${widget.leaveData["leave_content"]}"),
                ),
              )
            ],
          )),
        );
      },
    );
  }
}
