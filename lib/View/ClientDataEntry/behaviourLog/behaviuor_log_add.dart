import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/custom_appbar.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_field.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ClientDataEntry/behaviourLog/behaviour_log.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BehaviourLogAdd extends StatefulWidget {
  final showButtons;
  final stateRes;
  final staffRes;
  final clientRes;
  final name;
  final id;
  final logId;

  final edit;
  const BehaviourLogAdd(
      {super.key,
      this.showButtons,
      this.clientRes,
      this.id,
      this.name,
      this.staffRes,
      this.stateRes,
      this.edit,
      this.logId});

  @override
  State<BehaviourLogAdd> createState() => _BehaviourLogAddState();
}

class _BehaviourLogAddState extends State<BehaviourLogAdd> {
  DateTime? entryDate;
  bool _competition = false;
  bool _showQuestions = false;
  bool _behaviourLog = false;
  bool _behaviourConcern = false;

  var selectedHierarchy = "Hierarchy";
  var selectedRegion = "Region";
  var selectedUnit = "Unit";
  var selectedClient = "Select Client";
  var stateId;
  var regionId;
  var unitId;
  var clientId;
  late AppDio dio;
  AppLogger logger = AppLogger();
  List<String?> _answers = List.filled(2, null);
  List<String?> _answers1 = List.filled(33, null);
  List<String?> _answers2 = List.filled(22, null);
  List<bool> _showTextField = List.generate(2, (_) => false);
  List<TextEditingController> _textControllers = List.generate(
    2,
    (_) => TextEditingController(),
  );
  List<bool> _showTextField1 = List.generate(33, (_) => false);
  List<TextEditingController> _textControllers1 = List.generate(
    33,
    (_) => TextEditingController(),
  );
  List<bool> _showTextField2 = List.generate(22, (_) => false);
  List<TextEditingController> _textControllers2 = List.generate(
    22,
    (_) => TextEditingController(),
  );

  bool _isLoading = false;
  var finalResponse;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    if (widget.edit == true) {
      getLogDetail();
    }

    super.initState();
  }

  List behaviourOfConcern = [
    "Abnormal Perceptions",
    "Alcohol/substance/Solvent Use",
    "Antisocal Behaviour",
    "Anxiety",
    "Binging/Purging/Refusal to Eat",
    "Communication Issues",
    "Difficulties With/Refusal to Engage in Learning",
    "Difficulties With/Refusal to Engage Independence Skills",
    "Difficulties With/Refusal to Maintain Personal Self Care",
    "Difficulty Self Regulating Emotions",
    "Distortion/Memory Loss",
    "Distress/Worrying/Crying",
    "Fears and Phobias",
    "Impulsive Behaviour Targeting Property of Others",
    "Inattention/Lack of Concentration",
    "Indiscriminate Disclosures",
    "Loss of Interest in Activities",
    "Mimicking Others Behaviours",
    "Obsessions or Compulsions",
    "Odd and/or Bizarre Behaviour",
    "Oppositional/Defiant Behaviour",
    "Overactive Behaviour",
    "Physical Aggression",
    "Problems With Peers/Staff/Family",
    "Self Criticism",
    "Self Injury (Evidence Of)",
    "Self Injury (Thoughts Of)",
    "Inappropriate Sexualised Behaviour",
    "Signs of/Disclosures of Hearing Voices",
    "Sleep Problems/Chronic Fatigue/Bed Wetting",
    "Somatising",
    "Verbal Aggression",
    "Withdrawal From Others",
  ];
  List behaviourlogElements = [
    "Active Listening",
    "Anger Management",
    "Being Respectful",
    "Being Safe",
    "Conflict Management",
    "Cooperation",
    "Effective Communication",
    "Following Directions",
    "Helping Others",
    "Increasing Acceptance and Tolerance of Diverse Group",
    "Listening",
    "Participation",
    "Patience",
    "Peer Resistance Skills",
    "Politeness and Manners",
    "Positive Interactions",
    "Praising Others and Refraining From Negative Comments",
    "Recognising/Understanding Points of View of Others",
    "Remaining on Task",
    "Sharing",
    "Social Problem Solving",
    "Taking Turns",
  ];
  List healthCare = [
    "Genger Illness",
    "Mensturation",
  ];
  TextEditingController _progressController = TextEditingController();
  final ExpansionTileController clientController = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    print("nkndndekll${behaviourOfConcern.length}");
    print("logele${behaviourlogElements.length}");

    return Scaffold(
        appBar: const CustomAppBar(
          title: "Behaviour Log Add",
        ),
        body: widget.edit == true
            ? _isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : bodyColumn()
            : bodyColumn());
  }

  Widget bodyColumn() {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(txt: "Select Clients"),
            expandedTile(txt: "$selectedClient"),
            CustomText(txt: "Entry Date"),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                width: screenWidth,
                height: 40,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.appText(
                          entryDate == null
                              ? "DD/MM/YYYY"
                              : DateFormat('MM-dd-yyyy').format(entryDate!),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: entryDate == null
                              ? AppTheme.txtColor
                              : AppTheme.txtColor),
                      Icon(
                        Icons.calendar_month,
                        color: AppTheme.txtColor,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomText(txt: "Hierarchy *"),
            Container(
              height: 50,
              width: screenWidth,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                child: AppText.appText(
                    "$selectedHierarchy->$selectedRegion->$selectedUnit",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: const Color(0xff555555)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _showQuestions = !_showQuestions; // Toggle visibility
                      });
                    },
                    child: customContainer(txt: "Health Care", width: 140.0)),
                _showQuestions == false
                    ? const SizedBox.shrink()
                    : SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: healthCare.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${healthCare[index]}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "2",
                                            groupValue: _answers[index],
                                            onChanged: (String? value) {
                                              setState(() {
                                                _answers[index] = value;
                                                _showTextField[index] =
                                                    value == "2";
                                              });
                                            },
                                          ),
                                          const Text('Yes'),
                                          Radio<String>(
                                            value: "0", // No = 0
                                            groupValue: _answers[index],
                                            onChanged: (String? value) {
                                              setState(() {
                                                _answers[index] = value;
                                                _showTextField[index] = false;
                                              });
                                            },
                                          ),
                                          const Text('No'),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Visibility(
                                        visible: _showTextField[index],
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0.0),
                                          child: AppField(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            textEditingController:
                                                _textControllers[index],
                                            hintText: 'Notes',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              AppText.appText("Progress Notes"),
                              const SizedBox(
                                height: 10,
                              ),
                              AppField(
                                  borderRadius: BorderRadius.circular(10),
                                  textEditingController: _progressController)
                            ],
                          ),
                        ),
                      ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _behaviourConcern =
                            !_behaviourConcern; // Toggle visibility
                      });
                    },
                    child: customContainer(
                        txt: "Behaviour of concern", width: 190.0)),
                _behaviourConcern == false
                    ? const SizedBox.shrink()
                    : SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: behaviourOfConcern.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${behaviourOfConcern[index]}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: "2", // Yes = 1
                                        groupValue: _answers1[index],
                                        onChanged: (String? value) {
                                          setState(() {
                                            _answers1[index] = value;
                                            _showTextField1[index] =
                                                value == "2";
                                          });
                                        },
                                      ),
                                      const Text('Yes'),
                                      Radio<String>(
                                        value: "0", // No = 0
                                        groupValue: _answers1[index],
                                        onChanged: (String? value) {
                                          setState(() {
                                            _answers1[index] = value;
                                            _showTextField1[index] = false;
                                          });
                                        },
                                      ),
                                      const Text('No'),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: _showTextField1[index],
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      child: AppField(
                                        borderRadius: BorderRadius.circular(20),
                                        textEditingController:
                                            _textControllers1[index],
                                        hintText: 'Notes',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _behaviourLog = !_behaviourLog; // Toggle visibility
                    });
                  },
                  child: customContainer(
                      txt: "Behaviour Log Elements-Adaptive", width: 265.0),
                ),
                _behaviourLog == false
                    ? const SizedBox.shrink()
                    : SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 22,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${behaviourlogElements[index]}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: "2", // Yes = 1
                                        groupValue: _answers2[index],
                                        onChanged: (String? value) {
                                          setState(() {
                                            _answers2[index] = value;
                                            _showTextField2[index] =
                                                value == "2";
                                          });
                                        },
                                      ),
                                      const Text('Yes'),
                                      Radio<String>(
                                        value: "0", // No = 0
                                        groupValue: _answers2[index],
                                        onChanged: (String? value) {
                                          setState(() {
                                            _answers2[index] = value;
                                            _showTextField2[index] = false;
                                          });
                                        },
                                      ),
                                      const Text('No'),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: _showTextField2[index],
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      child: AppField(
                                        borderRadius: BorderRadius.circular(20),
                                        textEditingController:
                                            _textControllers2[index],
                                        hintText: 'Notes',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _competition = !_competition; // Toggle visibility
                      });
                    },
                    child: customContainer(
                        txt: "Cometition & Sign-off", width: 190.0)),
                _competition == false
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText("Staff Member"),
                            const SizedBox(
                              height: 10,
                            ),
                            AppText.appText("${widget.name}")
                          ],
                        ),
                      )
              ],
            ),
            widget.showButtons == false
                ? const SizedBox.shrink()
                : _isLoading == true
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35.0),
                        child: _isLoading == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.appColor,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppButton.appButton("Save", onTap: () {
                                    if (widget.edit == true) {
                                      if (clientId == null) {
                                        showSnackBar(context,
                                            "Please select Client again");
                                      } else {
                                        updateBehaviourForm();
                                      }
                                    } else {
                                      if (clientId == null) {
                                        showSnackBar(
                                            context, "Please select Client");
                                      } else {
                                        saveBehaviourForm();
                                      }
                                    }
                                  },
                                      textColor: AppTheme.whiteColor,
                                      backgroundColor: Color(0xff00BFA5),
                                      height: 30,
                                      width: 110),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  AppButton.appButton("Cancel",
                                      textColor: AppTheme.whiteColor,
                                      backgroundColor: Color(0xffF32184),
                                      height: 30,
                                      width: 110),
                                ],
                              ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget customContainer({txt, double? width}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        height: 40,
        width: width,
        decoration: const BoxDecoration(color: Color(0xFFDAF1F3)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(
                Icons.add,
                color: Color(0xFF3EB1B1),
              ),
              SizedBox(
                width: 5,
              ),
              AppText.appText("$txt",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: const Color(0xFF3EB1B1))
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomText({txt}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: AppText.appText("$txt",
          fontSize: 14,
          fontWeight: FontWeight.w400,
          textColor: const Color(0xff555555)),
    );
  }

  Widget expandedTile({txt}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: ExpansionTile(
        controller: clientController,
        title: AppText.appText(
          '$txt',
          textColor: const Color(0xFF666666),
          fontSize: 14,
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.clientRes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (clientController.isExpanded) {
                        clientController.collapse();
                      } else {
                        clientController.expand();
                      }
                      selectedClient =
                          "${widget.clientRes[index]["f_name"]}  ${widget.clientRes[index]["l_name"]}";
                      selectedHierarchy =
                          "${widget.clientRes[index]["state_name"]} ";
                      selectedRegion =
                          "${widget.clientRes[index]["region_name"]} ";
                      selectedUnit = "${widget.clientRes[index]["unit_name"]} ";
                      stateId = widget.clientRes[index]["state_id"];
                      regionId = widget.clientRes[index]["region_id"];
                      unitId = widget.clientRes[index]["unit_id"];
                      clientId = "${widget.clientRes[index]["cl_unq_no"]}";
                    });
                  },
                  child: customRow(
                      txt:
                          "${widget.clientRes[index]["f_name"]}  ${widget.clientRes[index]["l_name"]}"));
            },
          )
        ],
      ),
    );
  }

  Widget customRow({txt, onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            AppText.appText(
              '$txt',
              textColor: const Color(0xFF666666),
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: entryDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppTheme.appColor, // Change the primary color
            colorScheme: ColorScheme.light(
                primary: AppTheme.appColor), // Change overall color scheme
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != entryDate) {
      setState(() {
        entryDate = picked;
        print("object$entryDate");
      });
    }
  }

  void saveBehaviourForm() async {
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
      'behaviour_client_id': clientId,
      'behaviour_date': entryDate,
      'general_illness': _answers[0],
      'general_illness_notes': _textControllers[0].text,
      'Menstruation': _answers[1],
      'Menstruation_notes': _textControllers[1].text,
      'Behavipur_Weight': _progressController.text,
      'abnormal_perceptions': _answers1[0],
      'abnormal_perceptions_notes': _textControllers1[0].text,
      'alcohol_use': _answers1[1],
      'alcohol_use_notes': _textControllers1[1].text,
      'antisocial_behaviour': _answers1[2],
      'antisocial_behaviour_notes': _textControllers1[2].text,
      'anxiety': _answers1[3],
      'anxiety_notes': _textControllers1[3].text,
      'binging_to_eat': _answers1[4],
      'binging_to_eat_notes': _textControllers1[4].text,
      'communication_issues': _answers1[5],
      'communication_issues_notes': _textControllers1[5].text,
      'Engage_Learning': _answers1[6],
      'Engage_Learning_notes': _textControllers1[6].text,
      'Engage_Independence_Skills': _answers1[7],
      'Engage_Independence_Skills_notes': _textControllers1[7].text,
      'Maintain_Personal_Self_Care': _answers1[8],
      'Maintain_Personal_Self_Care_notes': _textControllers1[8].text,
      'Self_Regulating_Emotions': _answers1[9],
      'Self_Regulating_Emotions_notes': _textControllers1[9].text,
      'Memory_Loss': _answers1[10],
      'Memory_Loss_notes': _textControllers1[10].text,
      'Distress': _answers1[11],
      'Distress_notes': _textControllers1[11].text,
      'Fears_Phobias': _answers1[12],
      'Fears_Phobias_notes': _textControllers1[12].text,
      'Impulsive_Behaviour': _answers1[13],
      'Impulsive_Behaviour_notes': _textControllers1[13].text,
      'Lack_Concentration': _answers1[14],
      'Lack_Concentration_notes': _textControllers1[14].text,
      'Indiscriminate_Disclosures': _answers1[15],
      'Indiscriminate_Disclosures_notes': _textControllers1[15].text,
      'Loss_of_Interest': _answers1[16],
      'Loss_of_Interest_notes': _textControllers1[16].text,
      'Mimicking_Others_Behaviours': _answers1[17],
      'Mimicking_Others_Behaviours_notes': _textControllers1[17].text,
      'Obsessions_Compulsions': _answers1[18],
      'Obsessions_Compulsions_notes': _textControllers1[18].text,
      'Bizarre_Behaviour': _answers1[19],
      'Bizarre_Behaviour_notes': _textControllers1[19].text,
      'Oppositional_Behaviour': _answers1[20],
      'Oppositional_Behaviour_notes': _textControllers1[20].text,
      'Overactive_Behaviour': _answers1[21],
      'Overactive_Behaviour_notes': _textControllers1[21].text,
      'Physical_Aggression': _answers1[22],
      'Physical_Aggression_notes': _textControllers1[22].text,
      'Problems_With_Family': _answers1[23],
      'Problems_With_Family_notes': _textControllers1[23].text,
      'Self_Criticism': _answers1[24],
      'Self_Criticism_notes': _textControllers1[24].text,
      'Self_Injury_Evidence': _answers1[25],
      'Self_Injury_Evidence_notes': _textControllers1[25].text,
      'Self_Injury_Thoughts': _answers1[26],
      'Self_Injury_Thoughts_notes': _textControllers1[26].text,
      'Inappropriate_Sexualised_Behaviour': _answers1[27],
      'Inappropriate_Sexualised_Behaviour_notes': _textControllers1[27].text,
      'Disclosures_Hearing_Voices': _answers1[28],
      'Disclosures_Hearing_Voices_notes': _textControllers1[28].text,
      'Sleep_Problems': _answers1[29],
      'Sleep_Problems_notes': _textControllers1[29].text,
      'Somatising': _answers1[30],
      'Somatising_notes': _textControllers1[30].text,
      'Verbal_Aggression': _answers1[31],
      'Verbal_Aggression_notes': _textControllers1[31].text,
      'Withdrawal_From_Others': _answers1[32],
      'Withdrawal_From_Others_notes': _textControllers1[32].text,
      'Active_Listening': _answers2[0],
      'Active_Listening_notes': _textControllers2[0].text,
      'Anger_Management': _answers2[1],
      'Anger_Management_notes': _textControllers2[1].text,
      'Being_Respectful': _answers2[2],
      'Being_Respectful_notes': _textControllers2[2].text,
      'Being_Safe': _answers2[3],
      'Being_Safe_notes': _textControllers2[3].text,
      'Conflict_Management': _answers2[4],
      'Conflict_Management_notes': _textControllers2[4].text,
      'Cooperation': _answers2[5],
      'Cooperation_notes': _textControllers2[5].text,
      'Effective_Communication': _answers2[6],
      'Effective_Communication_notes': _textControllers2[6].text,
      'Following_Directions': _answers2[7],
      'Following_Directions_notes': _textControllers2[7].text,
      'Helping_Others': _answers2[8],
      'Helping_Others_notes': _textControllers2[8].text,
      'Increasing_Acceptance': _answers2[9],
      'Increasing_Acceptance_notes': _textControllers2[9].text,
      'Listening': _answers2[10],
      'Listening_notes': _textControllers2[10].text,
      'Participation': _answers2[11],
      'Participation_notes': _textControllers2[11].text,
      'Patience': _answers2[12],
      'Patience_notes': _textControllers2[12].text,
      'Peer_Resistance_Skills': _answers2[13],
      'Peer_Resistance_Skills_notes': _textControllers2[13].text,
      'Politeness_Manners': _answers2[14],
      'Politeness_Manners_notes': _textControllers2[14].text,
      'Positive_Interactions': _answers2[15],
      'Positive_Interactions_notes': _textControllers2[15].text,
      'Negative_Comments': _answers2[16],
      'Negative_Comments_notes': _textControllers2[16].text,
      'Understanding_Points': _answers2[17],
      'Understanding_Points_notes': _textControllers2[17].text,
      'Remaining_Task': _answers2[18],
      'Remaining_Task_notes': _textControllers2[18].text,
      'Sharing': _answers2[19],
      'Sharing_notes': _textControllers2[19].text,
      'Social_Problem_Solving': _answers2[20],
      'Social_Problem_Solving_notes': _textControllers2[20].text,
      'Taking_Turns': _answers2[21],
      'Taking_Turns_notes': _textControllers2[21].text,
      'behaviour_client_state': stateId,
      'behaviour_client_region': regionId,
      'behaviour_client_unit': unitId,
      'behaviour_admin_id': widget.id,
      'behaviour_created_by': widget.name
    };
    try {
      response = await dio.post(path: AppUrls.behaviourForm, data: params);
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
            showSnackBar(context, "Save Form Sucessfully");
            push(context, BehaviourLogList());
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

  void getLogDetail() async {
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
      "id": widget.logId,
    };
    try {
      response =
          await dio.post(path: AppUrls.getBehaviourLogDetail, data: params);
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
            finalResponse = responseData["data"][0];
            selectedClient =
                "${finalResponse["f_name"]}  ${finalResponse["l_name"]}";
            selectedHierarchy = "${finalResponse["state_name"]}";
            selectedUnit = "${finalResponse["unit_name"]}";
            selectedRegion = "${finalResponse["region_name"]}";
            String dateString = finalResponse['behaviour_created'];
            entryDate = DateTime.parse(dateString);
            _answers[0] = finalResponse['general_illness'];
            _textControllers[0].text = finalResponse["general_illness_notes"];
            if (_textControllers[0].text != "") {
              _showTextField[0] = true;
            }
            _answers[1] = finalResponse['Menstruation'];
            _textControllers[1].text = finalResponse["Menstruation_notes"];
            if (_textControllers[1].text != "") {
              _showTextField[1] = true;
            }
            _progressController.text = finalResponse["Behavipur_Weight"];

            _answers1[0] = finalResponse['abnormal_perceptions'];
            _textControllers1[0].text =
                finalResponse["abnormal_perceptions_notes"];
            if (_textControllers1[0].text != "") {
              _showTextField1[0] = true;
            }
            _answers1[1] = finalResponse['alcohol_use'];
            _textControllers1[1].text = finalResponse["alcohol_use_notes"];
            if (_textControllers1[1].text != "") {
              _showTextField1[1] = true;
            }
            _answers1[2] = finalResponse['antisocial_behaviour'];
            _textControllers1[2].text =
                finalResponse["antisocial_behaviour_notes"];
            if (_textControllers1[2].text != "") {
              _showTextField1[2] = true;
            }

            _answers1[3] = finalResponse['anxiety'];
            _textControllers1[3].text = finalResponse["anxiety_notes"];
            if (_textControllers1[3].text != "") {
              _showTextField1[3] = true;
            }
            _answers1[4] = finalResponse['binging_to_eat'];
            _textControllers1[4].text = finalResponse["binging_to_eat_notes"];
            if (_textControllers1[4].text != "") {
              _showTextField1[4] = true;
            }
            _answers1[5] = finalResponse['communication_issues'];
            _textControllers1[5].text =
                finalResponse["communication_issues_notes"];
            if (_textControllers1[5].text != "") {
              _showTextField1[5] = true;
            }
            _answers1[6] = finalResponse['Engage_Learning'];
            _textControllers1[6].text = finalResponse["Engage_Learning_notes"];
            if (_textControllers1[6].text != "") {
              _showTextField1[6] = true;
            }
            _answers1[7] = finalResponse['Engage_Independence_Skills'];
            _textControllers1[7].text =
                finalResponse["Engage_Independence_Skills_notes"];
            if (_textControllers1[7].text != "") {
              _showTextField1[7] = true;
            }
            _answers1[8] = finalResponse['Maintain_Personal_Self_Care'];
            _textControllers1[8].text =
                finalResponse["Maintain_Personal_Self_Care_notes"];
            if (_textControllers1[8].text != "") {
              _showTextField1[8] = true;
            }
            _answers1[9] = finalResponse['Self_Regulating_Emotions'];
            _textControllers1[9].text =
                finalResponse["Self_Regulating_Emotions_notes"];
            if (_textControllers1[9].text != "") {
              _showTextField1[9] = true;
            }
            _answers1[10] = finalResponse['Memory_Loss_notes'];
            _textControllers1[10].text = finalResponse["Memory_Loss_notes"];
            if (_textControllers1[10].text != "") {
              _showTextField1[10] = true;
            }
            _answers1[11] = finalResponse['Distress'];
            _textControllers1[11].text = finalResponse["Distress_notes"];
            if (_textControllers1[11].text != "") {
              _showTextField1[11] = true;
            }
            _answers1[12] = finalResponse['Fears_Phobias'];
            _textControllers1[12].text = finalResponse["Fears_Phobias_notes"];
            if (_textControllers1[12].text != "") {
              _showTextField1[12] = true;
            }
            _answers1[13] = finalResponse['Impulsive_Behaviour'];
            _textControllers1[13].text =
                finalResponse["Impulsive_Behaviour_notes"];
            if (_textControllers1[13].text != "") {
              _showTextField1[13] = true;
            }
            _answers1[14] = finalResponse['Lack_Concentration'];
            _textControllers1[14].text =
                finalResponse["Lack_Concentration_notes"];
            if (_textControllers1[14].text != "") {
              _showTextField1[14] = true;
            }
            _answers1[15] = finalResponse['Indiscriminate_Disclosures'];
            _textControllers1[15].text =
                finalResponse["Indiscriminate_Disclosures_notes"];
            if (_textControllers1[15].text != "") {
              _showTextField1[15] = true;
            }
            _answers1[16] = finalResponse['Loss_of_Interest'];
            _textControllers1[16].text =
                finalResponse["Loss_of_Interest_notes"];
            if (_textControllers1[16].text != "") {
              _showTextField1[16] = true;
            }
            _answers1[17] = finalResponse['Mimicking_Others_Behaviours'];
            _textControllers1[17].text =
                finalResponse["Mimicking_Others_Behaviours_notes"];
            if (_textControllers1[17].text != "") {
              _showTextField1[17] = true;
            }
            _answers1[18] = finalResponse['Obsessions_Compulsions'];
            _textControllers1[18].text =
                finalResponse["Obsessions_Compulsions_notes"];
            if (_textControllers1[18].text != "") {
              _showTextField1[18] = true;
            }
            _answers1[19] = finalResponse['Bizarre_Behaviour'];
            _textControllers1[19].text =
                finalResponse["Bizarre_Behaviour_notes"];
            if (_textControllers1[19].text != "") {
              _showTextField1[19] = true;
            }
            _answers1[20] = finalResponse['Oppositional_Behaviour'];
            _textControllers1[20].text =
                finalResponse["Oppositional_Behaviour_notes"];
            if (_textControllers1[20].text != "") {
              _showTextField1[20] = true;
            }
            _answers1[21] = finalResponse['Overactive_Behaviour'];
            _textControllers1[21].text =
                finalResponse["Overactive_Behaviour_notes"];
            if (_textControllers1[21].text != "") {
              _showTextField1[21] = true;
            }
            _answers1[22] = finalResponse['Physical_Aggression'];
            _textControllers1[22].text =
                finalResponse["Physical_Aggression_notes"];
            if (_textControllers1[22].text != "") {
              _showTextField1[22] = true;
            }
            _answers1[23] = finalResponse['Problems_With_Family'];
            _textControllers1[23].text =
                finalResponse["Problems_With_Family_notes"];
            if (_textControllers1[23].text != "") {
              _showTextField1[23] = true;
            }
            _answers1[24] = finalResponse['Self_Criticism'];
            _textControllers1[24].text = finalResponse["Self_Criticism_notes"];
            if (_textControllers1[24].text != "") {
              _showTextField1[24] = true;
            }
            _answers1[25] = finalResponse['Self_Injury_Evidence'];
            _textControllers1[25].text =
                finalResponse["Self_Injury_Evidence_notes"];
            if (_textControllers1[25].text != "") {
              _showTextField1[25] = true;
            }
            _answers1[26] = finalResponse['Self_Injury_Thoughts'];
            _textControllers1[26].text =
                finalResponse["Self_Injury_Thoughts_notes"];
            if (_textControllers1[26].text != "") {
              _showTextField1[26] = true;
            }
            _answers1[27] = finalResponse['Inappropriate_Sexualised_Behaviour'];
            _textControllers1[3].text =
                finalResponse["Inappropriate_Sexualised_Behaviour_notes"];
            if (_textControllers1[3].text != "") {
              _showTextField1[3] = true;
            }
            _answers1[28] = finalResponse['Disclosures_Hearing_Voices'];
            _textControllers1[28].text =
                finalResponse["Disclosures_Hearing_Voices_notes"];
            if (_textControllers1[28].text != "") {
              _showTextField1[28] = true;
            }
            _answers1[29] = finalResponse['Sleep_Problems'];
            _textControllers1[29].text = finalResponse["Sleep_Problems_notes"];
            if (_textControllers1[29].text != "") {
              _showTextField1[29] = true;
            }
            _answers1[30] = finalResponse['Somatising'];
            _textControllers1[30].text = finalResponse["Somatising_notes"];
            if (_textControllers1[30].text != "") {
              _showTextField1[30] = true;
            }
            _answers1[31] = finalResponse['Verbal_Aggression'];
            _textControllers1[31].text =
                finalResponse["Verbal_Aggression_notes"];
            if (_textControllers1[31].text != "") {
              _showTextField1[31] = true;
            }
            _answers1[32] = finalResponse['Withdrawal_From_Others'];
            _textControllers1[32].text =
                finalResponse["Withdrawal_From_Others_notes"];
            if (_textControllers1[32].text != "") {
              _showTextField1[32] = true;
            }
            _answers2[0] = finalResponse['Active_Listening'];
            _textControllers2[0].text = finalResponse["Active_Listening_notes"];
            if (_textControllers2[0].text != "") {
              _showTextField2[0] = true;
            }
            _answers2[1] = finalResponse['Anger_Management'];
            _textControllers2[1].text = finalResponse["Anger_Management_notes"];
            if (_textControllers2[1].text != "") {
              _showTextField2[1] = true;
            }
            _answers2[2] = finalResponse['Being_Respectful'];
            _textControllers2[2].text = finalResponse["Being_Respectful_notes"];
            if (_textControllers2[2].text != "") {
              _showTextField2[2] = true;
            }
            _answers2[3] = finalResponse['Being_Safe'];
            _textControllers2[3].text = finalResponse["Being_Safe_notes"];
            if (_textControllers2[3].text != "") {
              _showTextField2[3] = true;
            }
            _answers2[4] = finalResponse['Conflict_Management'];
            _textControllers2[4].text =
                finalResponse["Conflict_Management_notes"];
            if (_textControllers2[4].text != "") {
              _showTextField2[4] = true;
            }
            _answers2[5] = finalResponse['Cooperation'];
            _textControllers2[5].text = finalResponse["Cooperation_notes"];
            if (_textControllers2[5].text != "") {
              _showTextField2[5] = true;
            }
            _answers2[6] = finalResponse['Effective_Communication'];
            _textControllers2[6].text =
                finalResponse["Effective_Communication_notes"];
            if (_textControllers2[6].text != "") {
              _showTextField2[6] = true;
            }
            _answers2[7] = finalResponse['Following_Directions'];
            _textControllers2[7].text =
                finalResponse["Following_Directions_notes"];
            if (_textControllers2[7].text != "") {
              _showTextField2[7] = true;
            }
            _answers2[8] = finalResponse['Helping_Others'];
            _textControllers2[8].text = finalResponse["Helping_Others_notes"];
            if (_textControllers2[8].text != "") {
              _showTextField2[8] = true;
            }
            _answers2[9] = finalResponse['Increasing_Acceptance'];
            _textControllers2[9].text =
                finalResponse["Increasing_Acceptance_notes"];
            if (_textControllers2[9].text != "") {
              _showTextField2[9] = true;
            }
            _answers2[10] = finalResponse['Listening'];
            _textControllers2[10].text = finalResponse["Listening_notes"];
            if (_textControllers2[10].text != "") {
              _showTextField2[10] = true;
            }
            _answers2[11] = finalResponse['Participation'];
            _textControllers2[11].text = finalResponse["Participation_notes"];
            if (_textControllers2[11].text != "") {
              _showTextField2[11] = true;
            }
            _answers2[12] = finalResponse['Patience'];
            _textControllers2[12].text = finalResponse["Patience_notes"];
            if (_textControllers2[12].text != "") {
              _showTextField2[12] = true;
            }
            _answers2[13] = finalResponse['Peer_Resistance_Skills'];
            _textControllers2[13].text =
                finalResponse["Peer_Resistance_Skills_notes"];
            if (_textControllers2[13].text != "") {
              _showTextField2[13] = true;
            }
            _answers2[14] = finalResponse['Politeness_Manners'];
            _textControllers2[14].text =
                finalResponse["Politeness_Manners_notes"];
            if (_textControllers2[14].text != "") {
              _showTextField2[14] = true;
            }
            _answers2[15] = finalResponse['Positive_Interactions'];
            _textControllers2[15].text =
                finalResponse["Positive_Interactions_notes"];
            if (_textControllers2[15].text != "") {
              _showTextField2[15] = true;
            }
            _answers2[16] = finalResponse['Negative_Comments'];
            _textControllers2[16].text =
                finalResponse["Negative_Comments_notes"];
            if (_textControllers2[16].text != "") {
              _showTextField2[16] = true;
            }
            _answers2[17] = finalResponse['Understanding_Points'];
            _textControllers2[17].text =
                finalResponse["Understanding_Points_notes"];
            if (_textControllers2[17].text != "") {
              _showTextField2[17] = true;
            }
            _answers2[18] = finalResponse['Remaining_Task'];
            _textControllers2[18].text = finalResponse["Remaining_Task_notes"];
            if (_textControllers2[18].text != "") {
              _showTextField2[18] = true;
            }
            _answers2[19] = finalResponse['Sharing'];
            _textControllers2[19].text = finalResponse["Sharing_notes"];
            if (_textControllers2[19].text != "") {
              _showTextField2[19] = true;
            }
            _answers2[20] = finalResponse['Social_Problem_Solving'];
            _textControllers2[20].text =
                finalResponse["Social_Problem_Solving_notes"];
            if (_textControllers2[20].text != "") {
              _showTextField2[20] = true;
            }
            _answers2[21] = finalResponse['Taking_Turns'];
            _textControllers2[21].text = finalResponse["Taking_Turns_notes"];
            if (_textControllers2[21].text != "") {
              _showTextField2[21] = true;
            }

            print("vjdjjevwjvjwb$finalResponse");
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

  void updateBehaviourForm() async {
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
      "client_behaviour_id": widget.logId,
      'behaviour_client_id': clientId,
      'behaviour_date': entryDate,
      'general_illness': _answers[0],
      'general_illness_notes': Null,
      'Menstruation': _answers[1],
      'Menstruation_notes': Null,
      'Behavipur_Weight': _progressController.text,
      'abnormal_perceptions': _answers1[0],
      'abnormal_perceptions_notes': Null,
      'alcohol_use': _answers1[1],
      'alcohol_use_notes': Null,
      'antisocial_behaviour': _answers1[2],
      'antisocial_behaviour_notes': Null,
      'anxiety': _answers1[3],
      'anxiety_notes': Null,
      'binging_to_eat': _answers1[4],
      'binging_to_eat_notes': Null,
      'communication_issues': _answers1[5],
      'communication_issues_notes': Null,
      'Engage_Learning': _answers1[6],
      'Engage_Learning_notes': Null,
      'Engage_Independence_Skills': _answers1[7],
      'Engage_Independence_Skills_notes': Null,
      'Maintain_Personal_Self_Care': _answers1[8],
      'Maintain_Personal_Self_Care_notes': Null,
      'Self_Regulating_Emotions': _answers1[9],
      'Self_Regulating_Emotions_notes': Null,
      'Memory_Loss': _answers1[10],
      'Memory_Loss_notes': Null,
      'Distress': _answers1[11],
      'Distress_notes': Null,
      'Fears_Phobias': _answers1[12],
      'Fears_Phobias_notes': Null,
      'Impulsive_Behaviour': _answers1[13],
      'Impulsive_Behaviour_notes': Null,
      'Lack_Concentration': _answers1[14],
      'Lack_Concentration_notes': Null,
      'Indiscriminate_Disclosures': _answers1[15],
      'Indiscriminate_Disclosures_notes': Null,
      'Loss_of_Interest': _answers1[16],
      'Loss_of_Interest_notes': Null,
      'Mimicking_Others_Behaviours': _answers1[17],
      'Mimicking_Others_Behaviours_notes': Null,
      'Obsessions_Compulsions': _answers1[18],
      'Obsessions_Compulsions_notes': Null,
      'Bizarre_Behaviour': _answers1[19],
      'Bizarre_Behaviour_notes': Null,
      'Oppositional_Behaviour': _answers1[20],
      'Oppositional_Behaviour_notes': Null,
      'Overactive_Behaviour': _answers1[21],
      'Overactive_Behaviour_notes': Null,
      'Physical_Aggression': _answers1[22],
      'Physical_Aggression_notes': Null,
      'Problems_With_Family': _answers1[23],
      'Problems_With_Family_notes': Null,
      'Self_Criticism': _answers1[24],
      'Self_Criticism_notes': Null,
      'Self_Injury_Evidence': _answers1[25],
      'Self_Injury_Evidence_notes': Null,
      'Self_Injury_Thoughts': _answers1[26],
      'Self_Injury_Thoughts_notes': Null,
      'Inappropriate_Sexualised_Behaviour': _answers1[27],
      'Inappropriate_Sexualised_Behaviour_notes': Null,
      'Disclosures_Hearing_Voices': _answers1[28],
      'Disclosures_Hearing_Voices_notes': Null,
      'Sleep_Problems': _answers1[29],
      'Sleep_Problems_notes': Null,
      'Somatising': _answers1[30],
      'Somatising_notes': Null,
      'Verbal_Aggression': _answers1[31],
      'Verbal_Aggression_notes': Null,
      'Withdrawal_From_Others': _answers1[32],
      'Withdrawal_From_Others_notes': Null,
      'Active_Listening': _answers2[0],
      'Active_Listening_notes': Null,
      'Anger_Management': _answers2[1],
      'Anger_Management_notes': Null,
      'Being_Respectful': _answers2[2],
      'Being_Respectful_notes': Null,
      'Being_Safe': _answers2[3],
      'Being_Safe_notes': Null,
      'Conflict_Management': _answers2[4],
      'Conflict_Management_notes': Null,
      'Cooperation': _answers2[5],
      'Cooperation_notes': Null,
      'Effective_Communication': _answers2[6],
      'Effective_Communication_notes': Null,
      'Following_Directions': _answers2[7],
      'Following_Directions_notes': Null,
      'Helping_Others': _answers2[8],
      'Helping_Others_notes': Null,
      'Increasing_Acceptance': _answers2[9],
      'Increasing_Acceptance_notes': Null,
      'Listening': _answers2[10],
      'Listening_notes': Null,
      'Participation': _answers2[11],
      'Participation_notes': Null,
      'Patience': _answers2[12],
      'Patience_notes': Null,
      'Peer_Resistance_Skills': _answers2[13],
      'Peer_Resistance_Skills_notes': Null,
      'Politeness_Manners': _answers2[14],
      'Politeness_Manners_notes': Null,
      'Positive_Interactions': _answers2[15],
      'Positive_Interactions_notes': Null,
      'Negative_Comments': _answers2[16],
      'Negative_Comments_notes': Null,
      'Understanding_Points': _answers2[17],
      'Understanding_Points_notes': Null,
      'Remaining_Task': _answers2[18],
      'Remaining_Task_notes': Null,
      'Sharing': _answers2[19],
      'Sharing_notes': Null,
      'Social_Problem_Solving': _answers2[20],
      'Social_Problem_Solving_notes': Null,
      'Taking_Turns': _answers2[21],
      'Taking_Turns_notes': Null,
      'behaviour_client_state': stateId,
      'behaviour_client_region': regionId,
      'behaviour_client_unit': unitId,
      'behaviour_admin_id': widget.id,
      'behaviour_created_by': widget.name
    };
    try {
      response =
          await dio.post(path: AppUrls.UpdateBehaviourForm, data: params);
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
            showSnackBar(context, "Update Form Sucessfully");

            getLogDetail();
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
