// import 'package:flutter/cupertino.dart';
// import 'package:front_flutter_api_rest/src/model/clienteModel.dart';
// import 'package:front_flutter_api_rest/src/model/voucherDetailModel.dart';
// import 'package:front_flutter_api_rest/src/model/voucherModel.dart';

// class PagoNotifier extends ChangeNotifier {
//   // Definir los campos privados
//   ClienteModel? _cliente;
//   VoucherModel? _voucher;
//   VoucherDetailModel? _voucherDetail;

//   // Getters para acceder a los datos
//   ClienteModel? get cliente => _cliente;
//   VoucherModel? get voucher => _voucher;
//   VoucherDetailModel? get voucherDetail => _voucherDetail;

//   // Constructor de PagoNotifier
//   PagoNotifier({
//     ClienteModel? cliente,
//     VoucherModel? voucher,
//     VoucherDetailModel? voucherDetail,
//   }) {
//     _cliente = cliente;
//     _voucher = voucher;
//     _voucherDetail = voucherDetail;
//   }

//   // Actualiza el cliente
//   void updateCliente(ClienteModel cliente) {
//     _cliente = cliente;
//     notifyListeners(); // Notifica a los widgets que escuchan
//   }

//   // Actualiza el voucher
//   void updateVoucher(VoucherModel voucher) {
//     _voucher = voucher;
//     notifyListeners();
//   }

//   // Actualiza los detalles del voucher
//   void updateVoucherDetail(VoucherDetailModel voucherDetail) {
//     _voucherDetail = voucherDetail;
//     notifyListeners();
//   }

//   // Limpiar todos los datos cuando ya no sean necesarios
//   void clearData() {
//     _cliente = null;
//     _voucher = null;
//     _voucherDetail = null;
//     notifyListeners();
//   }
// }
