package com.example.mindPet.Controller;

import com.example.mindPet.Model.Chat;
import com.example.mindPet.Service.ChatService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/chats")
@CrossOrigin(origins = "*")
public class ChatController {

    private final ChatService service;

    public ChatController(ChatService service){
        this.service = service;
    }

    @GetMapping
    public List<Chat> listar(){
        return service.listar();
    }

    @PostMapping
    public Chat guardar(@RequestBody Chat chat){
        return service.guardar(chat);
    }

    @PutMapping("/{id}")
    public Chat actualizar(@PathVariable int id,@RequestBody Chat chat){
        return service.actualizar(id,chat);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable int id){
        service.eliminar(id);
    }
}
