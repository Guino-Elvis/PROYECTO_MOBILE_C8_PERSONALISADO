import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/controller/Payment/PayPalPayment.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pago")),
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 1),
            () => true), // Simulación de una operación asincrónica
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error"));
          } else {
            return Column(
              children: [
                Center(
                  child: Text("Soy pago"),
                ),
                PayPalButton(),
              ],
            );
          }
        },
      ),
    );
  }
}
