package com.example.mindPet.Controller;

import com.example.mindPet.Model.EstadoAnimo;
import com.example.mindPet.Service.EstadoAnimoService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/estados-animo")
@CrossOrigin(origins = "*")
public class EstadoAnimoController {

    private final EstadoAnimoService estadoAnimoService;

    public EstadoAnimoController(EstadoAnimoService estadoAnimoService) {
        this.estadoAnimoService = estadoAnimoService;
    }

    @GetMapping
    public List<EstadoAnimo> listarEstados() {
        return estadoAnimoService.obtenerEstados();
    }

    @PostMapping
    public EstadoAnimo guardarEstado(@RequestBody EstadoAnimo estado) {
        return estadoAnimoService.guardarEstado(estado);
    }

    @PutMapping("/{id}")
    public EstadoAnimo actualizarEstado(@PathVariable int id, @RequestBody EstadoAnimo estado) {
        return estadoAnimoService.actualizarEstado(id, estado);
    }

    @DeleteMapping("/{id}")
    public void eliminarEstado(@PathVariable int id) {
        estadoAnimoService.eliminarEstado(id);
    }
}