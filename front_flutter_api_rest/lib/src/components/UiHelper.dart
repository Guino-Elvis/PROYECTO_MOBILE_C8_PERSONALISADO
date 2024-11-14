// lib/utils/ui_helper.dart

import 'package:flutter/material.dart';

class UiHelper {
  // Método estático para mostrar el diálogo de alerta
  static void showAlertDialog(
      BuildContext context, String message, String description,
      {String title = 'Error'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
