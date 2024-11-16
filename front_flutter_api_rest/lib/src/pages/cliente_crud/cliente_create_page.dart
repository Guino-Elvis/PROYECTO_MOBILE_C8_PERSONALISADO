import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/cache/ClienteCacheModel.dart';
import 'package:front_flutter_api_rest/src/components/checkout_progress.dart';
import 'package:front_flutter_api_rest/src/controller/Payment/PayPalPayment.dart';
import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/services/shoping/cliente.dart';
import 'package:provider/provider.dart';

class ClienteCreatePage extends StatefulWidget {
  final double total;
  ClienteCreatePage({required this.total});
  @override
  _ClienteCreatePageState createState() => _ClienteCreatePageState();
}

class _ClienteCreatePageState extends State<ClienteCreatePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String accountName = "";
  String accountEmail = "";
  String accountApellidoP = "";
  String accountApellidoM = "";
  String accountDni = "";

  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _paternoController = TextEditingController();
  final _maternoController = TextEditingController();
  final _tdocumentoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _postalController = TextEditingController();

  bool isChecked = false;

  ClienteService clienteService = ClienteService();

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  Future<void> loadUserProfile() async {
    final loginDetails = await ShareApiTokenController.loginDetails();

    if (loginDetails != null) {
      setState(() {
        accountName = loginDetails.user?.name ?? "";
        accountEmail = loginDetails.user?.email ?? "";
        accountApellidoP = loginDetails.user?.apellidoP ?? "";
        accountApellidoM = loginDetails.user?.apellidoM ?? "";
        accountDni = loginDetails.user?.apellidoM ?? "";

        // Asignar los valores a los controladores
        _nameController.text = accountName;
        _emailController.text = accountEmail;
        _paternoController.text = accountApellidoP;
        _maternoController.text = accountApellidoM;
        _tdocumentoController.text = accountDni;
      });
    }
  }

  void _crearCliente() async {
    if (_formKey.currentState!.validate()) {
      // Verificar que el checkbox de los términos y condiciones esté marcado
      if (!isChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Por favor, acepta los términos y condiciones')),
        );
        return; // Detener el flujo si no se acepta
      }
      final box = clienteService.clienteCaja;
      if (box != null) {
        final keys = box.keys.toList();
        int nextId = keys.isEmpty
            ? 0
            : (keys.cast<int>().reduce((a, b) => a > b ? a : b) + 1);

        // Crear el nuevo cliente con el id calculado
        final nuevoCliente = ClienteCacheModel(
          id: nextId, // Asignamos el id calculado
          email: _emailController.text,
          phone: _phoneController.text,
          name: _nameController.text,
          paterno: _paternoController.text,
          materno: _maternoController.text,
          tdocumento: _tdocumentoController.text,
          direccion: _direccionController.text,
          postal: _postalController.text,
          tdatos: isChecked ? "1" : "0",
        );

        try {
          // Llamar al servicio para agregar el cliente con el nuevo id
          await clienteService.agregarCliente(nuevoCliente);

          // Recuperamos el cliente con el id asignado
          ClienteCacheModel? clienteRecuperado =
              await clienteService.obtenerCliente(nuevoCliente.id!);

          if (clienteRecuperado != null) {
            // Muestra un mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Cliente creado con éxito')),
            );

            // Navegar a la siguiente página (en este caso, el pago con PayPal)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PayPalButton(
                  cliente: clienteRecuperado,
                  total: widget.total,
                ),
              ),
            );
          } else {
            print('No se pudo recuperar el cliente después de la creación');
          }
        } catch (e) {
          print('Error al crear el cliente: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al crear el cliente: $e')),
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
                      Navigator.pop(context);
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
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CheckoutProgress(
                      colorItem: Colors.blue.shade900,
                      progress: true,
                      textItem: '1',
                    ),
                    Text(
                      '-----------',
                      style: TextStyle(
                        color: Colors.transparent,
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
                      '-----------',
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
                      'Datos del cliente',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      height: 490,
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextField(
                                  _nameController, 'Nombre', themeProvider),
                              _buildTextField(
                                  _emailController, 'Email', themeProvider),
                              _buildTextField(
                                  _phoneController, 'Teléfono', themeProvider),
                              _buildTextField(_paternoController,
                                  'Apellido Paterno', themeProvider),
                              _buildTextField(_maternoController,
                                  'Apellido Materno', themeProvider),
                              _buildTextField(_tdocumentoController,
                                  'Tipo de Documento', themeProvider),
                              _buildTextField(_direccionController, 'Dirección',
                                  themeProvider),
                              _buildTextField(_postalController,
                                  'Código Postal', themeProvider),
                              _termsConditionsCheckbox()
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
                onTap: _crearCliente,
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
      ],
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

  Widget _termsConditionsCheckbox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
            Text(
              'Acepto los términos y condiciones',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
