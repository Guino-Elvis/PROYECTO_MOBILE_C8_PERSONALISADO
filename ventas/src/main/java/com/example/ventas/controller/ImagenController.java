package com.example.ventas.controller;

import java.util.List;
import org.springframework.web.bind.annotation.*;

import com.example.ventas.entity.Imagen;
import com.example.ventas.service.ImagenService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/imagen")
public class ImagenController {

    @Autowired
    private ImagenService imagenService;

    @GetMapping("/imagenPorSubCategoria/{idProducto}")
    public ResponseEntity<List<Imagen>> listarImagenPorProducto(@PathVariable Integer idProducto) {
        List<Imagen> Imagens = imagenService.listarPorProducto(idProducto);
        return ResponseEntity.ok(Imagens);
    }

    @GetMapping()
    public ResponseEntity<List<Imagen>> list() {
        return ResponseEntity.ok().body(imagenService.listar());
    }

    @PostMapping()
    public ResponseEntity<Imagen> save(@RequestBody Imagen imagen) {
        return ResponseEntity.ok(imagenService.guardar(imagen));
    }

    @PutMapping()
    public ResponseEntity<Imagen> update(@RequestBody Imagen imagen) {
        return ResponseEntity.ok(imagenService.actualizar(imagen));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Imagen> listById(@PathVariable(required = true) Integer id) {
        return ResponseEntity.ok().body(imagenService.listarPorId(id).get());
    }

    @DeleteMapping("/{id}")
    public String deleteById(@PathVariable(required = true) Integer id) {
        imagenService.eliminarPorId(id);
        return "Eliminacion Correcta de item";
    }
}
