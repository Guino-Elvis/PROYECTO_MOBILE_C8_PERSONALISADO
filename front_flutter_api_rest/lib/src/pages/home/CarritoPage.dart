import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/cache/ClienteCacheModel.dart';
import 'package:front_flutter_api_rest/src/cache/ProductoCacheModel.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_carrito.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_create.dart';
import 'package:front_flutter_api_rest/src/pages/cliente_crud/cliente_create_page.dart';
import 'package:front_flutter_api_rest/src/pages/home/UserHomePage.dart';
import 'package:front_flutter_api_rest/src/pages/home/sections/search_section.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:front_flutter_api_rest/src/services/shoping/carrito.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class CarritoPage extends StatefulWidget {
  final ClienteCacheModel? cliente;

  CarritoPage({required this.cliente});

  @override
  _CarritoPageState createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  final CartService cartService = CartService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<ProductoCacheModel>> getCartItems() async {
    return cartService.getCartItems();
  }

  void removeItem(int index) async {
    await cartService.removeFromCart(index);
    setState(() {});
  }

  void updateQuantity(int index, int quantity) async {
    List<ProductoCacheModel> cartItems = cartService.getCartItems();
    ProductoCacheModel product = cartItems[index];

    if (quantity <= 0) return; // Evitar cantidades negativas o cero

    ProductoCacheModel updatedProduct = ProductoCacheModel(
      id: product.id,
      nombre: product.nombre,
      precio: product.precio,
      foto: product.foto,
      cantidad: quantity,
    );

    // Eliminar el producto anterior
    await cartService.removeFromCart(index);
    // Volver a agregar el producto con la nueva cantidad
    await cartService.addToCart(updatedProduct);
    setState(() {}); // Recargar la vista después de actualizar la cantidad
  }

  @override
  Widget build(BuildContext context) {
    int cartCount = cartService.getCartCount();
    String cartCountStr = cartCount.toString();
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeProvider.isDiurno ? themeColors[6] : themeColors[7],
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            color: themeProvider.isDiurno ? themeColors[6] : themeColors[7],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.userhomeRoute);
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              color: Colors.transparent,
                              child: Image.asset(
                                'assets/logo.png',
                                width: 70,
                                height: 70,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              child: Text(
                                'Total (${cartCountStr})',
                                style: TextStyle(
                                  color: themeProvider.isDiurno
                                      ? themeColors[7]
                                      : themeColors[6],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: themeProvider.isDiurno
                              ? themeColors[6]
                              : themeColors[7],
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.grey)),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.search,
                          color: themeProvider.isDiurno
                              ? themeColors[7]
                              : themeColors[6],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ProductoCacheModel>>(
              future: getCartItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar el carrito'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('Tu carrito está vacío.'));
                } else if (snapshot.hasData) {
                  List<ProductoCacheModel> cartItems = snapshot.data!;
                  return ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      ProductoCacheModel product = cartItems[index];
                      return Dismissible(
                        key: ValueKey(product.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirmar eliminación'),
                                content: Text(
                                    '¿Estás seguro de que quieres eliminar "${product.nombre}" del carrito?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(false); // Cancelar
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // Confirmar
                                    },
                                    child: Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          removeItem(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.nombre} eliminado'),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: true, // Marcado por defecto
                                    onChanged: (bool? newValue) {},
                                    checkColor: Colors.black,
                                    activeColor: themeProvider.isDiurno
                                        ? themeColors[0]
                                        : themeColors[0],
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: themeProvider.isDiurno
                                          ? themeColors[11]
                                          : themeColors[12],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: product.foto.toString(),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset('assets/nofoto.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                // Asegúrate de que el ListTile se adapte
                                child: ListTile(
                                  title: Text(
                                    product.nombre,
                                    style: TextStyle(
                                      color: themeProvider.isDiurno
                                          ? themeColors[7]
                                          : themeColors[6],
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            's/${product.precio}',
                                            style: TextStyle(
                                              color: themeProvider.isDiurno
                                                  ? themeColors[7]
                                                  : themeColors[6],
                                              fontSize: 18,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: themeProvider.isDiurno
                                                  ? themeColors[11]
                                                  : themeColors[12],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (product.cantidad > 1) {
                                                      updateQuantity(index,
                                                          product.cantidad - 1);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Icon(
                                                      Icons.remove,
                                                      color:
                                                          themeProvider.isDiurno
                                                              ? themeColors[7]
                                                              : themeColors[6],
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '${product.cantidad}',
                                                  style: TextStyle(
                                                    color:
                                                        themeProvider.isDiurno
                                                            ? themeColors[7]
                                                            : themeColors[6],
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                InkWell(
                                                  onTap: () {
                                                    updateQuantity(index,
                                                        product.cantidad + 1);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          HexColor('#77F067'),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.black,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(child: Text('No hay productos en el carrito'));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: FutureBuilder<List<ProductoCacheModel>>(
        future: getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return SizedBox.shrink();
          }
          double total = snapshot.data!.fold(0,
              (sum, item) => sum + double.parse(item.precio) * item.cantidad);
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 30, left: 15, right: 15),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 70,
                      child: Row(
                        children: [
                          Checkbox(
                            value: true, // Marcado por defecto
                            onChanged: (bool? newValue) {},
                            checkColor: Colors.black,
                            activeColor: themeProvider.isDiurno
                                ? themeColors[0]
                                : themeColors[0],
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Precio total',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: themeProvider.isDiurno
                                        ? themeColors[7]
                                        : themeColors[6],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  's/. ${total.toStringAsFixed(2)}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: themeProvider.isDiurno
                                        ? themeColors[7]
                                        : themeColors[6],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClienteCreatePage(total: total),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: themeProvider.isDiurno
                              ? themeColors[0]
                              : themeColors[0],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Checkout',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeProvider.isDiurno
                                ? themeColors[6]
                                : themeColors[6],
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
