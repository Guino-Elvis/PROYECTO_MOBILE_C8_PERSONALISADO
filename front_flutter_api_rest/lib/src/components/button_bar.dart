import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class BottomNavBarFlex extends StatelessWidget {
  final dynamic buttonColor; // Propiedad para el color del botón

  BottomNavBarFlex({
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomAppBar(
        color: Colors.white,
        height: 90.0,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.userhomeRoute);
                  },
                  icon: const Icon(
                    Icons.storefront,
                    size: 30,
                  ),
                  color: Colors.blue.shade800,
                ),
                const Text(
                  'Tienda',
                  style: TextStyle(
                      color: Color.fromARGB(255, 33, 82, 243),
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.rectangle_grid_2x2,
                    size: 30,
                  ),
                  color: Colors.blue.shade800,
                ),
                const Text(
                  'Categorias',
                  style: TextStyle(
                      color: Color.fromARGB(255, 33, 82, 243),
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 30,
                  ),
                  color: Colors.blue.shade800,
                ),
                const Text(
                  'Mis pedidos',
                  style: TextStyle(
                      color: Color.fromARGB(255, 33, 82, 243),
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    //  Navigator.pushNamed(context, AppRoutes.adminhomeRoute);
                  },
                  icon: const Icon(
                    Icons.headset_mic_outlined,
                    size: 30,
                  ),
                  color: Colors.blue.shade800,
                ),
                const Text(
                  'Ayuda',
                  style: TextStyle(
                      color: Color.fromARGB(255, 33, 82, 243),
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
