import 'package:flutter/material.dart';

void showCustomSnackbar({
  required BuildContext context,
  required String message,
  required VoidCallback onUndoPressed,
  required VoidCallback onCustomActionPressed,
}) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.white),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
    backgroundColor: Colors.black26,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    duration: Duration(seconds: 4),
    action: SnackBarAction(
      label: 'UNDO',
      textColor: Colors.yellow,
      onPressed: onUndoPressed,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((reason) {
    if (reason == SnackBarClosedReason.action) {
      onCustomActionPressed();
    }
  });
}
