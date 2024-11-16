package com.example.ventas.service.impl;


import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.ventas.entity.Entrega;
import com.example.ventas.repository.EntregaRepository;
import com.example.ventas.service.EntregaService;


@Service
public class EntregaServiceImpl implements EntregaService{
        @Autowired
    private EntregaRepository entregaRepository;



    @Override
    public List<Entrega> listar() {
        return entregaRepository.findAll();
    }

    @Override
    public Entrega guardar(Entrega entrega) {
        return entregaRepository.save(entrega);
    }

    @Override
    public Entrega actualizar(Entrega entrega) {

        return entregaRepository.save(entrega);
    }

    @Override
    public Optional<Entrega> listarPorId(Integer id) {
        return entregaRepository.findById(id);
    }

    @Override
    public void eliminarPorId(Integer id) {
        entregaRepository.deleteById(id);
    }
}
