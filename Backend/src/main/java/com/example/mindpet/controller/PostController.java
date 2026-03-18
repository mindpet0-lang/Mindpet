package com.example.mindPet.Controller;

import com.example.mindPet.Model.Post;
import com.example.mindPet.Service.PostService;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/posts")
@CrossOrigin(origins = "*")
public class PostController {

    private final PostService service;

    public PostController(PostService service) {
        this.service = service;
    }

    @GetMapping
    public List<Post> listar() {
        return service.listar();
    }

    @PostMapping
    public Post guardar(@RequestBody Post post) {
        return service.guardar(post);
    }

    @PutMapping("/{id}")
    public Post actualizar(@PathVariable int id, @RequestBody Post post) {
        return service.actualizar(id, post);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable int id) {
        service.eliminar(id);
    }
}