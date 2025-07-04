// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_shop.dart';
import 'package:front_flutter_api_rest/src/components/button_bar.dart';
import 'package:front_flutter_api_rest/src/pages/home/sections/producto_section.dart';
import 'package:front_flutter_api_rest/src/pages/home/sections/search_section.dart';
import 'package:front_flutter_api_rest/src/pages/home/sections/producto_subcategoria_section.dart';
import 'package:front_flutter_api_rest/src/pages/home/sections/slider_section.dart';
import 'package:front_flutter_api_rest/src/pages/home/sections/sub_category_section.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:provider/provider.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _onPres() {
    // Implementa la lógica del botón aquí
  }
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarShow(
        appBarColor: themeProvider.isDiurno ? themeColors[6] : themeColors[7],
      ),
      // drawer: NavigationDrawerWidget(),
      backgroundColor: themeProvider.isDiurno ? themeColors[6] : themeColors[7],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchSection(),
            SliderSection(),
            SizedBox(height: 10),
            SubCategoriSection(),
            SizedBox(height: 10),
            ProductoSubCategoriaSection(),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'Te puede gustar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color:
                      themeProvider.isDiurno ? themeColors[7] : themeColors[6],
                ),
              ),
            ),
            SizedBox(height: 10),
            ProductoSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarFlex(),
    );
  }
}
