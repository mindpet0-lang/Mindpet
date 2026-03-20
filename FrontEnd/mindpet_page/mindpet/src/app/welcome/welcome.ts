import { Component, inject, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-welcome',
  standalone: false,
  templateUrl: './welcome.html',
  styleUrl: './welcome.css',
})
export class Welcome implements OnInit {

// 1. DECLARAR LA PROPIEDAD AQUÍ (Esto quita el error TS2339)
  returnUrl: string = '/foro'; 

  private route = inject(ActivatedRoute);

  ngOnInit() {
    // 2. CAPTURAR EL VALOR
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/foro';
    console.log('Ruta destino capturada:', this.returnUrl);
  }
}
