import { Component, signal, OnInit } from '@angular/core';
import { ForoService } from '../services/foro.service';
import { AuthService } from '../services/auth-service'; // 🔥 Importante
import { Router } from '@angular/router';
import { LoginResponse } from '../models/usuarios.model'; // 🔥 Importante

interface Post {
  id: number;
  author: string;
  content: string;
  image?: string;
  likes: string[];
}

@Component({
  selector: 'app-foro',
  standalone: false,
  templateUrl: './foro.html',
  styleUrls: ['./foro.css'],
})
export class Foro implements OnInit {
  isLoggedIn = signal<boolean>(false);
  currentUser = signal<string | null>(null);
  posts = signal<Post[]>([]);

  // 🔥 NUEVO: Manejo del menú de usuario
  isMenuOpen = false;
  user: LoginResponse['usuario'] | null = null;

  newPostContent: string = '';
  selectedImage: string | null = null;
  editandoPostId: number | null = null;
  editContent: string = '';

  constructor(
    private foroService: ForoService,
    private authService: AuthService, // 🔥 Inyectamos AuthService
    private router: Router             // 🔥 Inyectamos Router
  ) { }

  ngOnInit() {
    this.cargarDatosUsuario();
    this.loadPosts();
  }

  // 🔥 NUEVO: Carga robusta del usuario
  cargarDatosUsuario() {
    const userData = localStorage.getItem("user");
    if (userData) {
      try {
        this.user = JSON.parse(userData);
        if (this.user) {
          this.currentUser.set(this.user.nombre);
          this.isLoggedIn.set(true);
        }
      } catch (e) {
        console.error("Error al cargar usuario del foro", e);
        this.user = { id: 0, nombre: userData, correo: 'Sin correo' };
        this.currentUser.set(userData);
        this.isLoggedIn.set(true);
      }
    }
  }

  // 🔥 NUEVO: Función para el botón de perfil
  onProfileClick() {
    this.isMenuOpen = !this.isMenuOpen;
  }

  // 🔥 NUEVO: Función para cerrar sesión
  onLogout() {
    this.authService.logout(); // Limpia localStorage
    this.isMenuOpen = false;
    this.isLoggedIn.set(false);
    this.user = null;
    this.router.navigate(['/login']);
  }

  loadPosts() {
    this.foroService.getForos().subscribe((data: Post[]) => {
      this.posts.set(data);
    });
  }

  // ... Resto de tus métodos (publishPost, toggleLike, etc.) igual ...
}