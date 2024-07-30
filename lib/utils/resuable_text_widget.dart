import 'package:flutter/material.dart';

class ResuableTextWidgetWidget extends StatelessWidget {
  final String bookTitle;
  final Color? color;
  final double? size;
  late FontWeight? fontWeight;


  ResuableTextWidgetWidget({super.key, required this.bookTitle,  this.color, this.size,this.fontWeight});

  String getShortenedTitle(String title) {
    List<String> words = title.split(' ');
    if (words.length > 2) {
      return '${words[0]} ${words[1]}...';
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Text(
        getShortenedTitle(bookTitle),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: color??Colors.black,
            fontSize: size??12,
            fontWeight: fontWeight??FontWeight.normal,
            ),
      ),
    );
  }
}