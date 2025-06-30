import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:provider/provider.dart';

class BottomNavBarFlex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return SafeArea(
      child: Container(
        height: 120,
        child: BottomAppBar(
          color: Colors.transparent,
          shape: const CircularNotchedRectangle(),
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
                color: themeProvider.isDiurno ? themeColors[0] : themeColors[0],
                borderRadius: BorderRadius.circular(100)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navBarItem(
                  context,
                  icon: Icons.storefront,
                  routeName: '/user_home',
                ),
                _navBarItem(
                  context,
                  icon: CupertinoIcons.rectangle_grid_2x2,
                  routeName: '/categoria_page',
                ),
                // _navBarItem(
                //   context,
                //   icon: Icons.shopping_bag_outlined,
                //   routeName: '/pedidos_page',
                // ),
                _navBarItem(
                  context,
                  icon: Icons.settings_outlined,
                  routeName: '/setting_page',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navBarItem(BuildContext context,
      {required IconData icon, required String? routeName}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            if (routeName != null) {
              Navigator.pushNamed(context, routeName);
            }
          },
          icon: Icon(icon, size: 30),
          color: Colors.black,
        ),
      ],
    );
  }
}
