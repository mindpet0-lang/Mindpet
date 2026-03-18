package com.example.mindPet.Controller;

import com.example.mindPet.Model.Usuario;
import com.example.mindPet.Service.UsuarioService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/usuarios")
@CrossOrigin(origins = "*")
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @GetMapping
    public List<Usuario> listarUsuarios() {
        return usuarioService.obtenerUsuarios();
    }

    @PostMapping
    public Usuario guardarUsuario(@RequestBody Usuario usuario) {
        return usuarioService.guardarUsuario(usuario);
    }

    @PutMapping("/{id}")
    public Usuario actualizarUsuario(@PathVariable int id, @RequestBody Usuario usuario){
        return usuarioService.actualizarUsuario(id, usuario);
    }

    @DeleteMapping("/{id}")
    public void eliminarUsuario(@PathVariable int id) {
        usuarioService.eliminarUsuario(id);
    }
}