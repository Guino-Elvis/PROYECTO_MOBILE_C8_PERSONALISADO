import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/cache/ClienteCacheModel.dart';
import 'package:front_flutter_api_rest/src/cache/EntregaCacheModel.dart';
import 'package:front_flutter_api_rest/src/components/checkout_progress.dart';
import 'package:front_flutter_api_rest/src/controller/Payment/PayPalPayment.dart';
import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';
import 'package:front_flutter_api_rest/src/pages/cliente_crud/cliente_create_page.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:front_flutter_api_rest/src/services/shoping/cliente.dart';
import 'package:front_flutter_api_rest/src/services/shoping/entrega.dart';
import 'package:provider/provider.dart';

class EntregaCreatePage extends StatefulWidget {
  final double? total;
  final ClienteCacheModel? cliente;

  EntregaCreatePage({required this.total, this.cliente});
  @override
  _EntregaCreatePageState createState() => _EntregaCreatePageState();
}

class _EntregaCreatePageState extends State<EntregaCreatePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _departamentoController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _distritoController = TextEditingController();
  final _referenciaController = TextEditingController();

  EntregaService entregaService = EntregaService();
  ClienteService clienteService = ClienteService();
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  void _crearEntrega() async {
    if (_formKey.currentState!.validate()) {
      final loginDetails = await ShareApiTokenController.loginDetails();
      final userId = loginDetails?.user?.id;
      final box = entregaService.entregaCaja;
      if (box != null) {
        final keys = box.keys.toList();
        int nextId = keys.isEmpty
            ? 0
            : (keys.cast<int>().reduce((a, b) => a > b ? a : b) + 1);

        // Crear el nuevo entrega con el id calculado
        final nuevoEntrega = EntregaCacheModel(
          id: nextId,
          departamento: _departamentoController.text,
          provincia: _provinciaController.text,
          distrito: _distritoController.text,
          referencia: _referenciaController.text,
          authUserId: userId,
        );

        try {
          // Llamar al servicio para agregar el entrega con el nuevo id
          await entregaService.agregarEntrega(nuevoEntrega);

          // Recuperamos el entrega con el id asignado
          EntregaCacheModel? entregaRecuperado =
              await entregaService.obtenerEntrega(nuevoEntrega.id!);

          if (entregaRecuperado != null) {
            // Muestra un mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Entrega creado con éxito')),
            );
            // Navegar a la siguiente página (en este caso, el pago con PayPal)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PayPalButton(
                  entrega: entregaRecuperado,
                  cliente: widget.cliente,
                  total: widget.total,
                ),
              ),
            );
          } else {
            print('No se pudo recuperar el entrega después de la creación');
          }
        } catch (e) {
          print('Error al crear el entrega: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al crear el entrega: $e')),
          );
        }
      } else {
        print('La caja no está abierta');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo acceder a la base de datos')),
        );
      }
    }
  }

  Future<void> removeItem(int id) async {
    await clienteService.eliminarCliente(id);
    print("Cliente con id $id eliminado");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteCreatePage(
          total: widget.total,
        ),
      ),
    );
    setState(() {
      print("Cliente con id $id eliminado");
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
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
                    final clienteId = widget.cliente?.id;
                    if (clienteId != null) {
                      try {
                        final idCliente =
                            int.parse(clienteId.toString()); // Convertir a int
                        removeItem(idCliente);
                        // Aquí puedes agregar lógica adicional si deseas navegar o mostrar un mensaje.
                      } catch (e) {
                        print("Error al eliminar el cliente: $e");
                      }
                    } else {
                      print('ID del cliente no disponible');
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
            ),
          ),
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
                      progress: true,
                      textItem: '2',
                    ),
                    Text(
                      '--------',
                      style: TextStyle(
                        color: Colors.transparent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CheckoutProgress(
                      colorItem: Colors.blue.shade900,
                      progress: false,
                      textItem: '3',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  Container(
                    height: 700,
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
                                      // InkWell(
                                      //   onTap: () {},
                                      //   child: Icon(
                                      //     Icons.edit,
                                      //     color: Colors.blue.shade900,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  height: 150,
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
                                          Icon(Icons.person),
                                        ),
                                        SizedBox(height: 15),
                                        _person(
                                          widget.cliente!.phone.toUpperCase(),
                                          Icon(Icons.phone_android),
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
                                Text(
                                  'Datos del entrega',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  height: 270,
                                  child: SingleChildScrollView(
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildTextField(
                                              _departamentoController,
                                              'Departamento',
                                              themeProvider),
                                          _buildTextField(_provinciaController,
                                              'Provincia', themeProvider),
                                          _buildTextField(_distritoController,
                                              'Distrito', themeProvider),
                                          _buildTextField(_referenciaController,
                                              'Referencia', themeProvider),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          InkWell(
                            onTap: _crearEntrega,
                            child: Container(
                              width: 230,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade900,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: Text(
                                  'Siguiente',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
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

  TextFormField _buildTextField(TextEditingController controller, String label,
      ThemeProvider themeProvider) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade700,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 12,
          color: Colors.blue.shade900,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue.shade900,
            width: 2.0,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue.shade900,
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa $label';
        }
        return null;
      },
    );
  }
}
