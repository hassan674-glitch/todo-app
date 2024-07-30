import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/responsive.dart';
import 'package:todo_app/screens/dashboard/dashboard_screen.dart';
import 'package:todo_app/utils/colors.dart';

import '../../phone_dashboard/phone_ui.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.dashBoardColor,
      child: ListView(
        children: [
          DrawerHeader(
           child:  Image.asset("assets/images/mainPic.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/svgs/dashboard.svg",
            press: () {
              if(Responsive.isMobile(context))
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneUi()));
            },
          ),
          DrawerListTile(title: "Share", svgSrc:"assets/svgs/share.svg", press: (){}),
          DrawerListTile(title: "Privacy Policy", svgSrc:"assets/svgs/lock.svg", press: (){}),
          DrawerListTile(title: "Setting", svgSrc:"assets/svgs/settings.svg", press: (){}),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  });


  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(25)
      ),
      margin: EdgeInsets.all(10),
      child:InkWell(
        onTap: (){},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: defaultPadding*2,
            ),
            SvgPicture.asset(svgSrc
            ,
              color: Colors.black,
            ),
            SizedBox(width: defaultPadding,),
            Text(title,style: TextStyle(
              color: Colors.black,
                fontWeight: FontWeight.bold
            ),),
          ],
        ),
      )
    );
  }
}
