
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/utils/resuable_text_widget.dart';

import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../responsive.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [

              if (!Responsive.isMobile(context))
                ResuableTextWidgetWidget(bookTitle: "Dashboard",
                  size: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),

            ],
          ),
        ],
      ),
    );
  }
}


