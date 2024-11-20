import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:front_flutter_api_rest/src/cache/ClienteCacheModel.dart';
import 'package:front_flutter_api_rest/src/cache/EntregaCacheModel.dart';
import 'package:front_flutter_api_rest/src/cache/ProductoCacheModel.dart';
import 'package:front_flutter_api_rest/src/components/UiHelper.dart';
import 'package:front_flutter_api_rest/src/components/UiHelperShop.dart';
import 'package:front_flutter_api_rest/src/components/checkout_progress.dart';
import 'package:front_flutter_api_rest/src/controller/clienteController.dart';
import 'package:front_flutter_api_rest/src/controller/entregaController.dart';
import 'package:front_flutter_api_rest/src/controller/voucherController.dart';
import 'package:front_flutter_api_rest/src/controller/voucherDetailController.dart';
import 'package:front_flutter_api_rest/src/model/clienteModel.dart';
import 'package:front_flutter_api_rest/src/model/entregaModel.dart';
import 'package:front_flutter_api_rest/src/model/voucherDetailModel.dart';
import 'package:front_flutter_api_rest/src/model/voucherModel.dart';
import 'package:front_flutter_api_rest/src/pages/cliente_crud/cliente_editar_page.dart';
import 'package:front_flutter_api_rest/src/pages/entrega_crud/entrega_create_page.dart';
import 'package:front_flutter_api_rest/src/pages/entrega_crud/entrega_editar_page.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:front_flutter_api_rest/src/services/correo.dart';
import 'package:front_flutter_api_rest/src/services/shoping/carrito.dart';
import 'package:front_flutter_api_rest/src/services/shoping/cliente.dart';
import 'package:front_flutter_api_rest/src/services/shoping/entrega.dart';
import 'package:front_flutter_api_rest/src/services/shoping/payKey.dart';
import 'package:front_flutter_api_rest/src/services/whatsap.dart';
import 'package:intl/intl.dart';

class PayPalButton extends StatefulWidget {
  final ClienteCacheModel? cliente;
  final EntregaCacheModel? entrega;
  final double? total;

  PayPalButton({required this.entrega, this.cliente, this.total});

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

  EntregaController entregaController = EntregaController();

  final CartService cartService = CartService();

  final ClienteService clienteService = ClienteService();

  final EntregaService entregaService = EntregaService();

  Future<List<ProductoCacheModel>> getCartItems() async {
    return cartService.getCartItems();
  }

  // Función principal para manejar la creación secuencial
  // Future<void> _enviarWapsap() async {
  //   List<ProductoCacheModel> cartItems = cartService.getCartItems();
  //   if (widget.cliente != null) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => EnviarCorreoPage(
  //           cliente: widget.cliente,
  //           carrito: cartItems,
  //           total: widget.total,
  //         ),
  //       ),
  //     );
  //   } else {
  //     print('Error al crear el cliente');
  //   }
  // }

  Future<void> _enviarWapsap() async {
    List<ProductoCacheModel> cartItems = cartService.getCartItems();
    if (widget.cliente != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnviarWhatsAppPage(
            cliente: widget.cliente,
            carrito: cartItems,
            total: widget.total,
          ),
        ),
      );
    } else {
      print('Error al crear el cliente');
    }
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

        await _crearEntrega();
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

  Future<EntregaModel?> _crearEntrega() async {
    final nuevaEntrega = EntregaModel(
      departamento: widget.entrega?.departamento ?? 'no hay departamento',
      provincia: widget.entrega?.provincia ?? 'no hay provincia',
      distrito: widget.entrega?.distrito ?? 'no hay distrito',
      referencia: widget.entrega?.referencia ?? 'no hay referencia',
      authuserid: widget.entrega?.authUserId.toString(),
    );

    try {
      final response = await entregaController.crearEntrega(nuevaEntrega);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Entrega creado con éxito');
        return EntregaModel.fromJson(json.decode(response.body));
      } else {
        print('Error al crear Entrega: ${response.body}');
        return null; // Retornamos null si hubo un error
      }
    } catch (e) {
      print('Error al crear Entrega: $e');
      return null;
    }
  }

  Future<ClienteModel?> _crearCliente() async {
    final nuevoCliente = ClienteModel(
      userId: widget.cliente?.userId,
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
        final nuevaClienteCreado =
            ClienteModel.fromJson(json.decode(response.body));

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

    // Obtener todos los vouchers, mapeándolos a VoucherModel
    final vouchers = await voucherController.getDataVoucher();

    // Asegurarse de que los vouchers se convierten en objetos VoucherModel
    final voucherModels =
        vouchers.map((json) => VoucherModel.fromJson(json)).toList();

    String numero;
    if (voucherModels.isEmpty) {
      numero = 'VC000001';
    } else {
      final ultimoVoucher = voucherModels.last;
      String ultimoNumero = ultimoVoucher.numero ?? 'VC000000';
      int numeroParteNumerica = int.parse(ultimoNumero.substring(2));
      numeroParteNumerica++;
      numero = 'VC' + numeroParteNumerica.toString().padLeft(6, '0');
    }

    // Crear un nuevo voucher
    final nuevoVoucher = VoucherModel(
      tipo: 'TICKET DE COMPRA',
      numero: numero,
      fecha: fechaHoy,
      total: widget.total,
      status: 'PA',
      metodo_pago: 'paypal',
      cliente: {
        'id': clienteCreado.id.toString(),
      },
    );

    try {
      // Enviar la solicitud para crear el voucher
      final response = await voucherController.crearVourcher(nuevoVoucher);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si la respuesta es exitosa, devolver el voucher creado
        print('Voucher creado con éxito');
        return VoucherModel.fromJson(json.decode(response.body));
      } else {
        // Si hay un error al crear el voucher, mostrar el error
        print('Error al crear el voucher: ${response.body}');
        return null; // Retornar null si hubo un error
      }
    } catch (e, stacktrace) {
      // Capturar cualquier error y mostrarlo
      print('Error al crear el voucher: $e');
      print('Stacktrace: $stacktrace');
      return null;
    }
  }

  Future<void> _crearVoucherDetail(VoucherModel voucherCreado) async {
    List<ProductoCacheModel> cartItems = await getCartItems();

    for (var product in cartItems) {
      double cantidad = double.tryParse(product.cantidad.toString()) ?? 0.0;
      double precio = double.tryParse(product.precio.toString()) ?? 0.0;

      double importe = cantidad * precio;
      String importeStr = importe.toStringAsFixed(2);

      final nuevoVoucherDetail = VoucherDetailModel(
        cantidad: product.cantidad.toString(),
        descripcion: product.nombre,
        punitario: product.precio,
        importe: importeStr,
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

  Future<void> removeItemAndNavigate(int clienteId, int entregaId) async {
    try {
      // Eliminar cliente
      await clienteService.eliminarCliente(clienteId);
      print("Cliente con id $clienteId eliminado");

      // Eliminar entrega
      await entregaService.eliminarEntrega(entregaId);
      print("Entrega con id $entregaId eliminada");

      // Navegar a la ruta del carrito
      Navigator.pushNamed(context, AppRoutes.carritoRoute);

      // Actualizar el estado después de eliminar ambos elementos
      setState(() {
        print("Cliente y entrega eliminados con éxito");
      });
    } catch (e) {
      print("Error al eliminar los elementos: $e");
    }
  }

  Future<void> removeEntrega(int id) async {
    await entregaService.eliminarEntrega(id);
    print("Cliente con id $id eliminado");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntregaCreatePage(
          total: widget.total,
          cliente: widget.cliente,
        ),
      ),
    );
    setState(() {
      print("Cliente con id $id eliminado");
    });
  }

  @override
  Widget build(BuildContext context) {
    final cambio = '3.7'; // El valor como String
    final cambioDouble = double.parse(cambio);
    final totalUSD = widget.total != null ? widget.total! * cambioDouble : 0.0;
    return Stack(
      children: [
        Container(
          color: Colors.blue.shade900,
          height: 330,
          width: MediaQuery.of(context).size.width,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      final entregaId = widget.entrega?.id;
                      if (entregaId != null) {
                        try {
                          final idEntrega = int.parse(
                              entregaId.toString()); // Convertir a int
                          removeEntrega(idEntrega);
                          // Aquí puedes agregar lógica adicional si deseas navegar o mostrar un mensaje.
                        } catch (e) {
                          print("Error al eliminar la entrega: $e");
                        }
                      } else {
                        print('ID de la entrega no disponible');
                      }
                    },
                    child: Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Checkout",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
        ),
        Positioned(
          top: 100,
          left: 15,
          right: 15,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CheckoutProgress(
                      colorItem: Colors.blue.shade900,
                      progress: false,
                      textItem: '1',
                    ),
                    Text(
                      '--------',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CheckoutProgress(
                      colorItem: Colors.blue.shade900,
                      progress: false,
                      textItem: '2',
                    ),
                    Text(
                      '--------',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CheckoutProgress(
                      colorItem: Colors.blue.shade900,
                      progress: true,
                      textItem: '3',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  Container(
                    height: 800,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                // Título centrado
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Datos del Cliente',
                                        style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ClienteEditarPage(
                                                cliente: widget.cliente,
                                                total: widget.total,
                                                entrega: widget.entrega,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  height: 140,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _person(
                                          widget.cliente!.email.toUpperCase(),
                                          Icon(Icons.email),
                                        ),
                                        SizedBox(height: 15),
                                        _person(
                                          '${widget.cliente!.name.toUpperCase()} ${widget.cliente!.paterno.toUpperCase()} ${widget.cliente!.materno.toUpperCase()}',
                                          Icon(Icons.email),
                                        ),
                                        SizedBox(height: 15),
                                        _person(
                                          widget.cliente!.phone.toUpperCase(),
                                          Icon(Icons.phone),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                // Título centrado
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Datos de Entrega',
                                        style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EntregaEditarPage(
                                                cliente: widget.cliente,
                                                total: widget.total,
                                                entrega: widget.entrega,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  height: 100,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _person(
                                          '${widget.entrega!.departamento} - ${widget.entrega!.provincia} - ${widget.entrega!.distrito}',
                                          Icon(Icons.location_on),
                                        ),
                                        SizedBox(height: 15),
                                        _person(
                                          widget.entrega!.referencia,
                                          Icon(Icons
                                              .broadcast_on_personal_rounded),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                // Título centrado
                                Text(
                                  'Metodos de Pago',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            UsePaypal(
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
                                                  "recipient_name":
                                                      "hola soy juan",
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
                                            UiHelperShop.ShowAlertDialog(
                                              context,
                                              message:
                                                  'El pago fue Exitoso. Felicidades',
                                              navigateTo:
                                                  AppRoutes.userhomeRoute,
                                            );
                                          },
                                          onError: (error) {
                                            print("onError: $error");
                                            UiHelperShop.ShowAlertDialog(
                                              context,
                                              message:
                                                  'Hubo un error con el pago. Inténtalo nuevamente.',
                                              navigateTo:
                                                  AppRoutes.pasarelaRoute,
                                            );
                                          },
                                          onCancel: (params) {
                                            print('cancelled: $params');
                                            UiHelperShop.ShowAlertDialog(
                                              context,
                                              message: 'El pago fue cancelado',
                                              navigateTo:
                                                  AppRoutes.pasarelaRoute,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: _logos('assets/paypal.png',
                                      Colors.blue, Colors.white),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Cotisa tu carrito',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    _enviarWapsap();
                                  },
                                  child: _logos('assets/whatsapp.png',
                                      Colors.green, Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirmar cancelación'),
                                          content: Text(
                                              '¿Está seguro de cancelar su compra?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Cierra el diálogo
                                              },
                                              child: Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                int clienteId =
                                                    widget.cliente?.id ?? 0;
                                                int entregaId =
                                                    widget.entrega?.id ?? 0;

                                                removeItemAndNavigate(
                                                    clienteId, entregaId);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Sí'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Recuerde que puede cancelar su compra en cualquier momento.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _logos(String link, Color colorItem, Color color2) {
    return Container(
      width: 200,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorItem, // Color del borde
          width: 2.0, // Grosor del borde
        ),
        color: color2,
        borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
      ),
      child: Image.asset(
        link, // Ruta de la imagen
        width: 100, // Ajusta el ancho según sea necesario
        height: 50, // Ajusta la altura según sea necesario
        fit: BoxFit.contain, // Ajusta cómo se adapta la imagen
      ),
    );
  }

  Widget _person(String itemtext, Icon itemIcon) {
    return Container(
      alignment: AlignmentDirectional.topStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Row(
          children: [
            Icon(
              itemIcon.icon, // Corregimos el uso del parámetro icon
              color: Colors.blue.shade600, // Usamos el color del ícono
              size: 30, // Usamos el tamaño del ícono
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              itemtext,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
