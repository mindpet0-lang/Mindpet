package com.example.mindPet.Controller;

import com.example.mindPet.Model.Mascota;
import com.example.mindPet.Service.MascotaService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/mascotas")
@CrossOrigin
public class MascotaController {

    private final MascotaService mascotaService;

    public MascotaController(MascotaService mascotaService){
        this.mascotaService = mascotaService;
    }

    @GetMapping
    public List<Mascota> listarMascotas(){
        return mascotaService.obtenerMascotas();
    }

    @PostMapping
    public Mascota crearMascota(@RequestBody Mascota mascota){
        return mascotaService.guardarMascota(mascota);
    }

    @DeleteMapping("/{id}")
    public void eliminarMascota(@PathVariable Long id){
        mascotaService.eliminarMascota(id);
    }
}
