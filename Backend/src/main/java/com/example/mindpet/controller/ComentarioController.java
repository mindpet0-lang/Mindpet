package com.example.mindPet.Controller;

import com.example.mindPet.Model.Comentario;
import com.example.mindPet.Service.ComentarioService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/comentarios")
@CrossOrigin(origins = "*")
public class ComentarioController {

    private final ComentarioService service;

    public ComentarioController(ComentarioService service){
        this.service = service;
    }

    @GetMapping
    public List<Comentario> listar(){
        return service.listar();
    }

    @PostMapping
    public Comentario guardar(@RequestBody Comentario comentario){
        return service.guardar(comentario);
    }

    @PutMapping("/{id}")
    public Comentario actualizar(@PathVariable int id,@RequestBody Comentario comentario){
        return service.actualizar(id,comentario);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable int id){
        service.eliminar(id);
    }
}