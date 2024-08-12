
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/screens/phone_dashboard/phone_ui.dart';
import 'package:todo_app/utils/resuable_text_widget.dart';
import 'package:todo_app/utils/colors.dart';

import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import '../dashboard/dashboard_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainScreenolor,
      appBar: AppBar(
        title: Text("Books And Reviews",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset("assets/images/profile_pic.png"),
          ),
          if(!Responsive.isMobile(context))
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("Welcome Admin",style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold
                    ),),

                  ),
                 
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text("Admin",style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                    ),),
              )
            ],
          )
        ],
        backgroundColor: AppColors.AppBarColor,
      ),
       key: context.read<MenuAppController>().scaffoldKey,
      drawer: Responsive.isDesktop(context)?null:SideMenu(),
      body: SafeArea(
        child:
            // if(Responsive.isMobile(context))

            Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              // We want this side menu only for large screen
              if (Responsive.isDesktop(context))
                Expanded(
                  // default flex = 1
                  // and it takes 1/6 part of the screen
                  child: SideMenu(),
                ),

              if(Responsive.isMobile(context))
                Expanded(child: PhoneUi()),
              if(Responsive.isTablet(context))
                Expanded(child: DashboardScreen()),
              if(Responsive.isDesktop(context))
              Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: DashboardScreen(),
              ),
            ],
          ),


      ),
    );
  }

}

