package com.example.mindPet.Controller;

import com.example.mindPet.Model.Diario;
import com.example.mindPet.Service.DiarioService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/diarios")
@CrossOrigin(origins = "*")
public class DiarioController {

    private final DiarioService diarioService;

    public DiarioController(DiarioService diarioService) {
        this.diarioService = diarioService;
    }

    @GetMapping
    public List<Diario> listarDiarios() {
        return diarioService.obtenerDiarios();
    }

    @PostMapping
    public Diario guardarDiario(@RequestBody Diario diario) {
        return diarioService.guardarDiario(diario);
    }

    @PutMapping("/{id}")
    public Diario actualizarDiario(@PathVariable int id, @RequestBody Diario diario) {
        return diarioService.actualizarDiario(id, diario);
    }

    @DeleteMapping("/{id}")
    public void eliminarDiario(@PathVariable int id) {
        diarioService.eliminarDiario(id);
    }
}