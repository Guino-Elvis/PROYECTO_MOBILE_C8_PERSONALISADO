import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/cache/ProductoCacheModel.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_carrito.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_create.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_shop.dart';
import 'package:front_flutter_api_rest/src/components/drawers.dart';
import 'package:front_flutter_api_rest/src/controller/categoriaController.dart';
import 'package:front_flutter_api_rest/src/controller/productoController.dart';
import 'package:front_flutter_api_rest/src/controller/sub_categoriaController.dart';
import 'package:front_flutter_api_rest/src/model/categoriaModel.dart';
import 'package:front_flutter_api_rest/src/model/productoModel.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:front_flutter_api_rest/src/services/shoping/carrito.dart';
import 'package:provider/provider.dart';

class CategoriaPageDetail extends StatefulWidget {
  final CategoriaModel categoria;
  CategoriaPageDetail({required this.categoria});

  @override
  State<CategoriaPageDetail> createState() => _CategoriaPageDetailState();
}

class _CategoriaPageDetailState extends State<CategoriaPageDetail> {
  List<ProductoModel> item = [];
  List<Map<String, dynamic>> subCategorias = [];
  List<Map<String, dynamic>> categorias = [];

  ProductoController productoController = ProductoController();
  SubCategoriaController subCategoriaController = SubCategoriaController();
  CategoriaController categoriaController = CategoriaController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      // Obtener productos
      final productoData = await productoController.getDataProductos();
      setState(() {
        item = productoData
            .map<ProductoModel>((json) => ProductoModel.fromJson(json))
            .toList();
      });

      // Obtener categorías
      final categoriaData = await categoriaController.getDataCategories();
      setState(() {
        categorias = List<Map<String, dynamic>>.from(categoriaData);
      });

      // Obtener subcategorías y asociarlas con productos
      final subCategoriaData =
          await subCategoriaController.getDataSubCategoria();
      List<Map<String, dynamic>> subCategoriaConProductos = [];

      // Filtrar por el id de la categoría que llega en el widget
      List<Map<String, dynamic>> categoriasFiltradas =
          categorias.where((categoria) {
        return categoria['id'] == widget.categoria.id;
      }).toList();

      // Organizar subcategorías dentro de sus categorías y productos dentro de las subcategorías
      for (var categoria in categoriasFiltradas) {
        List<Map<String, dynamic>> subCategoriasDeCategoria = [];

        // Filtrar subcategorías por la categoría actual
        for (var subCategoria in subCategoriaData) {
          if (subCategoria['categoria']['id'] == categoria['id']) {
            List<ProductoModel> productosSubCategoria = item
                .where((producto) =>
                    producto.subCategoria?['id'] == subCategoria['id'])
                .toList();
            subCategoria['productos'] = productosSubCategoria;
            subCategoriasDeCategoria.add(subCategoria);
          }
        }

        // Agregar subcategorías a la categoría filtrada
        categoria['subCategorias'] = subCategoriasDeCategoria;
        subCategoriaConProductos.add(categoria);
      }

      setState(() {
        categorias = subCategoriaConProductos;
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + "...";
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    final cartService = context.watch<CartService>();

    return Scaffold(
      backgroundColor: themeProvider.isDiurno ? themeColors[6] : themeColors[7],
      body: BounceInUp(
        duration: Duration(milliseconds: 900),
        child: ListView(
          children: categorias.map<Widget>((categoria) {
            String categoriaName =
                categoria['nombre'] ?? 'Categoría sin nombre';

            return Column(
              children: [
                AppBarCarrito(
                  titulo: categoriaName,
                ),

                // Ahora recorremos las subcategorías dentro de cada categoría
                ...(categoria['subCategorias'] ?? [])
                    .map<Widget>((subCategoria) {
                  String subCategoriaName =
                      subCategoria['nombre'] ?? 'Subcategoría sin nombre';
                  List<ProductoModel> productosSubCategoria =
                      subCategoria['productos'];

                  return Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subCategoriaName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: themeProvider.isDiurno
                                    ? themeColors[7]
                                    : themeColors[6],
                              ),
                            ),
                            Text(
                              'ver más',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDiurno
                                    ? themeColors[0]
                                    : themeColors[0],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              productosSubCategoria.map<Widget>((producto) {
                            return Container(
                              height: 310,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
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
                                onTap: () {},
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: producto.foto.toString(),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset('assets/nofoto.jpg'),
                                      fit: BoxFit.cover,
                                      height: 150,
                                      width: 150,
                                    ),
                                    Container(
                                      height: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (producto.nombre ?? 'No hay nombre')
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: themeProvider.isDiurno
                                                    ? themeColors[7]
                                                    : themeColors[6],
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            width: 145,
                                            child: Text(
                                              truncateText(
                                                  producto.descrip ??
                                                      'No hay descripción',
                                                  32),
                                              style: TextStyle(
                                                  color: themeProvider.isDiurno
                                                      ? themeColors[7]
                                                      : themeColors[6],
                                                  fontSize: 14.5),
                                            ),
                                          ),
                                          Text(
                                            producto.precio?.toString() ??
                                                'No hay precio',
                                            style: TextStyle(
                                                color: themeProvider.isDiurno
                                                    ? themeColors[7]
                                                    : themeColors[6],
                                                fontSize: 14.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: InkWell(
                                        onTap: () async {
                                          ProductoCacheModel item =
                                              ProductoCacheModel(
                                            id: producto.id ?? 0,
                                            nombre: producto.nombre ??
                                                'No hay nombre',
                                            precio:
                                                producto.precio?.toString() ??
                                                    'No hay precio',
                                            foto:
                                                producto.foto ?? 'No hay foto',
                                            cantidad: 1,
                                          );
                                          cartService.addToCart(item);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: themeProvider.isDiurno
                                                ? themeColors[0]
                                                : themeColors[0],
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.shopping_bag_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
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
                    ],
                  );
                }).toList(),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
