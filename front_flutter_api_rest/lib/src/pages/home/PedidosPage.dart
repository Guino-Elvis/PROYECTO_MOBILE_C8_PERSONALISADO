import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_shop.dart';
import 'package:front_flutter_api_rest/src/components/button_bar.dart';
import 'package:front_flutter_api_rest/src/components/drawers.dart';
import 'package:front_flutter_api_rest/src/components/error_data.dart';
import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';
import 'package:front_flutter_api_rest/src/controller/clienteController.dart';
import 'package:front_flutter_api_rest/src/controller/voucherController.dart';
import 'package:front_flutter_api_rest/src/controller/voucherDetailController.dart';
import 'package:front_flutter_api_rest/src/model/clienteModel.dart';
import 'package:front_flutter_api_rest/src/model/voucherDetailModel.dart';
import 'package:front_flutter_api_rest/src/model/voucherModel.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:provider/provider.dart';

class PedidosPage extends StatefulWidget {
  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  List<ClienteModel> clientes = [];
  List<VoucherModel> vouchers = [];
  List<VoucherDetailModel> voucherDetails = [];

  ClienteController clienteControlle = ClienteController();
  VoucherController voucherControlle = VoucherController();
  VoucherDetailController voucherDetailController = VoucherDetailController();

  int? accountId;
  @override
  void initState() {
    super.initState();
    _getData();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final loginDetails = await ShareApiTokenController.loginDetails();

    if (loginDetails != null) {
      setState(() {
        accountId = loginDetails.user?.id;
      });
      print("accountId: $accountId"); // Agrega esta línea para depurar
    }
  }

  Future<void> _getData() async {
    try {
      // Obtener los datos de los clientes
      final clienteData = await clienteControlle.getDataClientes();
      print("Clientes: $clienteData");
      final voucherData = await voucherControlle.getDataVoucher();
      print("Vouchers: $voucherData");
      final voucherDetailData =
          await voucherDetailController.getDataVoucherDetails();
      print("Voucher Details: $voucherDetailData");

      setState(() {
        clientes = clienteData
            .map<ClienteModel>((json) => ClienteModel.fromJson(json))
            .toList();

        // Filtrar los vouchers basados en el email del usuario logeado
        vouchers = voucherData
            .map<VoucherModel>((json) => VoucherModel.fromJson(json))
            .where((voucher) {
          final clienteId = voucher.cliente?['id'];
          final cliente = clientes.firstWhere(
            (c) => c.id == clienteId,
            orElse: () => ClienteModel(),
          );
          return cliente.userId == accountId;
        }).toList();

        voucherDetails = voucherDetailData
            .map<VoucherDetailModel>(
                (json) => VoucherDetailModel.fromJson(json))
            .toList();
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();

    return Scaffold(
      appBar: AppBarShow(
        appBarColor: themeProvider.isDiurno ? themeColors[6] : themeColors[7],
      ),
      drawer: NavigationDrawerWidget(),
      backgroundColor: themeProvider.isDiurno ? themeColors[6] : themeColors[7],
      body: BounceInUp(
        duration: Duration(milliseconds: 900),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mis Pedidos',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDiurno
                        ? themeColors[7]
                        : themeColors[6],
                  ),
                ),
                const SizedBox(height: 20),
                if (vouchers.isEmpty || accountId == null)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ErrorData(),
                        const SizedBox(height: 20),
                        Text(
                          accountId == null
                              ? "No se encontró información de tu cuenta."
                              : "Aún no tienes pedidos.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "¡Explora nuestros productos y realiza tu primer pedido!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: vouchers.length,
                    itemBuilder: (context, index) {
                      final voucher = vouchers[index];
                      final cliente = clientes.firstWhere(
                        (c) => c.id == voucher.cliente?['id'],
                        orElse: () => ClienteModel(),
                      );
                      final detalles = voucherDetails
                          .where((vd) => vd.voucher?['id'] == voucher.id)
                          .toList();

                      return _buildPedidoCard(
                        voucher,
                        cliente,
                        detalles,
                        themeProvider,
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarFlex(),
    );
  }

  Widget _buildPedidoCard(VoucherModel voucher, ClienteModel cliente,
      List<VoucherDetailModel> detalles, ThemeProvider themeProvider) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      color: themeProvider.isDiurno ? themeColors[11] : themeColors[7],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pedido #${voucher.numero}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDiurno ? themeColors[7] : themeColors[6],
              ),
            ),
            Text(
              "Cliente: ${cliente.name ?? "N/A"} ${cliente.paterno ?? ""}",
              style: TextStyle(
                color: themeProvider.isDiurno ? themeColors[7] : themeColors[6],
              ),
            ),
            Text(
              "Email: ${cliente.email ?? "N/A"}",
              style: TextStyle(
                color: themeProvider.isDiurno ? themeColors[7] : themeColors[6],
              ),
            ),
            Text(
              "Estado: ${voucher.status ?? "Sin estado"}",
              style: TextStyle(
                color: themeProvider.isDiurno ? themeColors[7] : themeColors[6],
              ),
            ),
            Text(
              "Total: S/. ${voucher.total?.toStringAsFixed(2) ?? "0.00"}",
              style: TextStyle(
                color: themeProvider.isDiurno ? themeColors[7] : themeColors[6],
              ),
            ),
            const SizedBox(height: 10),
            Text("Detalles del Pedido:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDiurno
                      ? themeColors[11]
                      : themeColors[12],
                )),
            const SizedBox(height: 5),
            ...detalles.map(
              (detalle) => ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      themeProvider.isDiurno ? themeColors[0] : themeColors[0],
                  child: Text(
                    detalle.cantidad ?? "0",
                    style: TextStyle(
                      color: themeProvider.isDiurno
                          ? themeColors[11]
                          : themeColors[12],
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                title: Text(
                  detalle.descripcion ?? "Sin descripción",
                  style: TextStyle(
                    color: themeProvider.isDiurno
                        ? themeColors[7]
                        : themeColors[6],
                    fontWeight: FontWeight.w900,
                  ),
                ),
                subtitle: Text(
                  "Precio Unitario: S/. ${detalle.punitario ?? "0.00"}",
                  style: TextStyle(
                    color: themeProvider.isDiurno
                        ? themeColors[7]
                        : themeColors[6],
                  ),
                ),
                trailing: Text(
                  "Importe: S/. ${detalle.importe ?? "0.00"}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDiurno
                        ? themeColors[7]
                        : themeColors[6],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
