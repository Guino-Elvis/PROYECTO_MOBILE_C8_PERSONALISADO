import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/cache/ClienteCacheModel.dart';
import 'package:front_flutter_api_rest/src/cache/EntregaCacheModel.dart';
import 'package:front_flutter_api_rest/src/components/checkout_progress.dart';
import 'package:front_flutter_api_rest/src/controller/Payment/PayPalPayment.dart';
import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/services/shoping/entrega.dart';
import 'package:provider/provider.dart';

class EntregaEditarPage extends StatefulWidget {
  final EntregaCacheModel? entrega;
  final ClienteCacheModel? cliente;
  final double? total;
  EntregaEditarPage({required this.total, this.entrega, this.cliente});
  @override
  _EntregaEditarPageState createState() => _EntregaEditarPageState();
}

class _EntregaEditarPageState extends State<EntregaEditarPage> {
  final _departamentoController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _distritoController = TextEditingController();
  final _referenciaController = TextEditingController();

  EntregaService entregaService = EntregaService();

  @override
  void initState() {
    super.initState();
    _departamentoController.text = widget.entrega?.departamento ?? '';
    _provinciaController.text = widget.entrega?.provincia ?? '';
    _distritoController.text = widget.entrega?.distrito ?? '';
    _referenciaController.text = widget.entrega?.referencia ?? '';
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  void _editarEntrega() async {
    final box = entregaService.entregaCaja;
    if (box != null) {
      // Crear el nuevo entrega con el id calculado
      final int? entregaId = widget.entrega?.id;
      final editarEntrega = EntregaCacheModel(
        id: entregaId,
        departamento: _departamentoController.text,
        provincia: _provinciaController.text,
        distrito: _distritoController.text,
        referencia: _referenciaController.text,
        authUserId: widget.entrega?.authUserId,
      );

      try {
        // Llamar al servicio para agregar el entrega con el nuevo id
        await entregaService.editarEntrega(entregaId ?? 0, editarEntrega);
        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entrega editado con éxito')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PayPalButton(
              entrega: editarEntrega,
              total: widget.total,
              cliente: widget.cliente,
            ),
          ),
        );
      } catch (e) {
        print('Error al crear el entrega: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al editar el entrega: $e')),
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
                      "Editar lugar de entrega",
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
          top: 150,
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
                      'Datos del entrega',
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
                      height: 300,
                      child: SingleChildScrollView(
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextField(_departamentoController,
                                  'Departamento', themeProvider),
                              _buildTextField(_provinciaController, 'Provincia',
                                  themeProvider),
                              _buildTextField(_distritoController, 'Distrito',
                                  themeProvider),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: _editarEntrega,
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
