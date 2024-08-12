import 'package:flutter/material.dart';

void showCustomSnackbar({
  required BuildContext context,
  required String message,
  required VoidCallback onUndoPressed,
  required VoidCallback onCustomActionPressed,
}) {
  final snackBar = SnackBar(
    content: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.black,),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    duration: Duration(seconds: 4),
    action: SnackBarAction(
      label: 'UNDO',
      textColor:Colors.black,
      onPressed: onUndoPressed,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((reason) {
    if (reason == SnackBarClosedReason.action) {
      onCustomActionPressed();
    }
  });
}
