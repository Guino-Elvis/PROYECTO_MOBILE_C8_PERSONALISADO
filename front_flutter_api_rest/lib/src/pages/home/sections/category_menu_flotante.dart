import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/controller/categoriaController.dart';
import 'package:front_flutter_api_rest/src/model/categoriaModel.dart';
import 'package:front_flutter_api_rest/src/pages/home/CategoriaPageDetail.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:provider/provider.dart';

class CategoriMenu extends StatefulWidget {
  const CategoriMenu({Key? key}) : super(key: key);

  @override
  State<CategoriMenu> createState() => _CategoriMenuState();
}

class _CategoriMenuState extends State<CategoriMenu> {
  List<CategoriaModel> item = [];
  final CategoriaController categoriaController = CategoriaController();

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

    return BounceInLeft(
      duration: const Duration(milliseconds: 500),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 300, // máximo ancho permitido
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          margin:
              const EdgeInsets.only(left: 10, top: 10), // pegado a la izquierda
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeProvider.isDiurno ? themeColors[11] : themeColors[12],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y botón de cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categorías',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.isDiurno
                          ? themeColors[7]
                          : themeColors[6],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close,
                        color: themeProvider.isDiurno
                            ? themeColors[7]
                            : themeColors[6]),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Lista
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: item.map<Widget>((categoria) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoriaPageDetail(categoria: categoria),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(
                            color: themeProvider.isDiurno
                                ? themeColors[0]
                                : themeColors[11],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(1, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_offer,
                                color: themeProvider.isDiurno
                                    ? themeColors[7]
                                    : themeColors[7],
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  categoria.nombre ?? 'Sin nombre',
                                  style: TextStyle(
                                    color: themeProvider.isDiurno
                                        ? themeColors[7]
                                        : themeColors[7],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
