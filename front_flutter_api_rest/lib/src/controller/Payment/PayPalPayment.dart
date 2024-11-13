import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:front_flutter_api_rest/src/services/payKey.dart';
import 'package:uni_links/uni_links.dart';

class PayPalButton extends StatelessWidget {
  final String clientId = PaypalKey.YOUR_PAYPAL_CLIENT_ID;
  final String secret = PaypalKey.YOUR_PAYPAL_SECRET;

  // Crear el pago y redirigir al usuario a PayPal
  Future<void> createPayPalPayment(BuildContext context) async {
    // Datos ficticios del carrito (simulación)
    List<Map<String, dynamic>> cartDetails = [
      {'price': 20.0, 'quantity': 2}, // Producto 1: 2 unidades de $20
      {'price': 15.0, 'quantity': 1}, // Producto 2: 1 unidad de $15
    ];

    // Total ficticio en USD (sin tasas de cambio reales)
    double totalInUSD = 20.0 * 2 + 15.0 * 1;

    final paymentData = {
      'intent': 'sale',
      'payer': {'payment_method': 'paypal'},
      'transactions': [
        {
          'amount': {
            'total': totalInUSD.toString(),
            'currency': 'USD',
          },
          'description': 'Compra de productos'
        }
      ],
      'redirect_urls': {
        'return_url':
            'yourapp://paypal_return', // Redirige después de la aprobación
        'cancel_url':
            'yourapp://paypal_cancel', // Redirige si el pago es cancelado
      }
    };

    try {
      final response = await http.post(
        Uri.parse('https://api.sandbox.paypal.com/v1/payments/payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ' + base64Encode(utf8.encode('$clientId:$secret')),
        },
        body: jsonEncode(paymentData),
      );

      if (response.statusCode == 201) {
        final payment = jsonDecode(response.body);
        final approvalLink = payment['links'].firstWhere(
          (link) => link['rel'] == 'approval_url',
          orElse: () => null,
        )['href'];

        if (approvalLink != null) {
          // Redirigir al usuario a la pantalla de aprobación de PayPal
          Navigator.pushNamed(context, '/paymentApproval',
              arguments: approvalLink);
        } else {
          print("Error al obtener el enlace de aprobación");
        }
      } else {
        print("Error al crear el pago: ${response.body}");
      }
    } catch (e) {
      print("Error al crear el pago: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pago con PayPal'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            createPayPalPayment(
                context); // Iniciar el pago cuando el botón es presionado
          },
          child: Text('Pagar con PayPal'),
        ),
      ),
    );
  }
}
