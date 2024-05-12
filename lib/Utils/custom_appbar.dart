
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/widgets/others/app_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final title;
  final trailing;
  final img;
  final click;
  final   onTap;
  final double preferredHeight = 70.0;

  const CustomAppBar(
      {super.key, this.title, this.trailing, this.img, this.click,  this.onTap});

  @override
  Widget build(BuildContext context) {
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
            click == false
                ? SizedBox.shrink()
                : InkWell(
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
            AppText.appText("$title",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: AppTheme.whiteColor),
            trailing == true
                ? GestureDetector(
                  onTap: onTap,
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(image: AssetImage("$img"),)),
                    ),
                )
                : const SizedBox(
                    height: 30,
                    width: 30,
                  )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}
