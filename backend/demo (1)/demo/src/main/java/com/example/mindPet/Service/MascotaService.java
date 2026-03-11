package com.example.mindPet.Service;

import com.example.mindPet.Model.Mascota;
import com.example.mindPet.Repository.MascotaRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MascotaService {

    private final MascotaRepository mascotaRepository;

    public MascotaService(MascotaRepository mascotaRepository){
        this.mascotaRepository = mascotaRepository;
    }

    public List<Mascota> obtenerMascotas(){
        return mascotaRepository.findAll();
    }

    public Mascota guardarMascota(Mascota mascota){
        return mascotaRepository.save(mascota);
    }

    public void eliminarMascota(Long id){
        mascotaRepository.deleteById(id);
    }
}
