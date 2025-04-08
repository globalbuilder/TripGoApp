import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Displays an exit confirmation dialog and returns true if the user confirms exit.
Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return (await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Exit App"),
      content: const Text("Do you really want to exit the app?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Exit"),
        ),
      ],
    ),
  )) ??
      false;
}

/// If the user confirmed exit, close the app.
void exitApp() {
  SystemNavigator.pop();
}
