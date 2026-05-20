import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { ForoService } from '../services/foro';
import { Publicacion,Comentario} from '../models/publicacion.model';
import { Location } from '@angular/common';
import { Router } from '@angular/router';
import { User } from '../models/usuarios.model';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-foro',
  standalone:false,
  templateUrl: './foro.html',
  styleUrls: ['./foro.css']
})
export class Foro implements OnInit {
  // Arreglo donde se guardan las publicaciones
  publicaciones: Publicacion[] = [];
  
  // Variables para la creación de publicaciones
  nuevoContenido: string = '';
  idUsuarioLogueado: number = 1; 
  guardando: boolean = false; 

  // Variables para controlar la eliminación
  publicacionIdParaBorrar: number | null = null;

  // Variables para controlar la edición
  publicacionIdParaEditar: number | null = null;
  contenidoEditado: string = '';

  //Variables menu de perfil
  isMenuOpen = false;
  user: User | null = null;

  //Variables imagenes
  imagenSeleccionada:File | null = null;
  previsualizacionUrl:string | null = null;

  constructor(
    private foroService: ForoService,
    private cdr: ChangeDetectorRef,
    private location: Location,
    private router: Router
  ) { }

  ngOnInit(): void {
    this.cargarUsuarioSesion();
  }

  //carga el perfil
cargarUsuarioSesion(): void {
    const userData = localStorage.getItem('user');
    
    if (userData) {
      try {
        const parsedData = JSON.parse(userData);
        if (typeof parsedData === 'object' && parsedData !== null) {
          this.user = parsedData;
          
          
          if (this.user && this.user.id) {
            this.idUsuarioLogueado = this.user.id; 
          }
        } else {
          this.idUsuarioLogueado = 1; 
        }
      } catch (e) {
        this.idUsuarioLogueado = 1;
      }
    } else {
      this.idUsuarioLogueado = 1;
    }
    
    
    this.cargarPublicaciones(); 
  }

  //modulos Menu Perfil
  onProfileClick(): void {
    this.isMenuOpen = !this.isMenuOpen;
    this.cdr.detectChanges();
  }

  toggleMenu(): void {
    this.isMenuOpen = !this.isMenuOpen;
    this.cdr.detectChanges();
  }

  onLogout(): void {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    this.isMenuOpen = false;

    Swal.fire({
      icon: 'success',
      title: '¡Hecho!',
      text: `Sesión cerrada correctamente`,
      timer: 1500,
      showConfirmButton: false
    }).then(() => {
      window.location.href = '/home'; // Te redirige al Home limpio
    });
  }

  //seleccionar imagen
  onFileSelected(event: any):void{
    const file = event.target.files[0];
    if(file){
      this.imagenSeleccionada = file;

      const reader = new FileReader();
      reader.onload = () => {
        this.previsualizacionUrl = reader.result as string;
        this.cdr.detectChanges;
      };
      reader.readAsDataURL(file)
    }
  }

  //limpiar imagen
  limpiarImagen(): void {
    this.imagenSeleccionada = null;
    this.previsualizacionUrl= null;
    this.cdr.detectChanges();
  }


  // 1. LISTAR PUBLICACIONES
cargarPublicaciones(): void {
    this.publicaciones = []; 
    this.foroService.getPublicaciones(this.idUsuarioLogueado).subscribe({
      next: (data) => {
        this.publicaciones = data.sort((a, b) => (b.id || 0) - (a.id || 0));
        
        // Buscamos los comentarios para cada una
        this.publicaciones.forEach(pub => {
          pub.comentarios = [];
          pub.nuevoComentarioTexto = ''; // Inicializamos su caja de texto vacía
          if (pub.id) {
            this.foroService.getComentarios(pub.id, this.idUsuarioLogueado).subscribe(coms => {
              pub.comentarios = coms;
              this.cdr.detectChanges();
            });
          }
        });
        this.cdr.detectChanges();
      }
    });
  }

  agregarComentario(pub: any): void {
    if (!pub.nuevoComentarioTexto || !pub.nuevoComentarioTexto.trim()) return;

    const nuevoCom: Comentario = {
      contenido: pub.nuevoComentarioTexto,
      publicacion: { id: pub.id },
      usuario: { id: this.idUsuarioLogueado }
    };

    this.foroService.crearComentario(nuevoCom).subscribe({
      next: (comentarioGuardado) => {
        // Le inyectamos los datos visuales de la sesión local activa al momento
        comentarioGuardado.usuario = {
          id: this.idUsuarioLogueado,
          nombre: this.user?.nombre || 'Usuario Anónimo',
          fotoPerfil: this.user?.fotoPerfil
        };
        comentarioGuardado.totalLikes = 0;
        comentarioGuardado.leDioLike = false;

        pub.comentarios.push(comentarioGuardado); // Se añade al final del hilo de respuestas
        pub.nuevoComentarioTexto = ''; // Limpiamos la caja
        this.cdr.detectChanges();
      }
    });
  }

  darLikeComentario(com: Comentario): void {
    if (!com.id) return;
    this.foroService.alternarLikeComentario(com.id, this.idUsuarioLogueado).subscribe({
      next: (nuevoTotal) => {
        com.totalLikes = nuevoTotal;
        com.leDioLike = !com.leDioLike;
        this.cdr.detectChanges();
      }
    });
  }

  // 2. CREAR (PUBLICAR)
 publicar(): void {
    if (!this.nuevoContenido.trim() && !this.imagenSeleccionada) return;
    if (this.guardando) return;

    this.guardando = true;
    this.cdr.detectChanges();

    // Si hay una imagen, la subimos primero
    if (this.imagenSeleccionada) {
      this.foroService.subirImagenPublicacion(this.imagenSeleccionada).subscribe({
        next: (res) => {
          // Guardamos el texto y la URL de la imagen junta separada por un marcador especial [IMG]
          const contenidoFinal = `${this.nuevoContenido} [IMG]${res.fotoPerfil}[/IMG]`;
          this.enviarPublicacionAlBackend(contenidoFinal);
        },
        error: (err) => {
          console.error('Error al subir la imagen', err);
          this.guardando = false;
          this.cdr.detectChanges();
        }
      });
    } else {
      // Si no hay imagen, se publica solo el texto normal
      this.enviarPublicacionAlBackend(this.nuevoContenido);
    }
  }

  private enviarPublicacionAlBackend(contenido: string): void {
    const nuevaPub: Publicacion = {
      contenido: contenido,
      usuario: { id: this.idUsuarioLogueado }
    };

    this.foroService.crearPublicacion(nuevaPub).subscribe({
      next: (publicacionGuardada) => {
        this.nuevoContenido = '';
        this.limpiarImagen();
        this.guardando = false;

        publicacionGuardada.usuario = {
          id: this.idUsuarioLogueado,
          nombre: this.user?.nombre || 'Usuario Anónimo',
          fotoPerfil: this.user?.fotoPerfil
        };
        

        publicacionGuardada.totalLikes = 0;
        publicacionGuardada.leDioLike = false;

        this.publicaciones.unshift(publicacionGuardada);
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('Error al publicar', err);
        this.guardando = false;
        this.cdr.detectChanges();
      }
    });
  }

  //metodos para imgs

  obtenerTextoLimpio(contenido: string): string {
    if (contenido.includes(' [IMG]')) {
      return contenido.split(' [IMG]')[0];
    }
    return contenido;
  }

  // Helper para el HTML: extrae la URL de la imagen si existe
  obtenerImagenUrl(contenido: string): string | null {
    if (contenido.includes('[IMG]') && contenido.includes('[/IMG]')) {
      const inicio = contenido.indexOf('[IMG]') + 5;
      const fin = contenido.indexOf('[/IMG]');
      return contenido.substring(inicio, fin);
    }
    return null;
  }

  // 3. ELIMINAR (PASO A PASO)
  solicitarEliminar(id?: number): void {
    if (!id) return;
    this.publicacionIdParaBorrar = id;
    this.cdr.detectChanges(); // Muestra el cartel "Sí/No" al primer clic
  }

  cancelarEliminar(): void {
    this.publicacionIdParaBorrar = null;
    this.cdr.detectChanges();
  }

  confirmarEliminar(): void {
    if (!this.publicacionIdParaBorrar) return;

    const idABorrar = this.publicacionIdParaBorrar;

    this.foroService.eliminarPublicacion(idABorrar).subscribe({
      next: () => {
        this.publicacionIdParaBorrar = null;
        // Elimina el elemento del arreglo local al instante
        this.publicaciones = this.publicaciones.filter(pub => pub.id !== idABorrar);
        this.cdr.detectChanges(); 
      },
      error: (err) => {
        console.error('Error al eliminar', err);
        this.publicacionIdParaBorrar = null;
        this.cdr.detectChanges();
      }
    });
  }

  // 4. EDITAR (PASO A PASO)
 activarEdicion(contenidoActual: string, id?: number): void {
    if (!id) return;
    this.publicacionIdParaEditar = id;
    this.contenidoEditado = contenidoActual; // Rellena el textarea con el texto viejo
    this.cdr.detectChanges();
  }

  cancelarEdicion(): void {
    this.publicacionIdParaEditar = null;
    this.contenidoEditado = '';
    this.cdr.detectChanges();
  }

  guardarEdicion(pub: Publicacion): void {
    if (!this.contenidoEditado.trim() || !pub.id) return;

    const pubActualizada: Publicacion = {
      ...pub,
      contenido: this.contenidoEditado
    };

    this.foroService.editarPublicacion(pub.id, pubActualizada).subscribe({
      next: (resultado) => {
        // Busca la publicación en la lista y cambia su texto en tiempo real
        const index = this.publicaciones.findIndex(p => p.id === pub.id);
        if (index !== -1) {
          this.publicaciones[index] = resultado;
        }
        this.cancelarEdicion(); // Cierra el modo edición
      },
      error: (err) => console.error('Error al editar', err)
    });
  }

  darLike(pub: Publicacion): void {
    if (!pub.id) return;

    this.foroService.alternarLike(pub.id, this.idUsuarioLogueado).subscribe({
      next: (nuevoTotal) => {
        // Actualizamos la tarjeta en tiempo real localmente
        pub.totalLikes = nuevoTotal;
        pub.leDioLike = !pub.leDioLike;
        this.cdr.detectChanges(); // Refresco instantáneo de pantalla
      },
      error: (err) => console.error('Error al procesar el like', err)
    });
  }

  volverAtras(): void {
    this.location.back();
  }
}