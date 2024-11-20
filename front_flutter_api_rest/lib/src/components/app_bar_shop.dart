import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/pages/home/CarritoPage.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/services/shoping/carrito.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class AppBarShow extends StatelessWidget implements PreferredSizeWidget {
  final Color appBarColor;
  AppBarShow({required this.appBarColor});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Container(
      color: themeProvider.isDiurno ? themeColors[6] : themeColors[7],
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: themeProvider.isDiurno ? themeColors[7] : themeColors[6],
          ), // Icono del drawer
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Center(
          child: Text(
            'Ropa & Glamour',
            style: TextStyle(
              fontSize: 25,
              color: themeProvider.isDiurno ? themeColors[7] : themeColors[6],
              letterSpacing: 2.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        actions: [
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
