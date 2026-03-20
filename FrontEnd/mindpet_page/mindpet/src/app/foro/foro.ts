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

  constructor(private foroService: ForoService) { }

  ngOnInit() {
    this.loadPosts();
  }

  // 🔥 TRAER POSTS DESDE BACKEND
  loadPosts() {
    this.foroService.getForos().subscribe((data: Post[]) => {
      this.posts.set(data); // 🔥 DIRECTO
    });
  }

login() {
  console.log("CLICK FUNCIONA");
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

    const foro: Post = {
      id: 0,
      author: this.currentUser()!,
      content: this.newPostContent,
      image: this.selectedImage || '',
      likes: []
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
  if (!this.isLoggedIn()) {
    alert("Para MindPet, tu interacción es importante 🐾\nInicia sesión para dar amor ❤️");
    return;
  }

  const user = this.currentUser()!;
  const post = this.posts().find(p => p.id === postId);
  if (!post) return;

  const hasLiked = post.likes.includes(user);

  const updatedPost: Post = {
    ...post,
    likes: hasLiked
      ? post.likes.filter(u => u !== user)
      : [...post.likes, user]
  };

  this.foroService.actualizarForo(post.id, updatedPost).subscribe(() => {
    this.loadPosts(); // 🔥 sincroniza con BD
  });
}

}
