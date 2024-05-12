import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:active_link/View/HomeScreen/home_screen.dart';
import 'package:active_link/View/ProfileScreen/profile_screen.dart';
import 'package:active_link/View/ShiftListScreen/shift_screen.dart';
import 'package:flutter/material.dart';

class BottomNavView extends StatefulWidget {
  final islogin;
  const BottomNavView({super.key, this.islogin});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: [ShiftListScreen(), MyHomePage(), ProfileScreen()][_currentIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFB854F2),
                Color.fromARGB(168, 197, 138, 218),
              ], // Your gradient colors
            ),
          ),
          width: MediaQuery.of(context).size.width,
          height: 71, //
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customColumn(
                    icon: "assets/images/Shift List.png",
                    txt: "Shift List ",
                    ontap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    }),
                customColumn(
                    icon: "assets/images/Home.png",
                    txt: " Home ",
                    ontap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    }),
                customColumn(
                    icon:"assets/images/Profile.png",
                    txt: "Profile",
                    ontap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    }),
              ],
            ),
          ),
        ));
  }

  Widget customColumn({icon, txt, ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        children: [
          Image.asset("$icon",height: 30,width: 30,),
          const SizedBox(
            height: 5,
          ),
          AppText.appText("$txt", textColor: AppTheme.whiteColor)
        ],
      ),
    );
  }
}
