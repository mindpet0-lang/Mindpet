import { Component } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';

@Component({
  selector: 'app-register',
  standalone: false,
  templateUrl: './register.html',
  styleUrl: './register.css',
})
export class Register {
  registerForm: FormGroup;
  nombre: FormControl;
  correo: FormControl;
  contrasena: FormControl;
  contrasenaC: FormControl;
  fechaNacimiento: FormControl;
  terminos: FormControl;

  constructor(){
    this.nombre = new FormControl('', Validators.required);
    this.correo = new FormControl('', [Validators.required, Validators.email]);
    this.contrasena = new FormControl('', Validators.required);
    this.contrasenaC = new FormControl('', Validators.required);
    this.fechaNacimiento = new FormControl('', Validators.required)
    this.terminos = new FormControl('', Validators.requiredTrue)

    this.registerForm = new FormGroup({
      nombre: this.nombre,
      correo: this.correo,
      contrasena: this.contrasena,
      contraseñaC: this.contrasenaC,
      fechaNacimiento: this.fechaNacimiento,
      terminos: this.terminos
    })
  }

  handleSubmit(): void{
    console.log(this.registerForm);
  }
}
