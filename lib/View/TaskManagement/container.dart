import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/TaskManagement/task_details.dart';
import 'package:flutter/material.dart';

class TaskContainer extends StatefulWidget {
  final data;
  const TaskContainer({super.key, this.data});

  @override
  State<TaskContainer> createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
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
                height: 176,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customRow(
                        text1: "Task name ",
                        text2: "${widget.data["task_name"]}",
                      ),
                      customRow(
                          text1: "Client name ",
                          text2:
                              "${widget.data["f_name"]} ${widget.data["l_name"]}"),
                      customRow(
                          text1: "Assigned ",
                          text2: "${widget.data["createdd"]}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.appText("Status",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: AppTheme.blackColor),
                          AppButton.appButton(
                              widget.data['task_status'] != '0'
                                  ? "Active"
                                  : "Completed",
                              height: 20,
                              textColor: Colors.white,
                              width: widget.data["task_status"] != 0 ? 90 : 80,
                              backgroundColor: const Color(0xff00BFA5))
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
                              push(
                                  context,
                                  TaskDetailsScreen(
                                      taskId: widget.data["task_id"],
                                      completed:
                                          widget.data["task_status"] == '0'
                                              ? true
                                              : false));
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
                                  color: const Color(0xff1A0B8F),
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
            textColor: AppTheme.blackColor),
      ],
    );
  }
}
