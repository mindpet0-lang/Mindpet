package com.example.mindPet.Controller;

import com.example.mindPet.Model.Inventario;
import com.example.mindPet.Service.InventarioService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/inventario")
@CrossOrigin(origins = "*")
public class InventarioController {

    private final InventarioService service;

    public InventarioController(InventarioService service) {
        this.service = service;
    }

    @GetMapping
    public List<Inventario> listar() {
        return service.listar();
    }

    @PostMapping
    public Inventario guardar(@RequestBody Inventario inventario) {
        return service.guardar(inventario);
    }

    @PutMapping("/{id}")
    public Inventario actualizar(@PathVariable int id, @RequestBody Inventario inventario) {
        return service.actualizar(id, inventario);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable int id) {
        service.eliminar(id);
    }
}