import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../services/auth-service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-login',
  standalone: false,
  templateUrl: './login.html',
  styleUrl: './login.css',
})
export class Login {
  private fb = inject(FormBuilder);
  private authService = inject(AuthService);
  private router = inject(Router);

  // Definimos la estructura del formulario
  loginForm: FormGroup = this.fb.group({
    correo: ['', [Validators.required, Validators.email]],
    contrasena: ['', Validators.required]
  });

  // Getters para facilitar la lectura en el HTML
  get correo() { return this.loginForm.get('correo'); }
  get contrasena() { return this.loginForm.get('contrasena'); }

  onLogin() {
    if (this.loginForm.valid) {
      // Mostramos un mensaje de espera
      Swal.fire({
        title: 'Cargando...',
        didOpen: () => { Swal.showLoading(); }
      });

      this.authService.login(this.loginForm.value).subscribe({
        next: (res) => {
          Swal.close(); // Cerramos el cargando
          
          Swal.fire({
            icon: 'success',
            title: '¡Bienvenido!',
            text: `Hola ${res.usuario.nombre}`,
            timer: 1500,
            showConfirmButton: false
          }).then(() => {
            this.router.navigate(['/home']); // Cambia '/home' por tu ruta real
          });
        },
        error: (err) => {
          Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Credenciales incorrectas o problema de conexión.'
          });
        }
      });
    }
  }
}
