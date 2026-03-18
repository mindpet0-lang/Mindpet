package com.example.mindPet.Controller;

import com.example.mindPet.Model.AccionMascota;
import com.example.mindPet.Service.AccionMascotaService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/acciones-mascota")
@CrossOrigin(origins = "*")
public class AccionMascotaController {

    private final AccionMascotaService service;

    public AccionMascotaController(AccionMascotaService service){
        this.service = service;
    }

    @GetMapping
    public List<AccionMascota> listar(){
        return service.listar();
    }

    @PostMapping
    public AccionMascota guardar(@RequestBody AccionMascota accion){
        return service.guardar(accion);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable int id){
        service.eliminar(id);
    }
}