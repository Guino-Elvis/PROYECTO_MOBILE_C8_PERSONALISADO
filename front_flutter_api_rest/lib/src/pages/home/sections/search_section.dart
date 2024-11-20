import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      color: themeProvider.isDiurno ? themeColors[6] : themeColors[7],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  child: FadeInLeft(
                    duration: Duration(milliseconds: 600),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: themeProvider.isDiurno
                            ? themeColors[11]
                            : themeColors[12],
                      ),
                      child: Row(
                        children: [
                          Transform.rotate(
                            angle: 90 *
                                3.1415926535 /
                                180, // Rota 90 grados hacia la derecha
                            child: Icon(
                              Icons.search,
                              color: themeProvider.isDiurno
                                  ? themeColors[7]
                                  : themeColors[6],
                            ),
                          ),
                          SizedBox(
                              width:
                                  5), // Espacio entre el icono y el campo de texto
                          Container(
                            width: 270,
                            child: Text(
                              'Buscar en Tienda',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: HexColor('#77F067'),
                    borderRadius: BorderRadius.circular(50)),
                child: Center(
                  child: Icon(
                    CupertinoIcons.slider_horizontal_3,
                    color: themeProvider.isDiurno
                        ? themeColors[6]
                        : themeColors[6],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
