import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_shop.dart';
import 'package:front_flutter_api_rest/src/components/button_bar.dart';
import 'package:front_flutter_api_rest/src/components/drawers.dart';
import 'package:front_flutter_api_rest/src/controller/categoriaController.dart';
import 'package:front_flutter_api_rest/src/model/categoriaModel.dart';
import 'package:front_flutter_api_rest/src/pages/home/CategoriaPageDetail.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:provider/provider.dart';

class CategoriaPage extends StatefulWidget {
  @override
  State<CategoriaPage> createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  List<CategoriaModel> item = [];
  CategoriaController categoriaController = CategoriaController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      final categoriesData = await categoriaController.getDataCategories();

      setState(() {
        item = categoriesData
            .map<CategoriaModel>((json) => CategoriaModel.fromJson(json))
            .toList();
      });
    } catch (error) {
      print('Error fetching categories: $error');
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
      body: Column(
        children: [
          BounceInUp(
            duration: Duration(milliseconds: 900),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: GridView.builder(
                shrinkWrap:
                    true, // Permite que el GridView ocupe solo el espacio necesario
                physics:
                    NeverScrollableScrollPhysics(), // Deshabilita el scroll interno
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Número de columnas
                  crossAxisSpacing: 8, // Espacio entre columnas
                  mainAxisSpacing: 8, // Espacio entre filas
                ),
                itemCount: item.length, // Total de elementos en la lista
                itemBuilder: (context, index) {
                  final categoria = item[index]; // Elemento actual

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    decoration: BoxDecoration(
                      color: themeProvider.isDiurno
                          ? themeColors[11]
                          : themeColors[7],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(2, 0),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoriaPageDetail(categoria: categoria),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          // Aquí se carga la imagen
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10), // Aplica el redondeo
                            child: CachedNetworkImage(
                              imageUrl: categoria.foto.toString(),
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/nofoto.jpg',
                                fit: BoxFit.cover,
                              ),
                              fit: BoxFit.cover, // Ajuste de imagen
                              height: 80,
                              width: 100,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                categoria.nombre ?? 'No hay categoría',
                                style: TextStyle(
                                  color: themeProvider.isDiurno
                                      ? themeColors[7]
                                      : themeColors[6],
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBarFlex(),
    );
  }
}
