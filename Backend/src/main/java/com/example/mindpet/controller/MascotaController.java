package com.example.mindPet.Controller;

import com.example.mindPet.Model.Mascota;
import com.example.mindPet.Service.MascotaService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/mascotas")
@CrossOrigin(origins = "*")
public class MascotaController {

    private final MascotaService service;

    public MascotaController(MascotaService service) {
        this.service = service;
    }

    @GetMapping
    public List<Mascota> listar() {
        return service.listar();
    }

    @PostMapping
    public Mascota guardar(@RequestBody Mascota mascota) {
        return service.guardar(mascota);
    }

    @PutMapping("/{id}")
    public Mascota actualizar(@PathVariable int id, @RequestBody Mascota mascota) {
        return service.actualizar(id, mascota);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable int id) {
        service.eliminar(id);
    }
}