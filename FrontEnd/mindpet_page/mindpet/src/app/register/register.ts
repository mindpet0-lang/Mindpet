import { Component, inject } from '@angular/core';
import { FormGroup, FormControl, Validators, AbstractControl, ValidationErrors } from '@angular/forms';
import { AuthService } from '../services/auth-service';
import { Router } from '@angular/router';

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
        this.registerForm.markAllAsTouched();
        // Extraemos solo los datos que la API espera
        const { contrasenaC, ...userData } = this.registerForm.value;
  
        this.authService.register(userData).subscribe({
          next: (response) => {
            console.log('¡Registro exitoso!', response);
            alert('Usuario registrado correctamente');
             this.router.navigate(['/login']);
          },
          error: (err) => {
            console.error('Error en el registro', err);
            alert('Hubo un error al registrar: ' + err.error.message);
          }
        });
      } else {
        this.registerForm.markAllAsTouched();
      }
    }


}
