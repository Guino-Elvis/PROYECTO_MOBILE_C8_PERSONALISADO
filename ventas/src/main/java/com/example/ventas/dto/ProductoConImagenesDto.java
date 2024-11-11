package com.example.ventas.dto;

import java.util.List;

import com.example.ventas.entity.Imagen;
import com.example.ventas.entity.Producto;

import lombok.Data;

@Data
public class ProductoConImagenesDto {
    private Producto producto;     // El producto
    private List<Imagen> imagenes; // Las imágenes asociadas a ese producto
}
