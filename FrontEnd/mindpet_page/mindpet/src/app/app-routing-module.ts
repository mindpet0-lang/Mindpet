import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { Login } from './login/login';
import { Home } from './home/home';
import { Welcome } from './welcome/welcome';
import { Register } from './register/register';

const routes: Routes = [
  { path: "", component: Home },
{ path: 'login', component: Login },
{ path: 'welcome', component: Welcome },
{ path: 'register', component: Register}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
