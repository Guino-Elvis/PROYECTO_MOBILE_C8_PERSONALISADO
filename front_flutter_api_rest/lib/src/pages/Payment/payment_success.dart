import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pago Exitoso")),
      body: Center(
        child:
            Text("¡Gracias por tu compra! El pago se completó exitosamente."),
      ),
    );
  }
}
