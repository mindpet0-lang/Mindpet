import { Component, signal, OnInit } from '@angular/core';
import { ForoService } from '../services/foro.service';

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

  // manejo de nuevo post
  newPostContent: string = '';
  selectedImage: string | null = null;

  constructor(private foroService: ForoService) {}

  ngOnInit() {
    this.loadPosts();
  }

  // 🔥 TRAER POSTS DESDE BACKEND
  loadPosts() {
    this.foroService.getForos().subscribe((data: any[]) => {
      const postsConvertidos: Post[] = data.map((f) => ({
        id: f.id,
        author: f.titulo,       
        content: f.descripcion,
        image: '',
        likes: [],
      }));

      this.posts.set(postsConvertidos);
    });
  }
  login() {
    this.isLoggedIn.set(true);
    this.currentUser.set('Usuario');
  }

  // Maneja la carga de imágenes desde el input file
  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (e: any) => {
      this.selectedImage = e.target.result;
    };
    reader.readAsDataURL(file);
  }

  // 🔥 PUBLICAR EN BACKEND
  publishPost() {
  if (!this.currentUser()) {
    alert("Debes iniciar sesión");
    return;
  }

  if (!this.newPostContent.trim()) return;

  console.log("Enviando:", this.newPostContent);

  const foro = {
    titulo: this.currentUser(),
    descripcion: this.newPostContent
  };

  this.foroService.crearForo(foro).subscribe({
    next: () => {
      console.log("POST CREADO ✅");
      this.loadPosts();
      this.newPostContent = '';
      this.selectedImage = null;
    },
    error: (err) => {
      console.error("ERROR BACKEND ❌", err);
    }
  });
}

  // ❤️ LIKE CON BACKEND
  toggleLike(postId: number) {
    const user = this.currentUser()!;
     if (!this.isLoggedIn()) {
      alert("Para MindPet, tu interacción es importante. ¡Inicia sesión para dar amor! 🐾");
      return;
    }

    this.posts.update((posts) =>
      posts.map((p) => {
        if (p.id === postId) {
          const hasLiked = p.likes.includes(user);
          return {
            ...p,
            likes: hasLiked ? p.likes.filter((u) => u !== user) : [...p.likes, user],
          };
        }
        return p;
      }),
    );
  }

  
}
