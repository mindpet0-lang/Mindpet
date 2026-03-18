package com.example.mindPet.Controller;

import com.example.mindPet.Model.EstadoMascota;
import com.example.mindPet.Service.EstadoMascotaService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/estado-mascota")
@CrossOrigin(origins = "*")
public class EstadoMascotaController {

    private final EstadoMascotaService estadoMascotaService;

    public EstadoMascotaController(EstadoMascotaService estadoMascotaService) {
        this.estadoMascotaService = estadoMascotaService;
    }

    @GetMapping
    public List<EstadoMascota> listarEstadosMascota() {
        return estadoMascotaService.obtenerEstadosMascota();
    }

    @PostMapping
    public EstadoMascota guardarEstadoMascota(@RequestBody EstadoMascota estadoMascota) {
        return estadoMascotaService.guardarEstadoMascota(estadoMascota);
    }

    @PutMapping("/{id}")
    public EstadoMascota actualizarEstadoMascota(@PathVariable int id, @RequestBody EstadoMascota estadoMascota) {
        return estadoMascotaService.actualizarEstadoMascota(id, estadoMascota);
    }

    @DeleteMapping("/{id}")
    public void eliminarEstadoMascota(@PathVariable int id) {
        estadoMascotaService.eliminarEstadoMascota(id);
    }
}