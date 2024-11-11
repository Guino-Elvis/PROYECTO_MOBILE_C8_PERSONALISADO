package com.example.ventas.service.impl;



import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ventas.entity.Imagen;
import com.example.ventas.entity.Producto;
import com.example.ventas.repository.ImagenRepository;
import com.example.ventas.service.ImagenService;

import jakarta.persistence.EntityNotFoundException;

@Service
public class ImagenServiceImpl implements ImagenService{
    
    @Autowired
    private ProductoServiceImpl productoService;

    @Autowired
    private ImagenRepository imagenRepository;

    @Override
    public List<Imagen> listar() {
        return imagenRepository.findAll();
    }

    @Override
    public Imagen guardar(Imagen imagen) {
        return imagenRepository.save(imagen);
    }

    @Override
    public Imagen actualizar(Imagen imagen) {

        Imagen imagenExistente = imagenRepository.findById(imagen.getId())
                .orElseThrow(() -> new EntityNotFoundException("Imagen no encontrado"));
        // Solo actualiza los campos que deseas cambiar
        imagenExistente.setUrl(imagen.getUrl());
        // Guarda los cambios
        return imagenRepository.save(imagenExistente);
    }

    @Override
    public Optional<Imagen> listarPorId(Integer id) {
        return imagenRepository.findById(id);
    }

    @Override
    public void eliminarPorId(Integer id) {
        imagenRepository.deleteById(id);
    }

    @Override
    public List<Imagen> listarPorProducto(Integer idProducto) {
        // Obtener la lista de Imagens por categoría directamente desde el
        // repositorio
        return imagenRepository.findByProductoId(idProducto);
    }
}
