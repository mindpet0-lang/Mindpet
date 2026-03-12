import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-foro',
  standalone: false,
  templateUrl: './foro.html',
  styleUrl: './foro.css',
})
export class Foro {
postForm: FormGroup;

  posts:any[] = [];

  constructor(private fb:FormBuilder){

    this.postForm = this.fb.group({
      contenido:['',Validators.required]
    });

  }

  crearPost(){

    if(this.postForm.invalid) return;

    const nuevoPost = {

      usuario:"Usuario",
      fecha:new Date().toLocaleDateString(),
      contenido:this.postForm.value.contenido,
      likes:0,
      comentarios:[],
      nuevoComentario:''

    };

    this.posts.unshift(nuevoPost);

    this.postForm.reset();

  }

  darLike(post:any){

    post.likes++;

  }

  agregarComentario(post:any){

    if(!post.nuevoComentario) return;

    post.comentarios.push({

      usuario:"Usuario",
      texto:post.nuevoComentario

    });

    post.nuevoComentario='';

  }
}
