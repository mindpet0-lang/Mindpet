package com.example.mindPet.Controller;

import com.example.mindPet.Model.Chat;
import com.example.mindPet.Model.ComidaMascota;
import com.example.mindPet.Service.ComidaMascotaService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/comidas-mascota")
@CrossOrigin(origins = "*")
public class ComidaMascotaController {

    private final ComidaMascotaService comidaMascotaService;

    public ComidaMascotaController(ComidaMascotaService comidaMascotaService) {
        this.comidaMascotaService = comidaMascotaService;
    }

    @GetMapping
    public List<ComidaMascota> listarComidasMascota() {
        return comidaMascotaService.obtenerComidasMascota();
    }

    @PostMapping
    public ComidaMascota guardarComidaMascota(@RequestBody ComidaMascota comidaMascota) {
        return comidaMascotaService.guardarComidaMascota(comidaMascota);
    }

    @PutMapping("/{id}")
    public ComidaMascota actualizarComidaMascota(@PathVariable int id, @RequestBody ComidaMascota comidaMascota) {
        return comidaMascotaService.actualizarComidaMascota(id, comidaMascota);
    }

    @DeleteMapping("/{id}")
    public void eliminarComidaMascota(@PathVariable int id) {
        comidaMascotaService.eliminarComidaMascota(id);
    }
}