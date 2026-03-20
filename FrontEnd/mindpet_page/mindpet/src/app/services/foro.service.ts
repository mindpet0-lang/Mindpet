import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Foro {
  id: number;
  author: string;
  content: string;
  image?: string;
  likes: string[];
}

@Injectable({
  providedIn: 'root',
})
export class ForoService {

  private apiUrl = 'http://localhost:8080/foros';

  constructor(private http: HttpClient) {}

  getForos(): Observable<Foro[]> {
    return this.http.get<Foro[]>(this.apiUrl);
  }

  crearForo(foro: any): Observable<any> {
    return this.http.post<Foro>(this.apiUrl, foro);
  }

  actualizarForo(id: number, foro: Foro): Observable<Foro> {
    return this.http.put<Foro>(`${this.apiUrl}/${id}`, foro);
  }
}