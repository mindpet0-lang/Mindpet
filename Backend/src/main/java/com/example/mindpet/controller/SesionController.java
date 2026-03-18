package com.example.mindPet.Controller;

import com.example.mindPet.Model.Sesion;
import com.example.mindPet.Service.SesionService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/sesiones")
@CrossOrigin(origins = "*")
public class SesionController {

    private final SesionService service;

    public SesionController(SesionService service) {
        this.service = service;
    }

    @GetMapping
    public List<Sesion> listar() {
        return service.listar();
    }

    @PostMapping
    public Sesion guardar(@RequestBody Sesion sesion) {
        return service.guardar(sesion);
    }

    @PutMapping("/{id}")
    public Sesion actualizar(@PathVariable int id, @RequestBody Sesion sesion) {
        return service.actualizar(id, sesion);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable int id) {
        service.eliminar(id);
    }
}