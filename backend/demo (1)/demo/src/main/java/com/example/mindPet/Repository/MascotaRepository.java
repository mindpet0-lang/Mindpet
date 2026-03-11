package com.example.mindPet.Repository;

import com.example.mindPet.Model.Mascota;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MascotaRepository extends JpaRepository<Mascota, Long>  {
}
