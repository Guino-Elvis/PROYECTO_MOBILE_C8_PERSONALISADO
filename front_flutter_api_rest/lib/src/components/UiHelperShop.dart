import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

class UiHelperShop {
  static ShowAlertDialog(BuildContext context,
      {String title = '',
      required String message,
      Widget? itemIcon,
      String? navigateTo,
      String buttonTitle2 = 'Ver recibo electrónico'}) {
    OneContext().showDialog(builder: (ctx) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16.0),
              child: itemIcon,
            ),
            SizedBox(height: 16),
            Text(
              'Order Successful',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFF4CAF50)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                if (navigateTo != null && navigateTo.isNotEmpty) {
                  OneContext().pushNamed(navigateTo);
                }
              },
              child: Text(
                buttonTitle2,
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
