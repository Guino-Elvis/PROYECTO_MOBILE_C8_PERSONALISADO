import 'package:front_flutter_api_rest/src/cache/ProductoCacheModel.dart';
import 'package:front_flutter_api_rest/src/model/imagenModel.dart';

class ProductoModel {
  int? id;
  String? nombre;
  String? descrip;
  double? precio;
  String? stock;
  String? foto;
  Map<String, dynamic>? subCategoria;
  List<Imagenes>? imagenes;
  String? estado;
  String? createdAt;
  String? updatedAt;
  // Constructor
  ProductoModel({
    this.id,
    this.nombre,
    this.descrip,
    this.precio,
    this.stock,
    this.foto,
    this.subCategoria,
    this.imagenes,
    this.estado,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor para crear una instancia desde un JSON
  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'] as int?,
      nombre: json['nombre'] as String?,
      descrip: json['descrip'] as String?,
      precio: json['precio'] as double?,
      stock: json['stock'] as String?,
      foto: json['foto'] as String?,
      subCategoria: json['subCategoria'] as Map<String, dynamic>?,
      imagenes: json['imagenes'] != null
          ? (json['imagenes'] as List).map((v) => Imagenes.fromJson(v)).toList()
          : null,
      estado: json['estado'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  factory ProductoModel.fromCacheModel(ProductoCacheModel cache) {
    return ProductoModel(
      id: cache.id,
      nombre: cache.nombre,
      descrip: null,
      foto: cache.foto,
      subCategoria: null,
      imagenes: null,
      estado: null,
      createdAt: null,
      updatedAt: null,
    );
  }

  // Convertir la instancia a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descrip': descrip,
      'precio': precio,
      'stock': stock,
      'foto': foto,
      'subCategoria': subCategoria,
      'estado': estado,
    };
  }
}
