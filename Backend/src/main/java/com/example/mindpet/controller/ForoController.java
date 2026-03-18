package com.example.mindPet.Controller;

import com.example.mindPet.Model.Foro;
import com.example.mindPet.Service.ForoService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/foros")
@CrossOrigin(origins = "*")
public class ForoController {

    private final ForoService service;

    public ForoController(ForoService service) {
        this.service = service;
    }

    @GetMapping
    public List<Foro> listar() {
        return service.listar();
    }

    @PostMapping
    public Foro guardar(@RequestBody Foro foro) {
        return service.guardar(foro);
    }

    @PutMapping("/{id}")
    public Foro actualizar(@PathVariable int id, @RequestBody Foro foro) {
        return service.actualizar(id, foro);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable int id) {
        service.eliminar(id);
    }
}