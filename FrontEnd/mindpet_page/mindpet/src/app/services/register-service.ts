import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { UserRegister } from '../models/usuarios.model';

@Injectable({
  providedIn: 'root'
})
export class RegisterService{  
  private API_URL = 'http://localhost:12346/usuarios';

  constructor(private http: HttpClient) {}

  register(userData: UserRegister): Observable<any> {
    return this.http.post(`${this.API_URL}/register`, userData);
  }
}