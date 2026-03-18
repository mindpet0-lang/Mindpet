package com.example.mindPet.Controller;

import com.example.mindPet.Model.MensajeChat;
import com.example.mindPet.Service.MensajeChatService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/mensajes")
@CrossOrigin(origins = "*")
public class MensajeChatController {

    private final MensajeChatService service;

    public MensajeChatController(MensajeChatService service) {
        this.service = service;
    }

    @GetMapping
    public List<MensajeChat> listar() {
        return service.listar();
    }

    @PostMapping
    public MensajeChat guardar(@RequestBody MensajeChat mensaje) {
        return service.guardar(mensaje);
    }

    @PutMapping("/{id}")
    public MensajeChat actualizar(@PathVariable int id, @RequestBody MensajeChat mensaje) {
        return service.actualizar(id, mensaje);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable int id) {
        service.eliminar(id);
    }
}