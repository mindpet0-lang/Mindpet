package com.example.mindPet.Controller;

import com.example.mindPet.Model.Rol;
import com.example.mindPet.Service.RolService;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/roles")
@CrossOrigin(origins = "*")
public class RolController {

    private final RolService service;

    public RolController(RolService service) {
        this.service = service;
    }

    @GetMapping
    public List<Rol> listar() {
        return service.listar();
    }

    @PostMapping
    public Rol guardar(@RequestBody Rol rol) {
        return service.guardar(rol);
    }

    @PutMapping("/{id}")
    public Rol actualizar(@PathVariable int id, @RequestBody Rol rol) {
        return service.actualizar(id, rol);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable int id) {
        service.eliminar(id);
    }
}