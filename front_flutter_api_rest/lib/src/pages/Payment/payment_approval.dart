import 'package:uni_links/uni_links.dart';
import 'package:flutter/material.dart';

class PaymentApprovalScreen extends StatefulWidget {
  @override
  _PaymentApprovalScreenState createState() => _PaymentApprovalScreenState();
}

class _PaymentApprovalScreenState extends State<PaymentApprovalScreen> {
  String _message = "Esperando que PayPal nos redirija...";

  @override
  void initState() {
    super.initState();
    _initUniLinks();
  }

  // Inicialización de enlaces profundos
  void _initUniLinks() async {
    try {
      // Obtener el enlace inicial si existe
      Uri? initialUri = await getInitialUri();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }

      // Escuchar los enlaces profundos, pero como el linkStream emite String, lo convertimos a Uri
      linkStream.listen((String? uriString) {
        if (uriString != null) {
          Uri uri = Uri.parse(uriString); // Convertir el String a Uri
          _handleDeepLink(uri);
        }
      });
    } catch (e) {
      print("Error al obtener el enlace: $e");
    }
  }

  // Manejar el enlace profundo
  void _handleDeepLink(Uri uri) {
    if (uri.toString().contains('paypal_return')) {
      // El usuario aprobó el pago
      setState(() {
        _message = "Pago aprobado.";
      });
      // Aquí puedes ejecutar el pago con `executePayment`
    } else if (uri.toString().contains('paypal_cancel')) {
      // El usuario canceló el pago
      setState(() {
        _message = "Pago cancelado.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aprobación de Pago')),
      body: Center(child: Text(_message)),
    );
  }
}
