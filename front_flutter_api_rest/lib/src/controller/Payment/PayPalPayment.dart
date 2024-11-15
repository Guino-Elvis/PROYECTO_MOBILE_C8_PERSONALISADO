import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:front_flutter_api_rest/src/cache/ClienteCacheModel.dart';
import 'package:front_flutter_api_rest/src/cache/ProductoCacheModel.dart';
import 'package:front_flutter_api_rest/src/components/UiHelper.dart';
import 'package:front_flutter_api_rest/src/controller/clienteController.dart';
import 'package:front_flutter_api_rest/src/controller/voucherController.dart';
import 'package:front_flutter_api_rest/src/controller/voucherDetailController.dart';
import 'package:front_flutter_api_rest/src/model/clienteModel.dart';
import 'package:front_flutter_api_rest/src/model/voucherDetailModel.dart';
import 'package:front_flutter_api_rest/src/model/voucherModel.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:front_flutter_api_rest/src/services/shoping/carrito.dart';
import 'package:front_flutter_api_rest/src/services/shoping/cliente.dart';
import 'package:front_flutter_api_rest/src/services/shoping/payKey.dart';
import 'package:intl/intl.dart';

class PayPalButton extends StatefulWidget {
  final ClienteCacheModel? cliente;
  final double? total;

  PayPalButton({required this.cliente, this.total});

  @override
  State<PayPalButton> createState() => _PayPalButtonState();
}

class _PayPalButtonState extends State<PayPalButton> {
  final String clientId = PaypalKey.YOUR_PAYPAL_CLIENT_ID;

  final String secret = PaypalKey.YOUR_PAYPAL_SECRET;

  final String retorno = PaypalKey.returnURL;

  final String cancelar = PaypalKey.cancelURL;

  ClienteController clienteController = ClienteController();

  VoucherController voucherController = VoucherController();

  VoucherDetailController voucherDetailController = VoucherDetailController();

  final CartService cartService = CartService();

  final ClienteService clienteService = ClienteService();

  Future<List<ProductoCacheModel>> getCartItems() async {
    return cartService.getCartItems();
  }

  // Función principal para manejar la creación secuencial
  Future<void> _procesarPago() async {
    // Primero se crea el cliente
    final clienteCreado = await _crearCliente();
    if (clienteCreado != null) {
      // Si el cliente fue creado correctamente, se crea el voucher
      final voucherCreado = await _crearVoucher(clienteCreado);
      if (voucherCreado != null) {
        // Si el voucher fue creado correctamente, se crean los voucher details
        await _crearVoucherDetail(voucherCreado);

        // Limpiar el carrito después de procesar el pago
        cartService.limpiarCarrito(); // Limpia el carrito al finalizar
        clienteService.limpiarCliente();
      } else {
        print('Error al crear el voucher');
      }
    } else {
      print('Error al crear el cliente');
    }
  }

  Future<ClienteModel?> _crearCliente() async {
    final nuevoCliente = ClienteModel(
      email: widget.cliente?.email ?? 'no hay email',
      phone: widget.cliente?.phone ?? 'no hay phone',
      name: widget.cliente?.name ?? 'no hay name',
      paterno: widget.cliente?.paterno ?? 'no hay paterno',
      materno: widget.cliente?.materno ?? 'no hay materno',
      tdocumento: widget.cliente?.tdocumento ?? 'no hay tdocumento',
      direccion: widget.cliente?.direccion ?? 'no hay direccion',
      postal: widget.cliente?.postal ?? 'no hay postal',
      tdatos: widget.cliente?.tdatos ?? 'no hay tdatos',
    );

    try {
      final response = await clienteController.crearCliente(nuevoCliente);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Cliente creado con éxito');
        return ClienteModel.fromJson(json.decode(response.body));
      } else {
        print('Error al crear el cliente: ${response.body}');
        return null; // Retornamos null si hubo un error
      }
    } catch (e) {
      print('Error al crear el cliente: $e');
      return null;
    }
  }

  Future<VoucherModel?> _crearVoucher(ClienteModel clienteCreado) async {
    String fechaHoyString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime fechaHoy = DateTime.parse(fechaHoyString);

    final nuevoVoucher = VoucherModel(
      tipo: 'TICKET DE COMPRA',
      numero: 'T000001',
      fecha: fechaHoy,
      total: widget.total,
      status: 'PA',
      metodo_pago: 'paypal',
      cliente: {
        'id': clienteCreado.id.toString(),
      },
    );

    try {
      final response = await voucherController.crearVourcher(nuevoVoucher);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Voucher creado con éxito');
        return VoucherModel.fromJson(json.decode(response.body));
      } else {
        print('Error al crear el voucher: ${response.body}');
        return null; // Retornamos null si hubo un error
      }
    } catch (e) {
      print('Error al crear el voucher: $e');
      return null;
    }
  }

  Future<void> _crearVoucherDetail(VoucherModel voucherCreado) async {
    List<ProductoCacheModel> cartItems = await getCartItems();

    for (var product in cartItems) {
      final nuevoVoucherDetail = VoucherDetailModel(
        cantidad: product.cantidad.toString(),
        descripcion: product.nombre,
        punitario: product.precio,
        importe: product.precio * product.cantidad,
        voucher: {
          'id': voucherCreado.id.toString(),
        },
      );

      try {
        final response = await voucherDetailController
            .crearVoucherDetail(nuevoVoucherDetail);
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('VoucherDetail creado con éxito');
        } else {
          print('Error al crear el VoucherDetail: ${response.body}');
        }
      } catch (e) {
        print('Error al crear el VoucherDetail: $e');
      }
    }
  }

  Future<void> removeItem(int id) async {
    await clienteService.eliminarCliente(id);
    print("Cliente con id $id eliminado");
    Navigator.pushNamed(context, AppRoutes.carritoRoute);
    setState(() {
      print("Cliente con id $id eliminado");
    });
  }

  String totalAmount = '1.99';
  String subTotalAmount = '1.99';
  String shippingCost = '1.99';
  String shippingDiscontCost = '1.99';

  String userName = '1.99';
  String userLastName = '1.99';
  String addressCity = '1.99';

  @override
  Widget build(BuildContext context) {
    final cambio = '3.7'; // El valor como String
    final cambioDouble = double.parse(cambio);
    final totalUSD = widget.total != null ? widget.total! * cambioDouble : 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pasarela de pago '),
      ),
      body: Container(
        child: Column(
          children: [
            Text(widget.cliente?.name ?? 'no hay cliente'),
            Text(widget.cliente?.email ?? 'no hay cliente'),
            Text(widget.cliente?.tdocumento ?? 'no hay cliente'),
            Center(
              child: Text('holaaa'),
            ),
            Center(
              child: TextButton(
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => UsePaypal(
                              sandboxMode: true,
                              clientId: clientId,
                              secretKey: secret,
                              returnURL: retorno,
                              cancelURL: cancelar,
                              transactions: const [
                                {
                                  "amount": {
                                    "total": '10.12',
                                    "currency": 'USD',
                                    "details": {
                                      "subtotal": '10.12',
                                      "shipping": '0',
                                      "shipping_discount": 0
                                    }
                                  },
                                  "description":
                                      "The payment transaction description.",
                                  // "payment_options": {
                                  //   "allowed_payment_method":
                                  //       "INSTANT_FUNDING_SOURCE"
                                  // },
                                  "item_list": {
                                    "items": [
                                      {
                                        "name": "A demo product",
                                        "quantity": 1,
                                        "price": '10.12',
                                        "currency": "USD"
                                      }
                                    ],

                                    // shipping address is not required though

                                    "shipping_address": {
                                      "recipient_name": "hola soy juan",
                                      "line1": "Travis County",
                                      "line2": "",
                                      "city": "Austin",
                                      "country_code": "US",
                                      "postal_code": "73301",
                                      "phone": "+00000000",
                                      "state": "Texas"
                                    },
                                  }
                                }
                              ],
                              note:
                                  "Contact us for any questions on your order.",
                              onSuccess: (Map params) async {
                                print("onSuccess: $params");
                                await _procesarPago();
                                UiHelper.ShowAlertDialog(
                                  'El pago fue Exitoso. Felicidades',
                                  title: 'Exitoso',
                                  buttonTitle: 'Ir al inicio',
                                  navigateTo: AppRoutes.paySuccessRoute,
                                );
                              },
                              onError: (error) {
                                print("onError: $error");
                                UiHelper.ShowAlertDialog(
                                  'Hubo un error con el pago. Inténtalo nuevamente.',
                                  title: 'Error',
                                  buttonTitle: 'Ok',
                                  navigateTo: AppRoutes.pasarelaRoute,
                                );
                              },
                              onCancel: (params) {
                                print('cancelled: $params');
                                UiHelper.ShowAlertDialog(
                                  'El pago fue cancelado',
                                  title: 'Cancelado',
                                  buttonTitle: 'Ok',
                                  navigateTo: AppRoutes.pasarelaRoute,
                                );
                              },
                            ),
                          ),
                        )
                      },
                  child: Column(
                    children: [
                      const Text("Pagar com paypal"),
                      InkWell(
                          onTap: () {
                            final clienteId = widget.cliente?.id;
                            if (clienteId != null) {
                              try {
                                final idCliente = int.parse(
                                    clienteId.toString()); // Convertir a int
                                removeItem(idCliente);
                                // Aquí puedes agregar lógica adicional si deseas navegar o mostrar un mensaje.
                              } catch (e) {
                                print("Error al eliminar el cliente: $e");
                              }
                            } else {
                              print('ID del cliente no disponible');
                            }
                          },
                          child: Text('cancelar'))
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
