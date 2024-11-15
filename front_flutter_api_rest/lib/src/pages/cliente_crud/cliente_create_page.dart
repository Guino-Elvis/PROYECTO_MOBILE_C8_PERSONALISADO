import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/cache/ClienteCacheModel.dart';
import 'package:front_flutter_api_rest/src/controller/Payment/PayPalPayment.dart';
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

  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _paternoController = TextEditingController();
  final _maternoController = TextEditingController();
  final _tdocumentoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _postalController = TextEditingController();
  final _tdatosController = TextEditingController();

  ClienteService clienteService = ClienteService();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  void _crearCliente() async {
    if (_formKey.currentState!.validate()) {
      // Obtener la caja de clientes
      final box = clienteService.clienteCaja;

      // Asegurarnos de que la caja esté abierta
      if (box != null) {
        // Obtener las claves existentes en la caja
        final keys = box.keys.toList();

        // Determinamos el siguiente id disponible (usando el índice más alto)
        int nextId = keys.isEmpty
            ? 0 // Si la caja está vacía, el id inicial es 0
            : (keys.cast<int>().reduce((a, b) => a > b ? a : b) +
                1); // Obtener el id más alto y agregar 1

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
          tdatos: _tdatosController.text,
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeProvider.isDiurno ? themeColors[1] : themeColors[7],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Card(
              color: themeProvider.isDiurno ? themeColors[2] : themeColors[7],
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(_nameController, 'Nombre', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(_emailController, 'Email', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(
                          _phoneController, 'Teléfono', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(_paternoController, 'Apellido Paterno',
                          themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(_maternoController, 'Apellido Materno',
                          themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(_tdocumentoController,
                          'Tipo de Documento', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(
                          _direccionController, 'Dirección', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(
                          _postalController, 'Código Postal', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(_tdatosController, 'Datos adicionales',
                          themeProvider),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _crearCliente,
                        child: Text('Aceptar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label,
      ThemeProvider themeProvider) {
    final themeColors = themeProvider.getThemeColors();
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: themeProvider.isDiurno ? themeColors[7] : themeColors[2],
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: themeProvider.isDiurno ? themeColors[10] : themeColors[9],
        ),
        filled: true,
        fillColor: themeProvider.isDiurno ? themeColors[1] : themeColors[7],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
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
