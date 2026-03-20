import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { UserRegister } from '../models/usuarios.model';
import { tap } from 'rxjs/operators';
import { LoginRequest, LoginResponse } from '../models/usuarios.model';

@Injectable({
  providedIn: 'root',
})
export class AuthService {

    private API_URL = 'http://localhost:8080/usuarios';


  constructor(private http: HttpClient) {}

  register(userData: UserRegister): Observable<any> {
    return this.http.post(`${this.API_URL}/register`, userData);
  }

  login (credentials: LoginRequest): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.API_URL}/login`, credentials).pipe(
      tap(res => {
        // Guardamos el token en el almacenamiento local del navegador
        localStorage.setItem('token', res.token);
        localStorage.setItem('user', JSON.stringify(res.usuario));
      })
    );
  }

  // Método extra para saber si está logueado
  isLoggedIn(): boolean {
    return !!localStorage.getItem('token');
  }
  
}
