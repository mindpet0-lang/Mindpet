import { Component, signal, OnInit } from '@angular/core';
import { ForoService } from '../services/foro.service';
import { AuthService } from '../services/auth-service';
import { Router } from '@angular/router';
import { LoginResponse } from '../models/usuarios.model';
import Swal from 'sweetalert2';

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
  // Signals para el estado del foro
  isLoggedIn = signal<boolean>(false);
  currentUser = signal<string | null>(null);
  posts = signal<Post[]>([]);

  // 🔥 Lógica del Menú de Usuario
  isMenuOpen = false;
  user: LoginResponse['usuario'] | null = null;

  // Manejo de nuevo post
  newPostContent: string = '';
  selectedImage: string | null = null;

  // Edición de posts
  editandoPostId: number | null = null;
  editContent: string = '';

  constructor(
    private foroService: ForoService,
    private authService: AuthService,
    private router: Router
  ) { }

  ngOnInit() {
    this.cargarDatosUsuario();
    this.loadPosts();
  }

  // Carga el usuario desde localStorage y maneja posibles errores de formato
  cargarDatosUsuario() {
    const userData = localStorage.getItem("user");

    if (userData) {
      try {
        const parsed = JSON.parse(userData);
        // Si el parseo es exitoso, asignamos el objeto completo
        this.user = parsed;
        this.currentUser.set(this.user?.nombre || 'Usuario');
        this.isLoggedIn.set(true);
      } catch (e) {
        // Si el dato era texto plano (como "laura sofia"), creamos un objeto compatible
        console.warn("Datos de usuario en texto plano, convirtiendo...");
        this.user = { id: 0, nombre: userData, correo: 'Sin correo' };
        this.currentUser.set(userData);
        this.isLoggedIn.set(true);
      }
    }
  }

  // Control del menú desplegable
  onProfileClick() {
    this.isMenuOpen = !this.isMenuOpen;
  }

  // Cierre de sesión
 onLogout() {
  // 1. Limpieza de datos
  localStorage.removeItem('token');
  localStorage.removeItem('user');
  this.isMenuOpen = false;

  // 2. Alerta y Recarga
  Swal.fire({
    icon: 'success',
    title: '¡Hecho!',
    text: `Sesión cerrada correctamente`,
    timer: 1500,
    showConfirmButton: false
  }).then(() => {
    // 3. Forzar la recarga total a la página de login o inicio
    window.location.href = '/foro'; 
    // O si prefieres quedarte en la misma pero limpia:
    // window.location.reload();
  });
}

  // Traer posts desde el backend
  loadPosts() {
    this.foroService.getForos().subscribe((data: Post[]) => {
      this.posts.set(data);
    });
  }


  login() {
    this.router.navigate(['/login']);
  }

  // Maneja la carga de imágenes
  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (e: any) => {
      this.selectedImage = e.target.result;
    };
    reader.readAsDataURL(file);
  }

  // Publicar nuevo post
  publishPost() {
    if (!this.isLoggedIn()) {
      alert("Debes iniciar sesión");
      return;
    }

    if (!this.newPostContent.trim()) return;

    const foro: Post = {
      id: 0,
      author: this.currentUser()!,
      content: this.newPostContent,
      image: this.selectedImage || '',
      likes: []
    };

    this.foroService.crearForo(foro).subscribe({
      next: () => {
        this.loadPosts();
        this.newPostContent = '';
        this.selectedImage = null;
      },
      error: (err) => {
        console.error("ERROR BACKEND ❌", err);
      }
    });
  }

  // ❤️ Dar/Quitar Like
  toggleLike(postId: number) {
    if (!this.isLoggedIn()) {
      const irLogin = confirm("Debes iniciar sesión para dar like 🐾\n\n¿Quieres ir a iniciar sesión?");
      if (irLogin) this.router.navigate(['/login']);
      return;
    }

    const user = this.currentUser();
    if (!user) return;

    this.posts.update((posts) =>
      posts.map((p) => {
        if (p.id === postId) {
          const hasLiked = p.likes.includes(user);
          return {
            ...p,
            likes: hasLiked
              ? p.likes.filter((u) => u !== user)
              : [...p.likes, user],
          };
        }
        return p;
      })
    );
    // Nota: Aquí deberías llamar a un servicio para persistir el like en el backend
  }

  // Eliminar Post
  eliminarPost(id: number) {
    const confirmacion = confirm("¿Seguro que quieres eliminar este post?");
    if (!confirmacion) return;

    this.foroService.eliminarForo(id).subscribe({
      next: () => this.loadPosts(),
      error: (err: any) => console.error("Error eliminando ❌", err)
    });
  }

  // Activar Edición
  editarPost(post: Post) {
    this.editandoPostId = post.id;
    this.editContent = post.content;
  }

  // Guardar Edición
  guardarEdicion(post: Post) {
    const actualizado: Post = {
      ...post,
      content: this.editContent
    };

    this.foroService.actualizarForo(post.id, actualizado).subscribe({
      next: () => {
        this.editandoPostId = null;
        this.editContent = '';
        this.loadPosts();
      },
      error: (err) => console.error("Error editando ❌", err)
    });
  }
}