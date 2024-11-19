import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/cache/ClienteCacheModel.dart';
import 'package:front_flutter_api_rest/src/cache/EntregaCacheModel.dart';
import 'package:front_flutter_api_rest/src/controller/Payment/PayPalPayment.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/services/shoping/cliente.dart';
import 'package:provider/provider.dart';

class ClienteEditarPage extends StatefulWidget {
  final ClienteCacheModel? cliente;
  final EntregaCacheModel? entrega;
  final double? total;
  ClienteEditarPage({required this.total, this.cliente, this.entrega});
  @override
  _ClienteEditarPageState createState() => _ClienteEditarPageState();
}

class _ClienteEditarPageState extends State<ClienteEditarPage> {
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
    _nameController.text = widget.cliente?.name ?? '';
    _emailController.text = widget.cliente?.email ?? '';
    _phoneController.text = widget.cliente?.phone ?? '';
    _paternoController.text = widget.cliente?.paterno ?? '';
    _maternoController.text = widget.cliente?.materno ?? '';
    _tdocumentoController.text = widget.cliente?.tdocumento ?? '';
    _direccionController.text = widget.cliente?.direccion ?? '';
    _postalController.text = widget.cliente?.postal ?? '';
    isChecked = widget.cliente?.tdatos == '1';
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  void _editarCliente() async {
    final box = clienteService.clienteCaja;
    if (box != null) {
      // Crear el nuevo cliente con el id calculado
      final int? clienteId = widget.cliente?.id;
      final editarCliente = ClienteCacheModel(
        id: clienteId,
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
        await clienteService.editarCliente(clienteId ?? 0, editarCliente);
        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente editado con éxito')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PayPalButton(
              entrega: widget.entrega,
              cliente: editarCliente,
              total: widget.total,
            ),
          ),
        );
      } catch (e) {
        print('Error al crear el cliente: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al editar el cliente: $e')),
        );
      }
    } else {
      print('La caja no está abierta');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo acceder a la base de datos')),
      );
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
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Editar Información",
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
                      height: 420,
                      child: SingleChildScrollView(
                        child: Form(
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: _editarCliente,
                      child: Container(
                        width: 140,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            'Editar',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PayPalButton(
                              entrega: widget.entrega,
                              cliente: widget.cliente,
                              total: widget.total,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 140,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            'Cancelar',
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
}
