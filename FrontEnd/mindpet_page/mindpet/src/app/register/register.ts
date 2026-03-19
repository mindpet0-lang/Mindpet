import { Component, inject } from '@angular/core';
import { FormGroup, FormControl, Validators, AbstractControl, ValidationErrors } from '@angular/forms';
import { AuthService } from '../services/auth-service';
import { Router } from '@angular/router';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-register',
  standalone: false,
  templateUrl: './register.html',
  styleUrl: './register.css',
})
export class Register {
  private authService = inject(AuthService);
  private router = inject(Router);

  registerForm: FormGroup;

  nombre: FormControl;
  correo: FormControl;
  contrasena: FormControl;
  contrasenaC: FormControl;
  fechaNacimiento: FormControl;
  terminos: FormControl;

  constructor(){

    this.nombre = new FormControl('', Validators.required);

    this.correo = new FormControl('', [
      Validators.required,
      Validators.email
    ]);

    this.contrasena = new FormControl('', [
      Validators.required,
      Validators.minLength(8),
      Validators.pattern(/^(?=.*[A-Z])(?=.*[0-9]).*$/)
    ]);

    this.contrasenaC = new FormControl('', Validators.required);

    this.fechaNacimiento = new FormControl('', Validators.required);

    this.terminos = new FormControl(false, Validators.requiredTrue);


    this.registerForm = new FormGroup(
      {
        nombre: this.nombre,
        correo: this.correo,
        contrasena: this.contrasena,
        contrasenaC: this.contrasenaC,
        fechaNacimiento: this.fechaNacimiento,
        terminos: this.terminos
      },
      {
        validators: [
          this.passwordMatchValidator,
          this.edadValidator
        ]
      }
    );
  }


  // VALIDAR QUE LAS CONTRASEÑAS COINCIDAN
  passwordMatchValidator(control: AbstractControl): ValidationErrors | null {

    const pass = control.get('contrasena')?.value;
    const confirm = control.get('contrasenaC')?.value;

    if(pass !== confirm){
      return { passwordMismatch: true };
    }

    return null;
  }


  // VALIDAR EDAD MINIMA 13
  edadValidator(control: AbstractControl): ValidationErrors | null {

    const fecha = control.get('fechaNacimiento')?.value;

    if(!fecha) return null;

    const hoy = new Date();
    const nacimiento = new Date(fecha);

    let edad = hoy.getFullYear() - nacimiento.getFullYear();
    const mes = hoy.getMonth() - nacimiento.getMonth();

    if(mes < 0 || (mes === 0 && hoy.getDate() < nacimiento.getDate())){
      edad--;
    }

    if(edad < 13){
      return { menorEdad: true };
    }

    return null;
  }

   handleSubmit() {
  if (this.registerForm.valid) {
    const { contrasenaC, ...userData } = this.registerForm.value;

    this.authService.register(userData).subscribe({
      next: (response) => {
        // AQUÍ VA EL ALERT BONITO
        Swal.fire({
          title: '¡Registro Exitoso!',
          text: `Bienvenido/a ${userData.nombre}, tu cuenta ha sido creada.`,
          imageUrl: 'assets/images/logo.png', 
          imageHeight: '150px',
          confirmButtonText: 'Genial',
          confirmButtonColor: '#62C6E2', // Puedes poner el color de tu marca
          backdrop: `
            rgba(0,0,123,0.4)
            url("assets/images/nyan-cat.gif") 
            left top
            no-repeat
          ` // El backdrop opcional oscurece el fondo
        }).then((result) => {
          if (result.isConfirmed) {
            this.router.navigate(['/login']);
          }
        });
      },
      error: (err) => {
        // Alert de error por si Mockoon falla o el correo ya existe
        Swal.fire({
          title: 'Error',
          text: 'No se pudo completar el registro. Intenta más tarde.',
          icon: 'error',
          confirmButtonText: 'Entendido'
        });
      }
    });
  }
}

}
