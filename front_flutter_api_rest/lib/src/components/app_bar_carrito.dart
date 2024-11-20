import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/components/perfilpop.dart';
import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';
import 'package:front_flutter_api_rest/src/pages/home/CarritoPage.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/services/shoping/carrito.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AppBarCarrito extends StatelessWidget {
  final VoidCallback? onBackTap; // Callback para el onTap dinámico
  final String? titulo; // Callback para el onTap dinámico

  const AppBarCarrito({Key? key, this.onBackTap, this.titulo})
      : super(key: key); // Aceptamos un argumento para el onTap

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Container(
      color: themeProvider.isDiurno ? themeColors[6] : themeColors[7],
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          InkWell(
            onTap: onBackTap ??
                () {
                  Navigator.pop(context);
                },
            child: Icon(
              Icons.arrow_back_outlined,
              color: themeProvider.isDiurno ? themeColors[7] : themeColors[6],
              size: 30,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              titulo.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDiurno ? themeColors[7] : themeColors[6],
              ),
            ),
          ),
          Spacer(),
          Consumer<CartService>(
            // Usamos Consumer para obtener el valor actualizado
            builder: (context, cartService, child) {
              int cartCount = cartService.getCartCount();
              String cartCountStr = cartCount.toString();

              return cartCount > 0
                  ? Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: HexColor('#77F067'),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarritoPage(cliente: null),
                            ),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                              TextSpan(
                                text: cartCountStr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarritoPage(cliente: null),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: HexColor('#77F067'),
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
