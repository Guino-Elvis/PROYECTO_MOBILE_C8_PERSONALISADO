package com.example.ventas.entity;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Imagen {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String url;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "producto_id", nullable = true, foreignKey = @ForeignKey(name = "fk_producto_imagen", value = ConstraintMode.CONSTRAINT))
    @JsonIgnoreProperties({ "hibernateLazyInitializer", "handler" })
    private Producto producto;

}
