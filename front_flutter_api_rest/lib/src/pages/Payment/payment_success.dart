// import 'package:flutter/material.dart';
// import 'package:front_flutter_api_rest/src/controller/voucherDetailController.dart';
// import 'package:front_flutter_api_rest/src/model/voucherDetailModel.dart';
// import 'package:front_flutter_api_rest/src/pages/Payment/PagoNotifier.dart';
// import 'package:front_flutter_api_rest/src/routes/route.dart';
// import 'package:provider/provider.dart';

// class PaymentSuccessScreen extends StatefulWidget {
//   @override
//   _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
// }

// class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
//   List<VoucherDetailModel> item = [];
//   VoucherDetailController voucherDetailController = VoucherDetailController();

//   @override
//   void initState() {
//     super.initState();
//     // Cargar los detalles del voucher al inicio
//     _getData();
//   }

//   // Método para obtener los detalles del voucher
//   Future<void> _getData() async {
//     try {
//       // Acceder al voucher ID desde el proveedor (PagoNotifier)
//       final appData = Provider.of<PagoNotifier>(context, listen: false);
//       final voucherId = appData.voucher?.id;

//       // Verificar si el voucherId está disponible
//       if (voucherId == null) {
//         print("Voucher ID no disponible");
//         return;
//       }

//       // Llamada al controlador para obtener los detalles del voucher por ID
//       final voucherDetailData =
//           await voucherDetailController.getDataVoucherDetails();

//       // Filtrar los detalles usando el voucherId
//       setState(() {
//         item = voucherDetailData
//             .where((voucherDetail) => voucherDetail['voucherId'] == voucherId)
//             .map<VoucherDetailModel>(
//                 (json) => VoucherDetailModel.fromJson(json))
//             .toList();
//       });
//     } catch (error) {
//       print('Error fetching voucher details: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Acceder a los datos del proveedor (PagoNotifier)
//     final appData = Provider.of<PagoNotifier>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Pago Exitoso"),
//         backgroundColor: Color(0xFF4CAF50), // Color verde para un tema de éxito
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Icono de éxito
//             Center(
//               child: Icon(
//                 Icons.check_circle,
//                 color: Color(0xFF4CAF50),
//                 size: 80.0,
//               ),
//             ),
//             SizedBox(height: 20),

//             // Mensaje de éxito
//             Text(
//               "¡Felicidades, tu pago fue exitoso!",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),

//             // Información del voucher
//             Text(
//               "Detalles del Voucher:",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text("Voucher ID: ${appData.voucher?.id ?? 'N/A'}"),
//             Text("Monto: \$${appData.voucher?.total ?? '0.00'}"),
//             Text("Fecha de emisión: ${appData.voucher?.createdAt ?? 'N/A'}"),
//             SizedBox(height: 20),

//             // Información de los detalles del voucher
//             Text(
//               "Detalles del Voucher (VoucherDetail):",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10),

//             // Mostrar los detalles del voucher
//             item.isNotEmpty
//                 ? Column(
//                     children: item.map((detail) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Detalle ID: ${detail.id}"),
//                           Text("Producto: ${detail.descripcion ?? 'N/A'}"),
//                           Text("Cantidad: ${detail.cantidad ?? 'N/A'}"),
//                           Text(
//                               "Precio unitario: \$${detail.punitario ?? '0.00'}"),
//                           Text("Subtotal: \$${detail.importe ?? '0.00'}"),
//                           SizedBox(height: 10),
//                         ],
//                       );
//                     }).toList(),
//                   )
//                 : Center(
//                     child: Text("No hay detalles de voucher disponibles.")),

//             SizedBox(height: 20),

//             // Información del cliente
//             Text(
//               "Datos del Cliente:",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text("Nombre: ${appData.cliente?.name ?? 'N/A'}"),
//             Text("Correo: ${appData.cliente?.email ?? 'N/A'}"),
//             Text("Teléfono: ${appData.cliente?.phone ?? 'N/A'}"),
//             SizedBox(height: 20),

//             // Botón para navegar
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, AppRoutes.userhomeRoute);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding:
//                       EdgeInsets.symmetric(vertical: 14.0, horizontal: 30.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                 ),
//                 child: Text(
//                   "Ir al Inicio",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
