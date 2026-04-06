import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router'; 
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
  private route = inject(ActivatedRoute); 

  loginForm: FormGroup = this.fb.group({
    correo: ['', [Validators.required, Validators.email]],
    contrasena: ['', Validators.required]
  });

  get correo() { return this.loginForm.get('correo'); }
  get contrasena() { return this.loginForm.get('contrasena'); }

  onLogin() {
    if (this.loginForm.valid) {

      Swal.fire({
        title: 'Cargando...',
        didOpen: () => { Swal.showLoading(); }
      });

      this.authService.login(this.loginForm.value).subscribe({
        next: (res) => {
          Swal.close();

          // GUARDAR DATOS DE FORMA SEGURA
          localStorage.setItem("user_token", res.token || 'true');
          // Guardamos el objeto completo convertido a texto JSON
          localStorage.setItem("user", JSON.stringify(res.usuario));
          // token para dejar pasar
          localStorage.setItem("user_token", res.token || 'true');

          Swal.fire({
            icon: 'success',
            title: '¡Bienvenido!',
            text: `Hola ${res.usuario.nombre}`,
            timer: 1500,
            showConfirmButton: false
          }).then(() => {

            const returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/home';

            this.router.navigateByUrl(returnUrl);
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