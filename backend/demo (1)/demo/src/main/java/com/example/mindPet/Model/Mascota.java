package com.example.mindPet.Model;

import jakarta.persistence.*;

@Entity
@Table(name = "mascotas")
public class Mascota {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long usuario_id;
    private String nombre;
    private String tipo;
    private int felicidad;
    private int salud;
    private int hambre;
    private int energia;

}
