import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:front_flutter_api_rest/src/model/productoModel.dart';

class ProductoImageSlider extends StatelessWidget {
  final ProductoModel producto;
  final double? height; // altura opcional

  const ProductoImageSlider({
    Key? key,
    required this.producto,
    this.height, // valor opcional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageWidgets = _buildImageList(producto);
    final double sliderHeight = height ?? 150; // usa 150 si no se especifica

    return SizedBox(
      height: sliderHeight,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: sliderHeight,
              autoPlay: imageWidgets.length > 1,
              autoPlayInterval: const Duration(seconds: 3),
              viewportFraction: 1.0,
              enlargeCenterPage: false,
            ),
            items: imageWidgets,
          ),

          // ❤️ Icono de corazón (arriba a la derecha)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite_border, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildImageList(ProductoModel producto) {
    List<String> urls = [];

    // Imagen principal
    if (producto.foto?.isNotEmpty == true &&
        Uri.tryParse(producto.foto!)?.hasAbsolutePath == true) {
      urls.add(producto.foto!);
    }

    // Imágenes adicionales
    if (producto.imagenes != null && producto.imagenes!.isNotEmpty) {
      urls.addAll(
        producto.imagenes!
            .where((img) =>
                img != null &&
                img.url != null &&
                img.url!.isNotEmpty &&
                Uri.tryParse(img.url!)?.hasAbsolutePath == true)
            .map((img) => img.url!)
            .toList(),
      );
    }

    // Si no hay imágenes válidas
    if (urls.isEmpty) {
      return [
        Image.asset(
          'assets/nofoto.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ];
    }

    // Construir imágenes renderizables
    return urls
        .map(
          (url) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (_, __) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) =>
                  Image.asset('assets/nofoto.jpg', fit: BoxFit.cover),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        )
        .toList();
  }
}
