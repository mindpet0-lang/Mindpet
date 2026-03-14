import { Component, signal } from '@angular/core';

interface Post {
  id: number;
  author: string;
  content: string;
  image?: string;
  likes: string[]; // IDs de usuarios que dieron like
}

@Component({
  selector: 'app-foro',
  standalone: false, // Mantengo tu configuración original
  templateUrl: './foro.html',
  styleUrl: './foro.css',
})
export class Foro {
  // --- ESTADO DEL FORO ---
  // Usamos signals para que la UI reaccione instantáneamente
  isLoggedIn = signal<boolean>(false);
  currentUser = signal<string | null>(null);
  posts = signal<Post[]>([]);

  // --- MODELOS PARA EL FORMULARIO ---
  newPostContent: string = '';
  selectedImage: string | null = null;

  // --- MÉTODOS ---

  // Simula el inicio de sesión en MindPet
  login() {
    this.isLoggedIn.set(true);
    this.currentUser.set('Usuario_MindPet'); 
  }

  // Maneja la carga de imágenes desde el input file
  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e: any) => {
        this.selectedImage = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }

  // Publica un nuevo comentario
  publishPost() {
    if (!this.newPostContent.trim()) return;

    const newPost: Post = {
      id: Date.now(),
      author: this.currentUser()!,
      content: this.newPostContent,
      image: this.selectedImage || undefined,
      likes: []
    };

    // Agregamos el post al inicio del array
    this.posts.update(current => [newPost, ...current]);

    // Limpiamos el formulario
    this.newPostContent = '';
    this.selectedImage = null;
  }

  // Lógica de Like Único
  toggleLike(postId: number) {
    if (!this.isLoggedIn()) {
      alert("Para MindPet, tu interacción es importante. ¡Inicia sesión para dar amor! 🐾");
      return;
    }

    const user = this.currentUser()!;

    this.posts.update(allPosts => 
      allPosts.map(post => {
        if (post.id === postId) {
          const hasLiked = post.likes.includes(user);
          return {
            ...post,
            likes: hasLiked 
              ? post.likes.filter(id => id !== user) // Si ya tenía like, lo quita
              : [...post.likes, user]               // Si no, lo agrega
          };
        }
        return post;
      })
    );
  }
}