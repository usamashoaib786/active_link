import 'dart:isolate';
import 'dart:ui';

import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ProfileScreen/compilence.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ClientSummary extends StatefulWidget {
  final id;
  const ClientSummary({super.key, this.id});

  @override
  State<ClientSummary> createState() => _ClientSummaryState();
}

class _ClientSummaryState extends State<ClientSummary> {
  bool personal = false;
  bool aboutMe = false;
  bool contact = false;
  bool medical = false;
  bool placement = false;
  bool personalCare = false;
  bool restricted = false;
  bool documents = false;
  bool profile = true;
  bool livingArrangement = false;
  bool programs = false;
  bool practise = false;
  bool bench = false;
  bool docs = false;
  bool grooming = false;
  bool bedtime = false;
  bool behaviour = false;
  bool communication = false;
  bool eat = false;
  bool menstruation = false;
  bool community = false;
  bool moblity = false;
  var staffDetail;
  var criticalMedical;
  var clientPlacementHistory;
  var bathingNotesApi;
  var bedTimeNotesApi;
  var behaviourNotesApi;
  var documentResponse;
  late AppDio dio;
  AppLogger logger = AppLogger();
  String? selectedGender;
  List<String?> _answers = List.filled(7, null);
  List<String?> _goomingAnswers = List.filled(10, null);
  List<String?> _bedTimeAnswers = List.filled(11, null);
  List<String?> _supportAnswers = List.filled(13, null);
  List<String?> _communityAnswers = List.filled(18, null);
  List<String?> _eatDrinkAnswers = List.filled(11, null);
  List<String?> _mobilityAnswers = List.filled(5, null);
  List<String?> _diagnosisAnswers = List.filled(2, null);
  var clientData;
  String? com;
  String? mens;
  var communicationNotesApi;
  var communityNotesApi;
  var eatNotesApi;
  var mobilityNotesApi;
  var restrictedPractice;
  List mobilityList = [
    "Difficulty moving on Uneven or Rough Ground (Assess Risk)",
    "Hearing or Vision Impaired (Assess Risk)",
    "Other Mobility or Movement Issues (Assess Risk)",
    "Special Aids Required (e.g. Glasses, Helmets, Orthodontics, Other Splints, Walking Frame, Wheelchair etc.) (Assess Risk)",
    "Travelling in a Vehicle (special seating required) (Assess Risk)",
  ];

  List diagnosisList = [
    "Diagnosed by a qualified profexxional as having any diabilties",
    "Requires Management Plan",
  ];
  List placementList = [
    "Is there a placement agreement?",
    "Entry him to voluntery care",
    "Is the person self placed?",
    "Placement is culturally compatible",
    "Aboriginal and torres straight islander placement principle applied",
    "Is this move planned or unplanned?",
    "Is the person leaving care period with your agency?",
    "Person reffered to any other service",
    "Document completed to support move?"
  ];
  List eatDrinkList = [
    "Dislikes - Food and Drink",
    "Likes - Food and Drink",
    "Assistance with Eating or Drinking",
    "Cultural or Religious Food Practices",
    "Encouragement to Eat",
    "Food Allergies / Adverse Reactions",
    "Meals Served",
    "Nutrition Plan",
    "Special Aids for Eating or Drinking",
    "Special Diet Requirements",
    "Tube Feeding Required (Management Plan required)",
  ];

  List bedTimeList = [
    "Continence Aids to Bed",
    "Indicates when wants to go to bed",
    "Problems sleeping away from normal residence",
    "Sleeps with Bedroom Door Closed",
    "Sleeps with Light On",
    "Sleeps in a Single Room",
    "Special Sleeping Needs (e.g. two pillows etc.)",
    "Re-positioned during night",
    "Sleep through the night",
    "Usual Bedtime Routine",
    "Other (Specify)",
  ];
  List supportList = [
    "Absconding / Wandering(Assess Risk)",
    "Abusive Language / Swearing(Assess Risk)",
    "Aggression(Assess Risk)",
    "Crying / Screaming / Other Noisy Behaviours (Assess Risk)",
    "Eating Non Edible Substance",
    "Non Compliance(Assess Risk)",
    "Property Damage(Assess Risk)",
    "Obsessive / Repetitive(Assess Risk)",
    "Self-Injuries(Assess Risk)",
    "Self Stimulatory Behaviour(thumb sucking, rocking etc.) (Assess Risk)",
    "Other Behaviours(Assess Risk)",
    "How are these Behaviours Managed?",
    "Behaviour Support Plan",
  ];
  List communityList = [
    "Additional Resources or Supports Required",
    "Attend School / Vocation",
    "Fears or Phobias (e.g. Escalator/ Lifts etc.)",
    "No Participation due to Medical Reasons",
    "Public Transport with Support Staff",
    "Preferred Seating Requirements",
    "Recommended Maximum Travel Time",
    "Require Activities whilst Travelling (e.g. Books, Music etc.)",
    "Road Safety - is the Client Aware?",
    "Small Groups with Support Staff",
    "Travel Sickness",
    "Remains Seated Whilst Travelling",
    "Removes Seatbelt Whilst Travelling",
    "Swimming/Water Sports Incontinence",
    "Swimming/Water Sports Independnt/Support Required",
    "Swimming/Water Sports Participation",
    "Swimming/Water Sports Specialised Equipment",
    "Swimming/Water Sports Wheelchair Access",
  ];
  List bathGrooming = [
    "Assistance - Clean Teeth",
    "Assistance - Fill a bath or run a shower",
    "Assistance - Shaving",
    "Assistance - Washing Hair",
    "Assistance - Washing Hands",
    "Dress by themself",
    "Hot Water Awareness (Assess Risk)",
    "Manage Buttons, Zippers etc. by self",
    "Special Bath Oil, Shampoo, Soap",
    "Supervision Required Whilst Bathing",
  ];

  int currentIndex = 0;
  int currentIndex1 = 0;
  int currentIndex2 = 0;
  int currentIndex3 = 0;

  PageController pageController = PageController(initialPage: 0);
  PageController pageController1 = PageController(initialPage: 0);
  PageController pageController2 = PageController(initialPage: 0);
  PageController pageController3 = PageController(initialPage: 0);

  List medicalQuest = [
    "Allergies and Adverse Reactions",
    "Asthma",
    "Diabetes",
    "EPI pen",
    "Medicaion taken",
    "Seizures",
    "other",
  ];
  List communicationWrapList = [
    "Compic",
    "Computer",
    "Facial Expression",
    "Gestures",
    "Non Verbal",
    "Pictures",
    "Signs",
    "Speech",
    "Vocalisation",
    "other",
  ];
  List eatWrapList = [
    "Bowl",
    "Cur out cup",
    "Fingers",
    "Fork",
    "Plastic Spoon Only",
    "Plate",
    "Spoon",
    "Straw/Cup",
    "other(Specify)",
  ];
  List mobilityWrapList = [
    "Fully Mobile",
    "Need Assistant to walk",
    "Use Other Aids",
    "Use Wheelchair for Mobility",
    "Slight Physical Disability",
  ];
  List communicationList = [
    "Happiness",
    "Hunger",
    "Pain - how is this indicated",
    "Reading",
    "Sadness",
    "Staying Away from Home (previous reactions ie. in other Respite or Temporary Care)",
    "Telephone Usage",
    "Thirst",
    "Toileting",
    "Writing"
  ];
  List programsList = [
    "Community Access/ Participation",
    "Day Program",
    "Disabilty",
    "Home Care",
    "Kinship care",
    "Out of Home care - Foster",
    "Out of Home care - Residential",
    "Residential - Family or Relatives",
    "Residential - Group Home",
    "Respit Care",
    "Other (Specify)",
  ];
  List bath = ["Bath", "shower", "Sponge Bath"];
  List medicalNotesApi = [];
  bool _isLoading = false;
  var finalResponse;
  int? age;
  List placementWrapList = [
    "Drop in Suport",
    "Family Group Home",
    "Foster Care",
    "Lives Alone",
    "Lives with Family",
    "Lives with Others",
    "Therapeutic Residential Care",
    "Refuge Care",
    "Kinship/ Realtive Care",
    "Residential Care - Group Home",
    "Residential Care Other",
    "Respite Care",
    "Semi Independent",
    "other"
  ];
  List placementWrapList1 = [
    "Adolescent Support",
    "Advocacy",
    "Day Services",
    "Family",
    "Family Support",
    "Respite",
    "Restoration",
    "Therapeutic Support",
    "None",
    "other"
  ];
  double _progress = 0.0;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getClientSummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: "Client Summary",
        img: "assets/images/plus.png",
        trailing: true,
        onTap: () {
          showNotificationPopup();
        },
      ),
      body: finalResponse == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: finalResponse["profile_pic"] == ""
                          ? Image.asset("assets/images/user.png",
                              fit: BoxFit.cover)
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                                "https://portaltest.thebrandwings.com/upload/${finalResponse["folder"]}/${finalResponse["profile_pic"]}",
                                fit: BoxFit.fill),
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppText.appText(
                        "${finalResponse["f_name"]} ${finalResponse["l_name"]}",
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                    const SizedBox(
                      height: 5,
                    ),
                    AppText.appText(
                        "${finalResponse["gender"]}: $age years old",
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: const Border(
                              top: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 215, 203, 203)))),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 30),
                          child: placement == true
                              ? placementColumn()
                              : personalCare == true
                                  ? personalCareColumn()
                                  : restricted == true
                                      ? restrictedColumn()
                                      : documents == true
                                          ? documentColumn()
                                          : profileColumn()),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget personalCareColumn() {
    return Column(
      children: [
        customRow(
            txt: "Bathing and Grooming",
            icon: grooming == true ? false : true,
            onTap: () {
              setState(() {
                grooming = !grooming;
                bedtime = false;
                behaviour = false;
                communication = false;
                eat = false;
                menstruation = false;
                community = false;
                moblity = false;
              });
            },
            color: grooming == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: grooming, child: groomingContainer()),
        customRow(
            txt: "Bedtime Routine",
            icon: bedtime == true ? false : true,
            onTap: () {
              setState(() {
                grooming = false;
                behaviour = false;
                communication = false;
                eat = false;
                menstruation = false;
                community = false;
                moblity = false;
                bedtime = !bedtime;
              });
            },
            color: bedtime == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: bedtime, child: bedTimeConatiner()),
        customRow(
            txt: "Behaviour Support",
            icon: behaviour == true ? false : true,
            onTap: () {
              setState(() {
                grooming = false;
                bedtime = false;

                communication = false;
                eat = false;
                menstruation = false;
                community = false;
                moblity = false;
                behaviour = !behaviour;
              });
            },
            color: behaviour == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: behaviour, child: supportContainer()),
        customRow(
            txt: "Communication",
            icon: communication == true ? false : true,
            onTap: () {
              setState(() {
                grooming = false;
                bedtime = false;
                behaviour = false;

                eat = false;
                menstruation = false;
                community = false;
                moblity = false;
                communication = !communication;
              });
            },
            color: communication == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: communication, child: communicationContainer()),
        customRow(
            txt: "Community Access",
            icon: community == true ? false : true,
            onTap: () {
              setState(() {
                grooming = false;
                bedtime = false;
                behaviour = false;
                communication = false;
                eat = false;
                menstruation = false;
                moblity = false;
                community = !community;
              });
            },
            color: community == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: community, child: communityConatiner()),
        customRow(
            txt: "Eating, Drinking and Mealtimes",
            icon: eat == true ? false : true,
            onTap: () {
              setState(() {
                grooming = false;
                bedtime = false;
                behaviour = false;
                communication = false;

                menstruation = false;
                community = false;
                moblity = false;
                eat = !eat;
              });
            },
            color: eat == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: eat, child: eatDrinkContainer()),
        customRow(
            txt: "Menstruation",
            icon: menstruation == true ? false : true,
            onTap: () {
              setState(() {
                grooming = false;
                bedtime = false;
                behaviour = false;
                communication = false;
                eat = false;

                community = false;
                moblity = false;
                menstruation = !menstruation;
              });
            },
            color: menstruation == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: menstruation, child: menstruationContainer()),
        customRow(
            txt: "Mobility and Movement",
            icon: moblity == true ? false : true,
            onTap: () {
              setState(() {
                grooming = false;
                bedtime = false;
                behaviour = false;
                communication = false;
                eat = false;
                menstruation = false;
                community = false;
                moblity = !moblity;
              });
            },
            color: moblity == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: moblity, child: mobilityContainer()),
      ],
    );
  }
  /////////////////////////////////////////////////        Personal Care Columns        ////////////////////////////////////////////////////////////////////////////////////

  Widget groomingContainer() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: bathGrooming.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 6)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText(
                        'Bath or Shower Preference',
                        textColor: const Color(0xff5C5C5C),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          for (int i = 0; i < bath.length; i++)
                            IntrinsicWidth(
                              child: Row(children: [
                                _buildIconOrContainer1(
                                  value: i == 0
                                      ? finalResponse["Shower_Preference_Bath"]
                                      : i == 1
                                          ? finalResponse[
                                              "Shower_Preference_Shower"]
                                          : i == 2
                                              ? finalResponse[
                                                  "Shower_Preference_Sponge"]
                                              : "",
                                  icon: Icons.done,
                                ),
                                const SizedBox(width: 10),
                                AppText.appText("${bath[i]}"),
                              ]),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                if (index == 9)
                  customColumn(
                      txt1: "Normal Bathing Time",
                      txt2: "${finalResponse["Bathing_Time"]}",
                      width: MediaQuery.of(context).size.width),
                AppText.appText(
                  '${bathGrooming[index]}',
                  textColor: const Color(0xff5C5C5C),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "Yes",
                      groupValue: _goomingAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("Yes", textColor: const Color(0xff5C5C5C)),
                    Radio<String>(
                      value: "No", // No = 0
                      groupValue: _goomingAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("No", textColor: const Color(0xff5C5C5C)),
                  ],
                ),
                const SizedBox(height: 20),
                customColumn(
                    txt1: "${bathGrooming[index]} Notes",
                    txt2: "${bathingNotesApi[index]}",
                    width: MediaQuery.of(context).size.width),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget bedTimeConatiner() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: bedTimeList.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.appText(
                  '${bedTimeList[index]}',
                  textColor: const Color(0xff5C5C5C),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "Yes",
                      groupValue: _bedTimeAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("Yes", textColor: const Color(0xff5C5C5C)),
                    Radio<String>(
                      value: "No", // No = 0
                      groupValue: _bedTimeAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("No", textColor: const Color(0xff5C5C5C)),
                  ],
                ),
                const SizedBox(height: 20),
                customColumn(
                    txt1: "${bedTimeList[index]} Notes",
                    txt2: "${bedTimeNotesApi[index]}",
                    width: MediaQuery.of(context).size.width),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget supportContainer() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: supportList.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.appText(
                  '${supportList[index]}',
                  textColor: const Color(0xff5C5C5C),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "Yes",
                      groupValue: _supportAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("Yes", textColor: const Color(0xff5C5C5C)),
                    Radio<String>(
                      value: "No", // No = 0
                      groupValue: _supportAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("No", textColor: const Color(0xff5C5C5C)),
                  ],
                ),
                const SizedBox(height: 20),
                customColumn(
                    txt1: "${supportList[index]} Notes",
                    txt2: "${behaviourNotesApi[index]}",
                    width: MediaQuery.of(context).size.width),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
        customColumn(
            txt1: "Behaviour Support Plan Approved Date",
            txt2: "${finalResponse["Plan_Approved_Date"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Behaviour Support Plan Review Date 1",
            txt2: "${finalResponse["Plan_Review_Date_1"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Behaviour Support Plan Review Date 2",
            txt2: "${finalResponse["Plan_Review_Date_2"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Behaviour Support Plan Review Date 3",
            txt2: "${finalResponse["Plan_Review_Date_3"]}",
            width: MediaQuery.of(context).size.width),
      ],
    );
  }

  Widget communicationContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        AppText.appText("Please Describe how the client Communicates"),
        const SizedBox(height: 10),
        customColumn(
            txt1: "Anger",
            txt2: "${finalResponse["Anger_note"]}",
            width: MediaQuery.of(context).size.width),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.appText(
              'Bath or Shower Preference',
              textColor: const Color(0xff5C5C5C),
            ),
            const SizedBox(height: 20),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              runSpacing: 10,
              spacing: 10,
              children: [
                for (int i = 0; i < communicationWrapList.length; i++)
                  IntrinsicWidth(
                    child: Row(children: [
                      _buildIconOrContainer1(
                        value: i == 0
                            ? finalResponse["Compic_Method"]
                            : i == 1
                                ? finalResponse["Computer_Method"]
                                : i == 2
                                    ? finalResponse["Facial_Expression_Method"]
                                    : i == 3
                                        ? finalResponse["Gestures_Method"]
                                        : i == 4
                                            ? finalResponse["Non_Verbal_Method"]
                                            : i == 5
                                                ? finalResponse[
                                                    "Pictures_Method"]
                                                : i == 6
                                                    ? finalResponse[
                                                        "Signs_Method"]
                                                    : i == 7
                                                        ? finalResponse[
                                                            "Speech_Method"]
                                                        : i == 8
                                                            ? finalResponse[
                                                                "Vocalisation_Method"]
                                                            : i == 9
                                                                ? finalResponse[
                                                                    "Other_Method"]
                                                                : "",
                        icon: Icons.done,
                      ),
                      const SizedBox(width: 10),
                      AppText.appText("${communicationWrapList[i]}"),
                    ]),
                  ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
        customColumn(
            txt1: "Note",
            txt2: "${finalResponse["communicates_note"]}",
            width: MediaQuery.of(context).size.width),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppText.appText(
            'Communications Plan Available',
            textColor: const Color(0xff5C5C5C),
          ),
          Row(
            children: [
              Radio<String>(
                value: "2",
                groupValue: com,
                onChanged: (String? value) {},
              ),
              AppText.appText("Yes", textColor: const Color(0xff5C5C5C)),
              Radio<String>(
                value: "0", // No = 0
                groupValue: com,
                onChanged: (String? value) {},
              ),
              AppText.appText("No", textColor: const Color(0xff5C5C5C)),
            ],
          ),
        ]),
        for (int j = 0; j < communicationList.length; j++)
          customColumn(
              txt1: "${communicationList[j]}",
              txt2: "${communicationNotesApi[j]}",
              width: MediaQuery.of(context).size.width),
      ],
    );
  }

  Widget communityConatiner() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        customColumn(
            txt1: "Likes",
            txt2: "${finalResponse["Likes"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Dislikes",
            txt2: "${finalResponse["Dislikes"]}",
            width: MediaQuery.of(context).size.width),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: communityList.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.appText(
                  '${communityList[index]}',
                  textColor: const Color(0xff5C5C5C),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "Yes",
                      groupValue: _communityAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("Yes", textColor: const Color(0xff5C5C5C)),
                    Radio<String>(
                      value: "No", // No = 0
                      groupValue: _communityAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("No", textColor: const Color(0xff5C5C5C)),
                  ],
                ),
                const SizedBox(height: 20),
                customColumn(
                    txt1: "Notes",
                    txt2: "${communityNotesApi[index]}",
                    width: MediaQuery.of(context).size.width),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget eatDrinkContainer() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        customColumn(
            txt1: "Breakfast (Usual Time)",
            txt2: "${finalResponse["Breakfast_Time"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Morning Tea (Usual Time)",
            txt2: "${finalResponse["Morning_Tea_Time"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Lunch (Usual Time)",
            txt2: "${finalResponse["Lunch_Time"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Afternoon Tea (Usual Time)",
            txt2: "${finalResponse["Afternoon_Tea_Time"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Dinner (Usual Time)",
            txt2: "${finalResponse["Dinner_Time"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Supper (Usual Time)",
            txt2: "${finalResponse["Supper_Time"]}",
            width: MediaQuery.of(context).size.width),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: eatDrinkList.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.appText(
                  '${eatDrinkList[index]}',
                  textColor: const Color(0xff5C5C5C),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "Yes",
                      groupValue: _eatDrinkAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("Yes", textColor: const Color(0xff5C5C5C)),
                    Radio<String>(
                      value: "No", // No = 0
                      groupValue: _eatDrinkAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("No", textColor: const Color(0xff5C5C5C)),
                  ],
                ),
                const SizedBox(height: 20),
                customColumn(
                    txt1: "Notes",
                    txt2: "${eatNotesApi[index]}",
                    width: MediaQuery.of(context).size.width),
                const SizedBox(
                  height: 10,
                ),
                if (index == eatDrinkList.length - 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText(
                        'Utensils Used',
                        textColor: const Color(0xff5C5C5C),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          for (int i = 0; i < eatWrapList.length; i++)
                            IntrinsicWidth(
                              child: Row(children: [
                                _buildIconOrContainer1(
                                  value: i == 0
                                      ? finalResponse["Utensils_Used_Bowl"]
                                      : i == 1
                                          ? finalResponse["Utensils_Used_cup"]
                                          : i == 2
                                              ? finalResponse[
                                                  "Utensils_Used_Fingers"]
                                              : i == 3
                                                  ? finalResponse[
                                                      "Utensils_Used_Fork"]
                                                  : i == 4
                                                      ? finalResponse[
                                                          "Utensils_Used_Plastic_Spoon"]
                                                      : i == 5
                                                          ? finalResponse[
                                                              "Utensils_Used_Plate"]
                                                          : i == 6
                                                              ? finalResponse[
                                                                  "Utensils_Used_Spoon"]
                                                              : i == 7
                                                                  ? finalResponse[
                                                                      "Utensils_Used_Straw"]
                                                                  : i == 8
                                                                      ? finalResponse[
                                                                          "Utensils_Used_Other"]
                                                                      : "",
                                  icon: Icons.done,
                                ),
                                const SizedBox(width: 10),
                                AppText.appText("${eatWrapList[i]}"),
                              ]),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      customColumn(
                          txt1: "Notes",
                          txt2: "${finalResponse["Utensils_Used_note"]}",
                          width: MediaQuery.of(context).size.width),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget menstruationContainer() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppText.appText(
            'Assistance Required',
            textColor: const Color(0xff5C5C5C),
          ),
          Row(
            children: [
              Radio<String>(
                value: "Yes",
                groupValue: mens,
                onChanged: (String? value) {},
              ),
              AppText.appText("Yes", textColor: const Color(0xff5C5C5C)),
              Radio<String>(
                value: "No", // No = 0
                groupValue: mens,
                onChanged: (String? value) {},
              ),
              AppText.appText("No", textColor: const Color(0xff5C5C5C)),
            ],
          ),
        ]),
        customColumn(
            txt1: "Notes",
            txt2: "${finalResponse["Menstruation_Assistance_note"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Duration of Menses (day)",
            txt2: "${finalResponse["Duration_of_Menses"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Sanitary Products Used",
            txt2: "${finalResponse["Sanitary_Products_Used"]}",
            width: MediaQuery.of(context).size.width),
      ],
    );
  }

  Widget mobilityContainer() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: mobilityList.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 3)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText(
                        'Mobility Level (Assess Risk)',
                        textColor: const Color(0xff5C5C5C),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          for (int i = 0; i < mobilityWrapList.length; i++)
                            IntrinsicWidth(
                              child: Row(children: [
                                _buildIconOrContainer1(
                                  value: i == 0
                                      ? finalResponse["Fully_Mobile"]
                                      : i == 1
                                          ? finalResponse[
                                              "Needs_Assistance_to_Walk"]
                                          : i == 2
                                              ? finalResponse["Uses_Other_Aids"]
                                              : i == 3
                                                  ? finalResponse[
                                                      "Uses_Wheelchair_for_Mobility"]
                                                  : i == 4
                                                      ? finalResponse[
                                                          "Slight_Physical_Disability"]
                                                      : "",
                                  icon: Icons.done,
                                ),
                                const SizedBox(width: 10),
                                AppText.appText("${mobilityWrapList[i]}"),
                              ]),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                AppText.appText(
                  '${mobilityList[index]}',
                  textColor: const Color(0xff5C5C5C),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "Yes",
                      groupValue: _mobilityAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("Yes", textColor: const Color(0xff5C5C5C)),
                    Radio<String>(
                      value: "No", // No = 0
                      groupValue: _mobilityAnswers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("No", textColor: const Color(0xff5C5C5C)),
                  ],
                ),
                const SizedBox(height: 20),
                customColumn(
                    txt1: "Notes",
                    txt2: "${mobilityNotesApi[index]}",
                    width: MediaQuery.of(context).size.width),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget restrictedColumn() {
    return Column(
      children: [
        customRow(
            txt: "Practice",
            icon: practise == true ? false : true,
            onTap: () {
              setState(() {
                practise = !practise;
              });
            },
            color: practise == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: practise, child: practiceColumn()),
      ],
    );
  }

  Widget practiceColumn() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (currentIndex2 > 0) {
                  pageController2.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.black)),
                child: const Center(
                    child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                )),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                if (currentIndex2 < restrictedPractice.length - 1) {
                  pageController2.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.black)),
                child: const Center(
                    child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                )),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 270,
          child: PageView.builder(
            controller: pageController2,
            itemCount: restrictedPractice.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return containerPractise(data: restrictedPractice[index]);
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget documentColumn() {
    return Column(
      children: [
        customRow(
            txt: "Documents",
            icon: docs == true ? false : true,
            onTap: () {
              setState(() {
                docs = !docs;
                programs = false;
              });
            },
            color: docs == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: docs, child: documentDetail()),
      ],
    );
  }

  Widget documentDetail() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (currentIndex3 > 0) {
                  pageController3.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.black)),
                child: const Center(
                    child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                )),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                if (currentIndex3 < documentResponse.length - 1) {
                  pageController3.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.black)),
                child: const Center(
                    child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                )),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: pageController3,
            itemCount: documentResponse.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex3 = index;
              });
            },
            itemBuilder: (context, index) {
              return containerDocuments(data: documentResponse[index]);
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget placementColumn() {
    return Column(
      children: [
        customRow(
            txt: "Living Arrangements / Placement History",
            icon: livingArrangement == true ? false : true,
            onTap: () {
              setState(() {
                livingArrangement = !livingArrangement;
                programs = false;
              });
            },
            color: livingArrangement == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(
            visible: livingArrangement, child: livingArrangmentContainer()),
        customRow(
            txt: "Programs",
            icon: programs == true ? false : true,
            onTap: () {
              setState(() {
                livingArrangement = false;
                programs = !programs;
              });
            },
            color: programs == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: programs, child: programContainer()),
      ],
    );
  }

  Widget profileColumn() {
    return Column(
      children: [
        customRow(
            txt: "Personal Details",
            icon: personal == true ? false : true,
            onTap: () {
              setState(() {
                personal = !personal;
                medical = false;
                aboutMe = false;
                contact = false;
              });
            },
            color: personal == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: personal, child: personalDetail()),
        customRow(
            txt: "Critical Medical Information",
            icon: medical == true ? false : true,
            onTap: () {
              setState(() {
                aboutMe = false;
                personal = false;
                contact = false;
                medical = !medical;
              });
            },
            color: medical == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: medical, child: medicalDetail()),
        customRow(
            txt: "About Me",
            icon: aboutMe == true ? false : true,
            onTap: () {
              setState(() {
                aboutMe = !aboutMe;
                personal = false;
                medical = false;
                contact = false;
              });
            },
            color: aboutMe == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: aboutMe, child: aboutMeContainer()),
        customRow(
            txt: "My Contact Details",
            icon: contact == true ? false : true,
            onTap: () {
              setState(() {
                aboutMe = false;
                personal = false;
                contact = !contact;
                medical = false;
              });
            },
            color: contact == false
                ? const Color(0xff5C5C5C)
                : const Color(0xff0419D2)),
        Visibility(visible: contact, child: contactDetail()),
      ],
    );
  }

  Widget customRow({txt, onTap, color, icon}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.appText("$txt",
                fontSize: 14, fontWeight: FontWeight.w400, textColor: color),
            GestureDetector(
                onTap: onTap,
                child: icon == true
                    ? const Icon(Icons.add)
                    : const Icon(Icons.remove))
          ],
        ),
        const SizedBox(height: 15)
      ],
    );
  }

  Widget contactDetail({txt, controller}) {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        customColumn(
            txt1: "Address",
            txt2: "${finalResponse["address"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Contact Number",
            txt2: "${finalResponse["Contact_Number"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Email",
            txt2: "${finalResponse["Email"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Mobile Number",
            txt2: "${finalResponse["Mobile_Number"]}",
            width: MediaQuery.of(context).size.width),
        customColumn(
            txt1: "Fax Number",
            txt2: "${finalResponse["Fax_Number"]}",
            width: MediaQuery.of(context).size.width),
      ],
    );
  }

  void showNotificationPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: SizedBox(
                    height: 355,
                    width: 250,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                                placement = false;
                                personalCare = false;
                                restricted = false;
                                documents = false;
                              });
                            },
                            child: popUpColumn(txt: "Profile")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                                personalCare = false;
                                placement = true;
                                restricted = false;
                                documents = false;
                              });
                            },
                            child: popUpColumn(txt: "Placement / Programs")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                                placement = false;
                                personalCare = true;
                                restricted = false;
                                documents = false;
                              });
                            },
                            child: popUpColumn(txt: "Personal Care")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                restricted = true;
                                placement = false;
                                personalCare = false;
                                documents = false;
                                Navigator.pop(context);
                              });
                            },
                            child: popUpColumn(txt: "Restricted Practices")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                restricted = false;
                                placement = false;
                                personalCare = false;
                                documents = true;
                                Navigator.pop(context);
                              });
                            },
                            child: popUpColumn(txt: "Documents")),
                      ],
                    ))),
          ),
        );
      },
    );
  }

  Widget livingArrangmentContainer() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (currentIndex1 > 0) {
                  pageController1.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.black)),
                child: const Center(
                    child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                )),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                if (currentIndex1 < clientPlacementHistory.length - 1) {
                  pageController1.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.black)),
                child: const Center(
                    child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                )),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: pageController1,
            itemCount: clientPlacementHistory.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return containerPlacement(data: clientPlacementHistory[index]);
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget programContainer() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        customColumn(
            txt1: "Client Program",
            width: MediaQuery.of(context).size.width,
            txt2: "${clientData["Client_Program"]}"),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          runSpacing: 10,
          spacing: 10,
          children: [
            for (int i = 0; i < programsList.length; i++)
              IntrinsicWidth(
                child: Row(children: [
                  _buildIconOrContainer1(
                    value: i == 0
                        ? finalResponse["program1"]
                        : i == 1
                            ? finalResponse["program2"]
                            : i == 2
                                ? finalResponse["program3"]
                                : i == 3
                                    ? finalResponse["program4"]
                                    : i == 4
                                        ? finalResponse["program5"]
                                        : i == 5
                                            ? finalResponse["program6"]
                                            : i == 6
                                                ? finalResponse["program7"]
                                                : i == 7
                                                    ? finalResponse["program8"]
                                                    : i == 8
                                                        ? finalResponse[
                                                            "program9"]
                                                        : i == 9
                                                            ? finalResponse[
                                                                "program10"]
                                                            : i == 10
                                                                ? finalResponse[
                                                                    "program11"]
                                                                : "",
                    icon: Icons.done,
                  ),
                  const SizedBox(width: 10),
                  AppText.appText("${programsList[i]}"),
                ]),
              ),
          ],
        ),
        const SizedBox(height: 10),
        customColumn(
            txt1: "Notes",
            width: MediaQuery.of(context).size.width,
            txt2: "${finalResponse["program_note"]}"),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget popUpColumn({txt}) {
    return SizedBox(
      height: 65,
      width: 250,
      child: Column(
        children: [
          AppText.appText("$txt"),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 1,
            width: 250,
            color: Colors.black,
          )
        ],
      ),
    );
  }

  Widget medicalDetail({txt, controller}) {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (currentIndex > 0) {
                  pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.black)),
                child: const Center(
                    child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                )),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                if (currentIndex < criticalMedical.length - 1) {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.black)),
                child: const Center(
                    child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                )),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: pageController,
            itemCount: criticalMedical.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return container(data: criticalMedical[index]);
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        customColumn(
            txt1: "Clinical Diagnosis/ Disability/ Mental Heath",
            txt2: "${finalResponse["clinical_diagnosis"]}",
            width: MediaQuery.of(context).size.width),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: medicalQuest.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.appText(
                  '${medicalQuest[index]}',
                  textColor: const Color(0xff5C5C5C),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "Yes",
                      groupValue: _answers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("Yes", textColor: const Color(0xff5C5C5C)),
                    Radio<String>(
                      value: "No", // No = 0
                      groupValue: _answers[index],
                      onChanged: (String? value) {},
                    ),
                    AppText.appText("No", textColor: const Color(0xff5C5C5C)),
                  ],
                ),
                const SizedBox(height: 20),
                customColumn(
                    txt1: "${medicalQuest[index]} Notes",
                    txt2: "${medicalNotesApi[index]}",
                    width: MediaQuery.of(context).size.width),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget customColumn({txt1, txt2, width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.appText("$txt1", textColor: const Color(0xff5C5C5C)),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 1, color: const Color.fromARGB(255, 181, 181, 181))),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: AppText.appText(
              "$txt2",
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget aboutMeContainer() {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customColumn(
              txt1: "Height (CM)",
              txt2: "${finalResponse["Height"]}",
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            customColumn(
                txt1: "Weight (Kg)",
                txt2: "${finalResponse["Weight"]}",
                width: MediaQuery.of(context).size.width * 0.4)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customColumn(
                txt1: "Eye Color",
                txt2: "${finalResponse["Eye_Colour"]}",
                width: MediaQuery.of(context).size.width * 0.4),
            customColumn(
                txt1: "Hair Color",
                txt2: "${finalResponse["Hair_Colour"]}",
                width: MediaQuery.of(context).size.width * 0.4)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customColumn(
                txt1: "Skin Color",
                txt2: "${finalResponse["Skin_Colour"]}",
                width: MediaQuery.of(context).size.width * 0.4),
            customColumn(
                txt1: "Identifying Features",
                txt2: "${finalResponse["Identifying_Features"]}",
                width: MediaQuery.of(context).size.width * 0.4)
          ],
        )
      ],
    );
  }

  Widget personalDetail() {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 1,
              color: Colors.grey,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 10),
            customColumn(
                txt1: "First Name",
                txt2: "${finalResponse["f_name"]}",
                width: screenWidth),
            customColumn(
                txt1: "Middle Name",
                txt2: "${finalResponse["m_name"]}",
                width: screenWidth),
            customColumn(
                txt1: "Last Name",
                txt2: "${finalResponse["l_name"]}",
                width: screenWidth),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText.appText(
                  'Gender',
                  textColor: const Color(0xff5C5C5C),
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 'Male',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    AppText.appText(
                      'Male',
                      textColor: const Color(0xff5C5C5C),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 'Female',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    AppText.appText(
                      'Female',
                      textColor: const Color(0xff5C5C5C),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 'Other',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    AppText.appText(
                      'Other',
                      textColor: const Color(0xff5C5C5C),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customColumn(
                    txt1: "DOB",
                    txt2: "${finalResponse["dob"]}",
                    width: MediaQuery.of(context).size.width * 0.3),
                customColumn(
                    txt1: "Age",
                    txt2: "$age",
                    width: MediaQuery.of(context).size.width * 0.15),
                customColumn(
                    txt1: "Deceased Date",
                    txt2: "${finalResponse["deceased_date"]}",
                    width: MediaQuery.of(context).size.width * 0.3)
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget containerPlacement({data}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      child: SizedBox(
        height: 170,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customRow1(
                text1: "Name",
                text2: "${data["Organisation_name"]}",
              ),
              customRow1(
                  text1: "Organization ", text2: "${data["Organisation"]}"),
              customRow1(
                  text1: "Commencment Date ",
                  text2: "${data["Commencement_Date"]}"),
              customRow1(text1: "Exit Date ", text2: "${data["Exit_Date"]}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.appText("Action",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.blackColor),
                  actionContainer(
                      onTap: () {
                        popUpPlacement(data: data);
                      },
                      icon: Icons.visibility,
                      color: const Color(0xff1A0B8F))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget containerPractise({data}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      child: SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customRow1(
                text1: "Practice",
                text2: "${data["Practice_name"]}",
              ),
              customRow1(
                  text1: "Type ",
                  text2: data["practice_Type"] == "1"
                      ? "Exclusionay Time Out"
                      : data["practice_Type"] == "2"
                          ? "Psycotropic Medication (PRN)"
                          : data["practice_Type"] == "3"
                              ? "Psycotropic Medication (Routine)"
                              : data["practice_Type"] == "4"
                                  ? "Physical Restraint"
                                  : data["practice_Type"] == "5"
                                      ? "Response Cost"
                                      : data["practice_Type"] == "6"
                                          ? "Restricted Access"
                                          : data["practice_Type"] == "7"
                                              ? "Room Search"
                                              : data["practice_Type"] == "8"
                                                  ? "Seclusion"
                                                  : ""),
              customRow1(
                  text1: "Status",
                  text2: data["Practice_Status"] == 1 ? "Active" : "Inactive"),
              customRow1(
                  text1: "Start Date ", text2: "${data["RPA_Start_Date"]}"),
              customRow1(
                  text1: "Expiry Date ", text2: "${data["Expiry_Date"]}"),
              customRow1(
                  text1: "Review Date ", text2: "${data["Review_Date"]}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.appText("Action",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.blackColor),
                  actionContainer(
                      onTap: () {
                        popUpRestricted(data: data);
                      },
                      icon: Icons.visibility,
                      color: const Color(0xff1A0B8F))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget container({data}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      child: SizedBox(
        height: 170,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customRow1(
                  text1: "Diagnosis Type",
                  text2: data["Diagnosis_Type"] == "1"
                      ? "Chronic Medical Conditions"
                      : data["Diagnosis_Type"] == "2"
                          ? "Developmental Disorders"
                          : data["Diagnosis_Type"] == "3"
                              ? "Intellectual Disabilities"
                              : data["Diagnosis_Type"] == "4"
                                  ? "Learning Disabilities"
                                  : data["Diagnosis_Type"] == "5"
                                      ? "Neurological Conditions"
                                      : data["Diagnosis_Type"] == "6"
                                          ? "Physical Disabilities"
                                          : data["Diagnosis_Type"] == "7"
                                              ? "Psychological Conditions"
                                              : data["Diagnosis_Type"] == "8"
                                                  ? "Sensory Disabilities"
                                                  : ""),
              customRow1(
                  text1: "Diagnosis Level ",
                  text2: data["Diagnosis_level"] == "1"
                      ? "Profound"
                      : data["Diagnosis_level"] == "2"
                          ? "Severe"
                          : data["Diagnosis_level"] == "3"
                              ? "Moderate"
                              : data["Diagnosis_level"] == "4"
                                  ? "Mild"
                                  : ""),
              customRow1(
                  text1: "Requires Plan",
                  text2: data["Management_Plan"] == "1" ? "Yes" : "No"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.appText("Action",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.blackColor),
                  actionContainer(
                      onTap: () {
                        popUp(data: data);
                      },
                      icon: Icons.visibility,
                      color: const Color.fromARGB(255, 60, 48, 120)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void getClientSummary() async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {"id": widget.id};
    try {
      response = await dio.post(path: AppUrls.clientSummary, data: params);
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
          pushUntil(context, const LogInScreen());
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
            finalResponse = responseData["clientdata"][0];
            staffDetail = responseData["staffdetails"][0];
            criticalMedical = responseData["client_diagnosed_disability"];
            clientPlacementHistory = responseData["client_placement_history"];
            clientData = responseData["clientdata"][0];
            restrictedPractice = responseData["client_restricted_practice"];
            documentResponse = responseData["client_documents"];

            print("object$restrictedPractice");
            _answers[0] = finalResponse["allergies_and_adverse_reactions"];
            _answers[1] = finalResponse["asthma"];
            _answers[2] = finalResponse["diabetes"];
            _answers[3] = finalResponse["EPI_Pen"];
            _answers[4] = finalResponse["Medications_Taken"];
            _answers[5] = finalResponse["Seizures"];
            _answers[6] = finalResponse["Other"];
            _goomingAnswers[0] = finalResponse["Clean_Teeth"];
            _goomingAnswers[1] = finalResponse["run_a_shower"];
            _goomingAnswers[2] = finalResponse["Shaving"];
            _goomingAnswers[3] = finalResponse["Washing_Hair"];
            _goomingAnswers[4] = finalResponse["Washing_Hands"];
            _goomingAnswers[5] = finalResponse["Dress_by_themself"];
            _goomingAnswers[6] = finalResponse["Assess_Risk"];
            _goomingAnswers[7] = finalResponse["Manage_Buttons"];
            _goomingAnswers[8] = finalResponse["Special_Bath"];
            _goomingAnswers[9] = finalResponse["Supervision_Required"];
            _bedTimeAnswers[0] = finalResponse["Continence_Aids_Bed"];
            _bedTimeAnswers[1] = finalResponse["go_to_bed"];
            _bedTimeAnswers[2] = finalResponse["sleeping_away"];
            _bedTimeAnswers[3] = finalResponse["Bedroom_Door_Closed"];
            _bedTimeAnswers[4] = finalResponse["Sleeps_with_Light_On"];
            _bedTimeAnswers[5] = finalResponse["Sleeps_in_Single_Room"];
            _bedTimeAnswers[6] = finalResponse["Special_Sleeping_Needs"];
            _bedTimeAnswers[7] = finalResponse["Re_positioned_during_night"];
            _bedTimeAnswers[8] = finalResponse["Sleep_through_the_night"];
            _bedTimeAnswers[9] = finalResponse["Usual_Bedtime_Routine"];
            _bedTimeAnswers[10] = finalResponse["Other_Bedtime_Routine"];
            _supportAnswers[0] = finalResponse["Wandering_Assess_Risk"];
            _supportAnswers[1] = finalResponse["Swearing_Assess_Risk"];
            _supportAnswers[2] = finalResponse["Aggression_Assess_Risk"];
            _supportAnswers[3] = finalResponse["Noisy_Behaviours_Assess_Risk"];
            _supportAnswers[4] = finalResponse["Edible_Substance"];
            _supportAnswers[5] = finalResponse["Compliance_Assess_Risk"];
            _supportAnswers[6] = finalResponse["Damage_Assess_Risk"];
            _supportAnswers[7] = finalResponse["Repetitive_Assess_Risk"];
            _supportAnswers[8] = finalResponse["Self_Injuries_Assess_Risk"];
            _supportAnswers[9] = finalResponse["Self_Stimulatory_Behaviour"];
            _supportAnswers[10] = finalResponse["Other_Behaviours_Assess_Risk"];
            _supportAnswers[12] = finalResponse["Wandering_Assess_Risk"];
            _supportAnswers[11] = finalResponse["Behaviour_Support_Plan"];
            //////////////////////////////////////////////////

            _communityAnswers[0] = finalResponse["Additional_Resources"];
            _communityAnswers[1] = finalResponse["Attend_School"];
            _communityAnswers[2] = finalResponse["Phobias"];
            _communityAnswers[3] = finalResponse["No_Participation"];
            _communityAnswers[4] = finalResponse["Public_Transport"];
            _communityAnswers[5] = finalResponse["Preferred_Seating"];
            _communityAnswers[6] = finalResponse["Maximum_Travel_Time"];
            _communityAnswers[7] =
                finalResponse["Activities_whilst_Travelling"];
            _communityAnswers[8] = finalResponse["Road_Safety"];
            _communityAnswers[9] = finalResponse["Small_Groups"];
            _communityAnswers[10] = finalResponse["Travel_Sickness"];
            _communityAnswers[11] = finalResponse["Seated_Whilst_Travelling"];
            _communityAnswers[12] = finalResponse["Seatbelt_Whilst_Travelling"];
            _communityAnswers[13] = finalResponse["Water_Sports_Incontinence"];
            _communityAnswers[14] = finalResponse["Water_Sports_Independnt"];
            _communityAnswers[15] = finalResponse["Water_Sports_Participation"];
            _communityAnswers[16] = finalResponse["Water_Sports_Specialised"];
            _communityAnswers[17] = finalResponse["Water_Sports_Wheelchair"];

            communityNotesApi = [
              "${finalResponse["Additional_Resources_note"]}",
              "${finalResponse["Attend_School_note"]}",
              "${finalResponse["Phobias_note"]}",
              "${finalResponse["No_Participation_note"]}",
              "${finalResponse["Public_Transport_note"]}",
              "${finalResponse["Preferred_Seating_note"]}",
              "${finalResponse["Maximum_Travel_Time_note"]}",
              "${finalResponse["Activities_whilst_Travelling_note"]}",
              "${finalResponse["Road_Safety_note"]}",
              "${finalResponse["Small_Groups_note"]}",
              "${finalResponse["Travel_Sickness_note"]}",
              "${finalResponse["Seated_Whilst_Travelling_note"]}",
              "${finalResponse["Seatbelt_Whilst_Travelling_note"]}",
              "${finalResponse["Water_Sports_Incontinence_note"]}",
              "${finalResponse["Water_Sports_Independnt_note"]}",
              "${finalResponse["Water_Sports_Participation_note"]}",
              "${finalResponse["Water_Sports_Specialised_note"]}",
              "${finalResponse["Water_Sports_Wheelchair_note"]}",
            ];
            //////////////////////

            _eatDrinkAnswers[0] = finalResponse["Dislikes_food"];
            _eatDrinkAnswers[1] = finalResponse["Likes_food"];
            _eatDrinkAnswers[2] = finalResponse["Assistance_with_Eating"];
            _eatDrinkAnswers[3] = finalResponse["Religious_Food"];
            _eatDrinkAnswers[4] = finalResponse["Encouragement_to_Eat"];
            _eatDrinkAnswers[5] = finalResponse["Food_Allergies"];
            _eatDrinkAnswers[6] = finalResponse["Meals_Served"];
            _eatDrinkAnswers[7] = finalResponse["Nutrition_Plan"];
            _eatDrinkAnswers[8] = finalResponse["Special_Aids_for_Eating"];
            _eatDrinkAnswers[9] = finalResponse["Special_Diet_Requirements"];
            _eatDrinkAnswers[10] = finalResponse["Tube_Feeding_Required"];
            eatNotesApi = [
              "${finalResponse["Dislikes_food_note"]}  ",
              "${finalResponse["Likes_food_note"]}",
              "${finalResponse["Assistance_with_Eating_note"]}",
              "${finalResponse["Religious_Food_note"]}",
              "${finalResponse["Encouragement_to_Eat_note"]}",
              "${finalResponse["Food_Allergies_note"]}",
              "${finalResponse["Meals_Served_note"]}",
              "${finalResponse["Nutrition_Plan_note"]}",
              "${finalResponse["Special_Aids_for_Eating_note"]}",
              "${finalResponse["Special_Diet_Requirements_note"]}",
              "${finalResponse["Tube_Feeding_Required_note"]}",
            ];

            ////////////////////////////////////////
            com = finalResponse["Communications_Plan_Available"];
            selectedGender = "${finalResponse["gender"]}";
            behaviourNotesApi = [
              "${finalResponse["Wandering_Assess_Risk_note"]}",
              "${finalResponse["Swearing_Assess_Risk_note"]}",
              "${finalResponse["Aggression_Assess_Risk_note"]}",
              "${finalResponse["Noisy_Behaviours_Assess_Risk_note"]}",
              "${finalResponse["Edible_Substance_note"]}",
              "${finalResponse["Compliance_Assess_Risk_note"]}",
              "${finalResponse["Damage_Assess_Risk_note"]}",
              "${finalResponse["Repetitive_Assess_Risk_note"]}",
              "${finalResponse["Self_Injuries_Assess_Risk_note"]}",
              "${finalResponse["Self_Stimulatory_Behaviour_note"]}",
              "${finalResponse["Other_Behaviours_Assess_Risk_note"]}",
              "${finalResponse["Behaviours_Managed"]}",
              "${finalResponse["Behaviour_Support_Plan_note"]}",
            ];
////////////////////////////////////////////////////////////////////////////////////

            _mobilityAnswers[0] = finalResponse["Difficulty_moving_on"];
            _mobilityAnswers[1] = finalResponse["Vision_Impaired"];
            _mobilityAnswers[2] = finalResponse["Other_Mobility_Issues"];
            _mobilityAnswers[3] =
                finalResponse["mobility_Special_Aids_Required"];
            _mobilityAnswers[4] = finalResponse["Travelling_in_a_Vehicle"];

            mobilityNotesApi = [
              "${finalResponse["Difficulty_moving_on"]}",
              "${finalResponse["Vision_Impaired"]}",
              "${finalResponse["Other_Mobility_Issues"]}",
              "${finalResponse["mobility_Special_Aids_Required"]}",
              "${finalResponse["Travelling_in_a_Vehicle"]}",
            ];

            DateTime dob =
                DateFormat("yyyy-MM-dd").parse("${finalResponse["dob"]}");
            age = calculateAge(dob);
            medicalNotesApi = [
              "${finalResponse["allergies_and_adverse_reactions_notes"]}",
              "${finalResponse["asthma_notes"]}",
              "${finalResponse["diabetes_notes"]}",
              "${finalResponse["EPI_Notes"]}",
              "${finalResponse["Medications_Taken_Notes"]}",
              "${finalResponse["Seizures_Notes"]}",
              "${finalResponse["Other_Notes"]}",
            ];
            communicationNotesApi = [
              "${finalResponse["Happiness_note"]}",
              "${finalResponse["Hunger_note"]}",
              "${finalResponse["Pain_note"]}",
              "${finalResponse["Reading_note"]}",
              "${finalResponse["Sadness_note"]}",
              "${finalResponse["Staying_Away_from_Home_note"]}",
              "${finalResponse["Telephone_Usage_note"]}",
              "${finalResponse["Thirst_note"]}",
              "${finalResponse["Toileting_note"]}",
              "${finalResponse["Writing_note"]}",
            ];
            bathingNotesApi = [
              "${finalResponse["Clean_Teeth_Notes"]}",
              "${finalResponse["run_a_shower_Notes"]}",
              "${finalResponse["Shaving_Notes"]}",
              "${finalResponse["Washing_Hair_Notes"]}",
              "${finalResponse["Washing_Hands_Notes"]}",
              "${finalResponse["Dress_by_themself_Notes"]}",
              "${finalResponse["Assess_Risk_Notes"]}",
              "${finalResponse["Manage_Buttons_Notes"]}",
              "${finalResponse["Special_Bath_Notes"]}",
              "${finalResponse["Supervision_Required_Notes"]}",
            ];
            bedTimeNotesApi = [
              "${finalResponse["Continence_Aids_Bed_note"]}",
              "${finalResponse["go_to_bed_note"]}",
              "${finalResponse["sleeping_away_note"]}",
              "${finalResponse["Bedroom_Door_Closed_note"]}",
              "${finalResponse["Sleeps_with_Light_On_note"]}",
              "${finalResponse["Sleeps_in_Single_Room_note"]}",
              "${finalResponse["Special_Sleeping_Needs_note"]}",
              "${finalResponse["Re_positioned_during_night_note"]}",
              "${finalResponse["Sleep_through_the_night_note"]}",
              "${finalResponse["Usual_Bedtime_Routine_note"]}",
              "${finalResponse["Other_Bedtime_Routine_note"]}",
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

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  Widget customRow1({text1, text2}) {
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

  Widget containerDocuments({data}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      child: SizedBox(
        height: 140,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customRow1(
                text1: "Sl",
                text2: "${data["document_id"]}",
              ),
              customRow1(
                  text1: "Document Name", text2: "${data["document_name"]}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.appText("Download",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.blackColor),
                  actionContainer(
                      onTap: () async {
                        FileDownloader.downloadFile(
                          url:
                              "https://portaltest.thebrandwings.com/upload/${data["doc_client_id"]}/${data["document_file"]}",
                          notificationType: NotificationType.all,
                          onProgress: (fileName, progress) {
                            setState(() {
                              _progress = progress;
                            });
                          },
                          onDownloadCompleted: (path) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const DownloadSuccessPopup(
                                  msg1: "Successfully",
                                );
                              },
                            );
                          },
                          onDownloadError: (errorMessage) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const DownloadSuccessPopup(
                                  msg1: "Failed",
                                );
                              },
                            );
                          },
                        );
                      },
                      icon: Icons.download,
                      color: const Color(0xff1A0B8F))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void popUp({data}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText.appText("Diagnosed Disability"),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.cancel))
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: 1,
                          color: const Color.fromARGB(255, 123, 118, 118),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 265,
                            width: MediaQuery.of(context).size.width - 20,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  customColumn(
                                      txt1: "Diagnosis Type [?] *",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: data["Diagnosis_Type"] == "1"
                                          ? "Chronic Medical Conditions"
                                          : data["Diagnosis_Type"] == "2"
                                              ? "Developmental Disorders"
                                              : data["Diagnosis_Type"] == "3"
                                                  ? "Intellectual Disabilities"
                                                  : data["Diagnosis_Type"] ==
                                                          "4"
                                                      ? "Learning Disabilities"
                                                      : data["Diagnosis_Type"] ==
                                                              "5"
                                                          ? "Neurological Conditions"
                                                          : data["Diagnosis_Type"] ==
                                                                  "6"
                                                              ? "Physical Disabilities"
                                                              : data["Diagnosis_Type"] ==
                                                                      "7"
                                                                  ? "Psychological Conditions"
                                                                  : data["Diagnosis_Type"] ==
                                                                          "8"
                                                                      ? "Sensory Disabilities"
                                                                      : ""),
                                  customColumn(
                                      txt1: "Level [?] *",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: data["Diagnosis_level"] == "1"
                                          ? "Profound"
                                          : data["Diagnosis_level"] == "2"
                                              ? "Severe"
                                              : data["Diagnosis_level"] == "3"
                                                  ? "Moderate"
                                                  : data["Diagnosis_level"] ==
                                                          "4"
                                                      ? "Mild"
                                                      : ""),
                                  customColumn(
                                      txt1: "Diagnosis *",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: "${data["Diagnosis"]}"),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        '${diagnosisList[0]}',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "1",
                                            groupValue:
                                                data["Diagnosed_by"] == "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("Yes",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue:
                                                data["Diagnosed_by"] == "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("No",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        '${diagnosisList[1]}',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "1",
                                            groupValue:
                                                data["Management_Plan"] == "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("Yes",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue:
                                                data["Management_Plan"] == "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("No",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  customColumn(
                                      txt1: "Notes",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: "${data["Management_Plan_note"]}"),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ))),
          ),
        );
      },
    );
  }

  void popUpPlacement({data}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText.appText(
                                  "Living Arrangements / Placement History"),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.cancel))
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: 1,
                          color: const Color.fromARGB(255, 123, 118, 118),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 265,
                            width: MediaQuery.of(context).size.width - 20,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.appText("Type",
                                      textColor: const Color(0xff5C5C5C)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    alignment: WrapAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    runSpacing: 10,
                                    spacing: 10,
                                    children: [
                                      for (int i = 0;
                                          i < placementWrapList.length;
                                          i++)
                                        IntrinsicWidth(
                                          child: Row(children: [
                                            _buildIconOrContainer(
                                              value: i == 0
                                                  ? data["Drop_in_Support"]
                                                  : i == 1
                                                      ? data[
                                                          "Family_Group_Home"]
                                                      : i == 2
                                                          ? data["Foster_Care"]
                                                          : i == 3
                                                              ? data[
                                                                  "Lives_Alone"]
                                                              : i == 4
                                                                  ? data[
                                                                      "Lives_with_Family"]
                                                                  : i == 5
                                                                      ? data[
                                                                          "Lives_with_Others"]
                                                                      : i == 6
                                                                          ? data[
                                                                              "Therapeutic_Residential_Care"]
                                                                          : i == 7
                                                                              ? data["Refugee_Care"]
                                                                              : i == 8
                                                                                  ? data["Relative_Care"]
                                                                                  : i == 9
                                                                                      ? data["Care_Group_Home"]
                                                                                      : i == 10
                                                                                          ? data["Care_Group_Other"]
                                                                                          : i == 11
                                                                                              ? data["Respite_Care"]
                                                                                              : i == 12
                                                                                                  ? data["Semi_Independent"]
                                                                                                  : i == 13
                                                                                                      ? data["Other"]
                                                                                                      : "",
                                              icon: Icons.done,
                                            ),
                                            const SizedBox(width: 10),
                                            AppText.appText(
                                                "${placementWrapList[i]}"),
                                          ]),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  customColumn(
                                      txt1: "Type Note",
                                      txt2:
                                          "${data["Placement_History_Type_note"]}",
                                      width: MediaQuery.of(context).size.width),
                                  customColumn(
                                      txt1: "Organisation",
                                      txt2: "${data["Organisation"]}",
                                      width: MediaQuery.of(context).size.width),
                                  customColumn(
                                      txt1: "Name",
                                      txt2: "${data["Organisation_name"]}",
                                      width: MediaQuery.of(context).size.width),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        '${placementList[0]}',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "1",
                                            groupValue:
                                                data["Is_there_a_Placement_Agreement"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("Yes",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue:
                                                data["Is_there_a_Placement_Agreement"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("No",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customColumn(
                                          txt1: "${placementList[0]} Notes",
                                          txt2:
                                              "${data["Is_there_a_Placement_Agreement_note"]}",
                                          width:
                                              MediaQuery.of(context).size.width)
                                    ],
                                  ),
                                  customColumn(
                                      txt1: "Primary Carer",
                                      txt2: "${data["Primary_Carer"]}",
                                      width: MediaQuery.of(context).size.width),
                                  customColumn(
                                      txt1: "Commencement date",
                                      txt2: "${data["Commencement_Date"]}",
                                      width: MediaQuery.of(context).size.width),
                                  customColumn(
                                      txt1: "Reason for Entering Placement",
                                      txt2: "${data["Primary_Carer"]}",
                                      width: MediaQuery.of(context).size.width),
                                  customColumn(
                                      txt1:
                                          "Reason for Entering Placement Note",
                                      txt2:
                                          "${data["Reason_for_Entering_Placement_note"]}",
                                      width: MediaQuery.of(context).size.width),
                                  AppText.appText(
                                      "Services provided by Agency to Client prior to entering care",
                                      textColor: const Color(0xff5C5C5C)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    alignment: WrapAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    runSpacing: 10,
                                    spacing: 10,
                                    children: [
                                      for (int i = 0;
                                          i < placementWrapList1.length;
                                          i++)
                                        IntrinsicWidth(
                                          child: Row(children: [
                                            _buildIconOrContainer(
                                              value: i == 0
                                                  ? data["Adolescent_Support"]
                                                  : i == 1
                                                      ? data["Advocacy"]
                                                      : i == 2
                                                          ? data["Day_Services"]
                                                          : i == 3
                                                              ? data["Family"]
                                                              : i == 4
                                                                  ? data[
                                                                      "Family_Support"]
                                                                  : i == 5
                                                                      ? data[
                                                                          "Respite"]
                                                                      : i == 6
                                                                          ? data[
                                                                              "Restoration"]
                                                                          : i == 7
                                                                              ? data["Therapeutic_Support"]
                                                                              : i == 8
                                                                                  ? data["None"]
                                                                                  : i == 9
                                                                                      ? data["prior_to_entering_Other"]
                                                                                      : "",
                                              icon: Icons.done,
                                            ),
                                            const SizedBox(width: 10),
                                            AppText.appText(
                                                "${placementWrapList1[i]}"),
                                          ]),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  customColumn(
                                      txt1:
                                          "Services provided by Agency to Client prior to entering care Note",
                                      width: MediaQuery.of(context).size.width,
                                      txt2:
                                          "${data["prior_to_entering_note"]}"),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        '${placementList[1]}',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "1",
                                            groupValue:
                                                data["Entering_into_Voluntary_Care"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("Yes",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue:
                                                data["Entering_into_Voluntary_Care"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("No",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customColumn(
                                          txt1: "${placementList[1]} Notes",
                                          txt2:
                                              "${data["Entering_into_Voluntary_Care_note"]}",
                                          width:
                                              MediaQuery.of(context).size.width)
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        '${placementList[2]}',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "1",
                                            groupValue:
                                                data["Is_the_Person_Self_Placed"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("Yes",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue:
                                                data["Is_the_Person_Self_Placed"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("No",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customColumn(
                                          txt1: "${placementList[2]} Notes",
                                          txt2:
                                              "${data["Is_the_Person_Self_Placed_note"]}",
                                          width:
                                              MediaQuery.of(context).size.width)
                                    ],
                                  ),
                                  customColumn(
                                      txt1: "Legal Status/Placement Status",
                                      txt2: data["Placement_Status"] == "1"
                                          ? "Legal Status/Placement Status"
                                          : data["Placement_Status"] == "2"
                                              ? "Carer responsibility of DG removal or assumption of care"
                                              : data["Placement_Status"] == "3"
                                                  ? "Court Order"
                                                  : data["Placement_Status"] ==
                                                          "4"
                                                      ? "Court Order of Parental responsibility (*Full or Share) order"
                                                      : data["Placement_Status"] ==
                                                              "5"
                                                          ? "Detached refuge"
                                                          : data["Placement_Status"] ==
                                                                  "6"
                                                              ? "Guardianship Order"
                                                              : data["Placement_Status"] ==
                                                                      "7"
                                                                  ? "No Order"
                                                                  : data["Placement_Status"] ==
                                                                          "8"
                                                                      ? "Official Public Guardian"
                                                                      : data["Placement_Status"] ==
                                                                              "9"
                                                                          ? "Parental responsibility for interstate ward"
                                                                          : data["Placement_Status"] == "10"
                                                                              ? "PR to Minister - Final Order"
                                                                              : data["Placement_Status"] == "11"
                                                                                  ? "PR to Minister - Interim Order"
                                                                                  : data["Placement_Status"] == "12"
                                                                                      ? "PR to Minister - Shared Care"
                                                                                      : data["Placement_Status"] == "13"
                                                                                          ? "Pre-adoption"
                                                                                          : data["Placement_Status"] == "14"
                                                                                              ? "Relative/kinship care"
                                                                                              : data["Placement_Status"] == "15"
                                                                                                  ? "Sole Parental Responsibility"
                                                                                                  : data["Placement_Status"] == "16"
                                                                                                      ? "Temporary care management"
                                                                                                      : data["Placement_Status"] == "17"
                                                                                                          ? "Temporary Care Order"
                                                                                                          : data["Placement_Status"] == "18"
                                                                                                              ? "Voluntary care"
                                                                                                              : data["Placement_Status"] == "19"
                                                                                                                  ? "Other (Specify)"
                                                                                                                  : data["Placement_Status"] == "20"
                                                                                                                      ? "After Care"
                                                                                                                      : "",
                                      width: MediaQuery.of(context).size.width),
                                  customColumn(
                                      txt1:
                                          "Legal Status/Placement Status Note",
                                      txt2: "${data["Placement_Status_note"]}",
                                      width: MediaQuery.of(context).size.width),
                                  customColumn(
                                      txt1: "Purpose of Placement",
                                      txt2: data["Purpose_of_Placement"] == "1"
                                          ? "Emergency Care"
                                          : data["Purpose_of_Placement"] == "2"
                                              ? "Pending Court Decision"
                                              : data["Purpose_of_Placement"] ==
                                                      "3"
                                                  ? "Permanent Care"
                                                  : data["Purpose_of_Placement"] ==
                                                          "4"
                                                      ? "Respite Care"
                                                      : data["Purpose_of_Placement"] ==
                                                              "5"
                                                          ? "Transition to Adoption"
                                                          : data["Purpose_of_Placement"] ==
                                                                  "6"
                                                              ? "Transition to Independence"
                                                              : data["Purpose_of_Placement"] ==
                                                                      "7"
                                                                  ? "Transition to Permanent Care Transition to Restoration"
                                                                  : data["Purpose_of_Placement"] ==
                                                                          "8"
                                                                      ? "Other (Specify)"
                                                                      : data["Purpose_of_Placement"] ==
                                                                              "9"
                                                                          ? "Assessment (no court decision pending)"
                                                                          : "",
                                      width: MediaQuery.of(context).size.width),
                                  customColumn(
                                      txt1: "Purpose of Placement Note",
                                      txt2:
                                          "${data["Purpose_of_Placement_note"]}",
                                      width: MediaQuery.of(context).size.width),
                                  customColumn(
                                      txt1:
                                          "Service provided by Agency to client prior to entring care Note",
                                      txt2: "${data["prior_to_entering_note"]}",
                                      width: MediaQuery.of(context).size.width),
                                  customColumn(
                                      txt1: "Siblings/Family in same Placement",
                                      txt2: data["Family_in_Same_Placement"] ==
                                              "2"
                                          ? " Family or Relative placed in care together"
                                          : data["Family_in_Same_Placement"] ==
                                                  "3"
                                              ? "No siblings"
                                              : data["Family_in_Same_Placement"] ==
                                                      "4"
                                                  ? "Placed with at least one sibling"
                                                  : data["Family_in_Same_Placement"] ==
                                                          "5"
                                                      ? "Siblings in care"
                                                      : data["Family_in_Same_Placement"] ==
                                                              "6"
                                                          ? "Unknown"
                                                          : data["Family_in_Same_Placement"] ==
                                                                  "7"
                                                              ? "All siblings in care are placed together"
                                                              : "",
                                      width: MediaQuery.of(context).size.width),
                                  customColumn(
                                      txt1:
                                          "Siblings/Family in same Placement Note",
                                      txt2:
                                          "${data["Family_in_Same_Placement_note"]}",
                                      width: MediaQuery.of(context).size.width),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        '${placementList[3]}',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "1",
                                            groupValue:
                                                data["culturally_compatible"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("Yes",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue:
                                                data["culturally_compatible"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("No",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customColumn(
                                          txt1: "${placementList[3]} Notes",
                                          txt2:
                                              "${data["culturally_compatible_note"]}",
                                          width:
                                              MediaQuery.of(context).size.width)
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        '${placementList[4]}',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "1",
                                            groupValue:
                                                data["Placement_Principles_applied"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("Yes",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue:
                                                data["Placement_Principles_applied"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("No",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customColumn(
                                          txt1: "${placementList[4]} Notes",
                                          txt2:
                                              "${data["Placement_Principles_applied_note"]}",
                                          width:
                                              MediaQuery.of(context).size.width)
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        '${placementList[5]}',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "1",
                                            groupValue:
                                                data["Move_Planned_or_Unplanned"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("Yes",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue:
                                                data["Move_Planned_or_Unplanned"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("No",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customColumn(
                                          txt1: "${placementList[5]} Notes",
                                          txt2:
                                              "${data["Move_Planned_or_Unplanned_note"]}",
                                          width:
                                              MediaQuery.of(context).size.width)
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        '${placementList[6]}',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "1",
                                            groupValue:
                                                data["period_with_your_agency"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("Yes",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue:
                                                data["period_with_your_agency"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("No",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customColumn(
                                          txt1: "${placementList[6]} Notes",
                                          txt2:
                                              "${data["period_with_your_agency_note"]}",
                                          width:
                                              MediaQuery.of(context).size.width)
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        '${placementList[7]}',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "1",
                                            groupValue:
                                                data["Person_referred"] == "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("Yes",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue:
                                                data["Person_referred"] == "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("No",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customColumn(
                                          txt1: "${placementList[7]} Notes",
                                          txt2:
                                              "${data["Person_referred_note"]}",
                                          width:
                                              MediaQuery.of(context).size.width)
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        '${placementList[8]}',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "1",
                                            groupValue:
                                                data["Documentation_completed"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("Yes",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue:
                                                data["Documentation_completed"] ==
                                                        "1"
                                                    ? "1"
                                                    : "0",
                                            onChanged: (String? value) {},
                                          ),
                                          AppText.appText("No",
                                              textColor:
                                                  const Color(0xff5C5C5C)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customColumn(
                                          txt1: "${placementList[8]} Notes",
                                          txt2:
                                              "${data["Documentation_completed_note"]}",
                                          width:
                                              MediaQuery.of(context).size.width)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ))),
          ),
        );
      },
    );
  }

  Widget _buildIconOrContainer({value, icon}) {
    return value == "on" || value == "yes"
        ? Icon(icon)
        : Container(
            height: 20,
            width: 20,
            color: Colors.grey,
          );
  }

  Widget _buildIconOrContainer1({value, icon}) {
    return value == "\"on\"" || value == "yes"
        ? Icon(icon)
        : Container(
            height: 20,
            width: 20,
            color: Colors.grey,
          );
  }

  void popUpRestricted({data}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText.appText("Restricted Practise"),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.cancel))
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: 1,
                          color: const Color.fromARGB(255, 123, 118, 118),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 265,
                            width: MediaQuery.of(context).size.width - 20,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customColumn(
                                      txt1: " Practice*",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: "${data["Practice_name"]}"),
                                  AppText.appText(
                                    'Status',
                                    textColor: const Color(0xff5C5C5C),
                                  ),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: "1",
                                        groupValue:
                                            data["Practice_Status"] == "1"
                                                ? "1"
                                                : "0",
                                        onChanged: (String? value) {},
                                      ),
                                      AppText.appText("Active",
                                          textColor: const Color(0xff5C5C5C)),
                                      Radio<String>(
                                        value: "0", // No = 0
                                        groupValue:
                                            data["Practice_Status"] == "1"
                                                ? "1"
                                                : "0",
                                        onChanged: (String? value) {},
                                      ),
                                      AppText.appText("Inactive",
                                          textColor: const Color(0xff5C5C5C)),
                                    ],
                                  ),
                                  customColumn(
                                      txt1: "RPA Start Date",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: "${data["RPA_Start_Date"]}"),
                                  customColumn(
                                      txt1: "Restricted practice Inactive Date",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: "${data["Inactive_Date"]}"),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        'Type',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1",
                                                groupValue:
                                                    data["practice_Type"] == "1"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText(
                                                  "Exclusionay Time Out",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["practice_Type"] == "2"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText(
                                                  "Psycotropic Medication (PRN)",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["practice_Type"] == "3"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText(
                                                  "Psycotropic Medication (Routine)",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["practice_Type"] == "4"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText(
                                                  "Physical Restraint",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["practice_Type"] == "5"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("Response Cost",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["practice_Type"] == "6"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText(
                                                  "Restrited Access",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["practice_Type"] == "7"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("Room Search",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["practice_Type"] == "8"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("Seclusion",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  customColumn(
                                      txt1: "RPA Description",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: "${data["RPA_Description"]}"),
                                  customColumn(
                                      txt1: "RPA Panel Date",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: "${data["RPA_Panel_Date"]}"),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        'RPA Panel Outcomes',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1",
                                                groupValue:
                                                    data["RPA_Panel_Outcomes"] ==
                                                            "1"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("Ceased",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["RPA_Panel_Outcomes"] ==
                                                            "2"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText(
                                                  "Full Authorisation",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["RPA_Panel_Outcomes"] ==
                                                            "3"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("Interim",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["RPA_Panel_Outcomes"] ==
                                                            "4"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("Lapsed",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["RPA_Panel_Outcomes"] ==
                                                            "5"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("Not Authorised",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  customColumn(
                                      txt1: "Review Date",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: "${data["Review_Date"]}"),
                                  customColumn(
                                      txt1: "Expiry Date",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: "${data["Expiry_Date"]}"),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.appText(
                                        'Consenter',
                                        textColor: const Color(0xff5C5C5C),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1",
                                                groupValue:
                                                    data["Consenter"] == "1"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText(
                                                  "Appointed Guardian",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["Consenter"] == "2"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText(
                                                  "CEO Authorisation",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["Consenter"] == "3"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("FACS",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["Consenter"] == "4"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("Family Member",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["Consenter"] == "5"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("Parent",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["Consenter"] == "6"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("Self",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "1", // No = 0
                                                groupValue:
                                                    data["Consenter"] == "7"
                                                        ? "1"
                                                        : "0",
                                                onChanged: (String? value) {},
                                              ),
                                              AppText.appText("TBC",
                                                  textColor:
                                                      const Color(0xff5C5C5C)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  customColumn(
                                      txt1: "First Approved Date",
                                      width: MediaQuery.of(context).size.width,
                                      txt2: "${data["First_Approved_Date"]}"),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ))),
          ),
        );
      },
    );
  }
}
