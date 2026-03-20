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
    this.foroService.getForos().subscribe((data: any[]) => {

      const postsConvertidos = data.map(f => ({
        id: f.id,
        author: f.author,        // 🔥 usa backend real
        content: f.content,
        image: f.image,
        likes: f.likes || []
      }));

      this.posts.set(postsConvertidos);
    });
  }

<<<<<<< HEAD
  // ... Resto de tus métodos (publishPost, toggleLike, etc.) igual ...
=======
  login() {
    console.log("CLICK FUNCIONA");
    this.isLoggedIn.set(true);
    this.currentUser.set('Usuario');
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

  // 🔥 PUBLICAR
  publishPost() {

    if (!this.currentUser()) {
      alert("Debes iniciar sesión");
      return;
    }

    if (!this.newPostContent.trim()) return;

    const foro = {
      author: this.currentUser(),
      content: this.newPostContent,
      image: this.selectedImage,
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

  // ❤️ LIKE
  toggleLike(postId: number) {

    if (!this.isLoggedIn()) {
      const irLogin = confirm("Debes iniciar sesión para dar like 🐾\n\n¿Quieres ir a iniciar sesión?");

      if (irLogin) {
        window.location.href = "/login";
      }
      return;
    }

    const user = this.currentUser();

    if (!user) {
      alert("Error con el usuario");
      return;
    }

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
  }

  // 🗑️ ELIMINAR POST
  eliminarPost(id: number) {
    const confirmacion = confirm("¿Seguro que quieres eliminar este post?");

    if (!confirmacion) return;

    this.foroService.eliminarForo(id).subscribe({
      next: () => {
        this.loadPosts();
      },
      error: (err: any) => {
        console.error("Error eliminando ❌", err);
      }
    });
  }

  // ✏️ ACTIVAR EDICIÓN
  editarPost(post: Post) {
    this.editandoPostId = post.id;
    this.editContent = post.content;
  }

  // 💾 GUARDAR EDICIÓN
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
      error: (err) => {
        console.error("Error editando ❌", err);
      }
    });
  }
>>>>>>> e35108e6ff23b1f81e61221c2308386b9ed058b9
}