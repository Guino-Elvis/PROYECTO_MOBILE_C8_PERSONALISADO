package com.example.ventas.config;

import com.example.ventas.entity.Categoria;
import com.example.ventas.entity.Producto;
import com.example.ventas.entity.SubCategoria;
import com.example.ventas.repository.CategoriaRepository;
import com.example.ventas.repository.SubCategoriaRepository;
import com.example.ventas.repository.ProductoRepository;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Component
public class DataSeeder implements CommandLineRunner {

    private final CategoriaRepository categoriaRepo;
    private final SubCategoriaRepository subCategoriaRepo;
    private final ProductoRepository productoRepo;

    public DataSeeder(CategoriaRepository categoriaRepo,
                      SubCategoriaRepository subCategoriaRepo,
                      ProductoRepository productoRepo) {
        this.categoriaRepo = categoriaRepo;
        this.subCategoriaRepo = subCategoriaRepo;
        this.productoRepo = productoRepo;
    }

    @Override
    public void run(String... args) {
      
        productoRepo.deleteAll();
        subCategoriaRepo.deleteAll();
        categoriaRepo.deleteAll();

        for (int i = 1; i <= 5; i++) {
            Categoria categoria = new Categoria();
            categoria.setNombre("Categoria " + i);
            categoria.setTag("CAT" + i);
            categoria.setFoto("");
            categoria.setEstado("activo");
            categoria.setCreatedAt(LocalDateTime.now());
            categoria.setUpdatedAt(LocalDateTime.now());
            categoriaRepo.save(categoria);

            for (int j = 1; j <= 2; j++) {
                SubCategoria sub = new SubCategoria();
                sub.setNombre("SubCategoria " + i + "." + j);
                sub.setCategoria(categoria);
                sub.setEstado("activo");
                sub.setCreatedAt(LocalDateTime.now());
                sub.setUpdatedAt(LocalDateTime.now());
                subCategoriaRepo.save(sub);

                for (int k = 1; k <= 2; k++) {
                    Producto prod = new Producto();
                    prod.setNombre("Producto " + i + "." + j + "." + k);
                    prod.setDescrip("Descripción del producto " + i + "." + j + "." + k);
                    prod.setPrecio(10.0 + k);
                    prod.setStock("Disponible");
                    prod.setFoto("");
                    prod.setSubCategoria(sub);
                    prod.setEstado("activo");
                    prod.setCreatedAt(LocalDateTime.now());
                    prod.setUpdatedAt(LocalDateTime.now());
                    productoRepo.save(prod);
                }
            }
        }

        System.out.println("✅ Base de datos poblada con categorías, subcategorías y productos de prueba.");
       
    }
}