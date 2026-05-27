# 🧠🐾 MINDPET

## Descripción del proyecto

**MINDPET** es una aplicación diseñada para acompañar a personas con problemas de salud mental relacionados con el bienestar emocional.

El sistema permite:

* Registrar usuarios
* Consultar información
* Actualizar datos
* Eliminar usuarios

Todo esto mediante una API REST conectada a una base de datos MySQL.

El proyecto implementa una arquitectura Cliente-Servidor, donde el backend desarrollado en Spring Boot gestiona la lógica y la conexión con la base de datos.

---

# 👥 Integrantes

* Laura Sofia Martinez
* Juan Diego Solano
* Isabella Valentina Sanchez
* Sarid Nicole Quiroga

---

# 💻 Frontend del proyecto

El proyecto cuenta con dos interfaces frontend desarrolladas para diferentes plataformas.

## 🌐 Frontend Web

Desarrollado con Angular, permite acceder al sistema desde navegadores web mediante una interfaz moderna e interactiva.

### Funcionalidades principales

* Registro e inicio de sesión
* Gestión de usuario
* Cambio de contraseña
* Personalización de foto de perfil
* Participación en foros
* Diario emocional
* Inventario y tienda
* Consumo de API REST
* Autenticación con JWT

---

## 📱 Frontend Móvil

Desarrollado con Flutter, permite utilizar la aplicación desde dispositivos móviles Android.

### Funcionalidades principales

* Interfaz interactiva
* Sistema de mascotas virtuales
* Registro emocional y diario
* Gestión de inventario
* Conexión con API REST
* Persistencia de sesión mediante JWT

---

# 🏗️ Arquitectura del proyecto

El sistema MindPet implementa una arquitectura Cliente-Servidor compuesta por:

* Backend en Spring Boot
* Frontend web en Angular
* Frontend móvil en Flutter
* Base de datos MySQL

Los frontends consumen los servicios expuestos por la API REST del backend para gestionar toda la información del sistema.

---

# ⚙️ Cómo instalar el proyecto

## Requisitos previos

Antes de ejecutar el proyecto, verificar que estén instalados:

* Node.js
* npm
* Angular CLI
* Flutter SDK
* Java JDK
* Maven
* MySQL
* Un navegador web actualizado

---

# 🌐 Instalación Frontend

## Clonar el repositorio

```bash
git clone https://github.com/mindpet0-lang/mindpet.git
```

## Abrir el proyecto

Abrir el proyecto en:

* Visual Studio Code

---

## Angular

### Ir a la carpeta del proyecto

```bash
cd frontend/mindpet_page/mindpet
```

### Instalar dependencias

```bash
npm install
```

### Ejecutar el proyecto

```bash
ng serve
```

### Abrir en el navegador

```bash
http://localhost:4200
```

---

## Flutter

### Ir a la carpeta del proyecto

```bash
cd frontend-app/fluttermindpet/flutter/mindpet
```

### Instalar dependencias

```bash
flutter pub get
```

### Ejecutar la aplicación

```bash
flutter run
```

Luego seleccionar el dispositivo o entorno donde se desea ejecutar la aplicación.

> En algunos equipos con Windows pueden presentarse errores de compatibilidad.
> Por esta razón, se recomienda ejecutar la aplicación en un navegador web o en un dispositivo Android.

---

# ⚙️ Instalación Backend

## Clonar el repositorio

```bash
git clone https://github.com/mindpet0-lang/backend_mindpet.git
```

## Abrir el proyecto

Abrir el proyecto en:

* IntelliJ IDEA
* Visual Studio Code

---

## Instalar dependencias

El proyecto utiliza Maven para la gestión de dependencias.

Las dependencias se descargan automáticamente desde el archivo `pom.xml`.

En IntelliJ IDEA se puede seleccionar:

* Load Maven Project
* Reload Maven Project

---

## Configurar la base de datos

Configurar MySQL y verificar las credenciales de conexión en el archivo de configuración del proyecto.

---

## Ejecutar el backend

Ejecutar la clase principal:

```bash
MindPetApplication.java
```

El servidor iniciará correctamente y permitirá acceder a los endpoints del backend.

---

# 🛠️ Tecnologías utilizadas

* Java
* Spring Boot
* Maven
* MySQL
* JWT
* JPA / Hibernate
* Angular
* Flutter

---

# 📂 Estructura del proyecto

El proyecto está organizado por capas:

* Controller
* Service
* Repository
* Model
* Config

---

# 🚀 Funcionalidades principales

* Gestión de usuarios
* Gestión de mascotas
* Sistema de foros
* Diario emocional
* Inventario
* Seguridad con JWT

---

# 📸 Evidencias del funcionamiento

El proyecto permite gestionar diferentes módulos relacionados con mascotas, usuarios y funcionalidades del sistema MindPet.

### Evidencias incluidas

* Configuración del backend en Spring Boot
* Gestión de dependencias con Maven
* Estructura organizada por capas
* Conexión con MySQL
* Implementación de seguridad con JWT
* Capturas y pruebas funcionales

Las evidencias del funcionamiento pueden visualizarse mediante la ejecución local del proyecto desde la clase principal:

```bash
MindPetApplication.java
```
