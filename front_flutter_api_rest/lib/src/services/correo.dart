import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/cache/ClienteCacheModel.dart';
import 'package:front_flutter_api_rest/src/cache/ProductoCacheModel.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EnviarCorreoPage extends StatelessWidget {
  final ClienteCacheModel? cliente;
  final List<ProductoCacheModel> carrito;
  final double? total;

  // Constructor para recibir los datos
  EnviarCorreoPage({
    required this.cliente,
    required this.carrito,
    required this.total,
  });

  // Función para crear el cuerpo del correo con los detalles del cliente y los productos
  String _crearCuerpoCorreo() {
    String cuerpo =
        "🌟 ¡Hola ${cliente!.name}! Tu pedido está casi listo 🌟\n\n";
    cuerpo += "🛍️ Productos en tu carrito:\n\n";

    for (var producto in carrito) {
      cuerpo += "🛒 ${producto.nombre}\n";
      cuerpo += "🔢 Cantidad: ${producto.cantidad}\n";
      cuerpo += "💲 Precio unitario: \$${producto.precio}\n";
      cuerpo +=
          "💸 Subtotal: \$${(double.parse(producto.precio) * producto.cantidad).toStringAsFixed(2)}\n\n";
    }

    cuerpo += "----------------------------------\n";
    cuerpo += "📊 Total de la compra: \$${total!.toStringAsFixed(2)}\n\n";

    cuerpo += "----------------------------------\n";
    cuerpo += "ℹ️ Detalles de tu cuenta:\n";
    cuerpo += "✉️ Email: ${cliente!.email}\n";
    cuerpo += "📱 Teléfono: ${cliente!.phone}\n";
    cuerpo += "🏠 Dirección: ${cliente!.direccion}\n\n";

    cuerpo += "----------------------------------\n";
    cuerpo += "🎉 ¡Gracias por tu elección! 🎉\n";
    cuerpo +=
        "📩 Si tienes alguna duda o necesitas más información, contáctanos a empresa@gmail.com\n";
    cuerpo += "\n¡Esperamos tu confirmación para procesar tu pedido! 😊";

    return cuerpo;
  }

  // Función para enviar el correo
  void _enviarCorreo(String cuerpo) async {
    // Configura el servidor SMTP de Gmail
    final smtpServer = gmail('ginoyujra38@gmail.com', 'nyspgkyjihitrtck');

    // Crea el mensaje
    final message = Message()
      ..from = Address('ginoyujra38@gmail.com', '${cliente!.name}')
      ..recipients.add(cliente!.email!)
      ..subject = 'Detalles de tu Pedido'
      ..text = cuerpo;

    try {
      // Envía el correo
      final sendReport = await send(message, smtpServer);
      print('Correo enviado: ' + sendReport.toString());
    } catch (e) {
      print('Error al enviar el correo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String cuerpoCorreo = _crearCuerpoCorreo();

    return Scaffold(
      appBar: AppBar(title: Text("Enviar Correo Electrónico")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _enviarCorreo(
                cuerpoCorreo); // Enviar el correo cuando se presione el botón
          },
          child: Text("Enviar Productos por Correo Electrónico"),
        ),
      ),
    );
  }
}
