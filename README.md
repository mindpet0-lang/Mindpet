🧠🐾 MINDPET

MINDPET es una aplicación diseñada para acompañar a personas con problemas de salud mental relacionada con el bienestar emocional.
El sistema permite registrar, consultar, actualizar y eliminar usuarios mediante una API REST conectada a una base de datos MySQL.

Este proyecto implementa una arquitectura Cliente-Servidor donde el backend en Spring Boot gestiona la lógica y la conexión con la base de datos.

Integrantes

Laura Sofia Martinez
Juan Diego Solano
Isabella Valentina Sanchez
Sarid Nicole Quiroga

Frontend del proyecto

El proyecto también cuenta con dos interfaces frontend desarrolladas para diferentes plataformas:

Frontend Web

Desarrollado con Angular, permite acceder al sistema desde navegadores web mediante una interfaz moderna e interactiva.

Funcionalidades principales del frontend web:

Registro e inicio de sesión de usuarios
Gestión de usuario, como cambio de contraseña y personalización de la foto de perfil
Visualización y participación en foros
Diario emocional
Inventario y tienda
Consumo de la API REST del backend
Autenticación segura con JWT

Frontend Móvil

Desarrollado con Flutter, permite utilizar la aplicación desde dispositivos móviles Android.

Funcionalidades principales del frontend móvil:

Interfaz interactiva y amigable
Sistema de mascotas virtuales
Registro de emociones y diario
Gestión de inventario
Conexión con el backend mediante API REST
Persistencia de sesión con JWT
Arquitectura completa del proyecto

El sistema MindPet implementa una arquitectura Cliente-Servidor compuesta por:

Backend en Spring Boot
Frontend web en Angular
Frontend móvil en Flutter
Base de datos MySQL

Los frontends consumen los servicios expuestos por la API REST del backend para gestionar toda la información del sistema.

COMO INSTALAR EL PROYECTO:

Requisitos previos

Antes de ejecutar el proyecto, verificar que estén instalados:

Node.js
npm
Angular CLI
Flutter SDK
Un navegador web actualizado

FRONTEND:

1. Clonar el repositorio
git clone https://github.com/mindpet0-lang/mindpet.git

Abrir el proyecto
Abrir el proyecto en un entorno de desarrollo compatible como:

Visual Studio Code 3. Instalar dependencias

Para angular en la terminal ir a la carpeta de angular:
cd frontend/mindpet_page/mindpet

y ejecuta npm install 

para ejecutar el proyecto ejecuta: ng serve

Una vez iniciado correctamente, la aplicación podrá visualizarse desde el navegador en:
http://localhost:4200

Para flutter en al terminal ir a la carpeta de la aplicación:
cd frontend-app/fluttermindpet/flutter/mindpet

y ejecuta flutter pub get 

para ejecutar el proyecto ejecuta: flutter run 

Luego seleccionar el dispositivo o entorno donde se desea ejecutar la aplicación.
En algunos equipos con Windows pueden presentarse errores de compatibilidad. Por esta razón, se recomienda ejecutar la aplicación en un navegador web o en un dispositivo Android.


1. Clonar el repositorio
git clone https://github.com/mindpet0-lang/backend_mindpet.git

Abrir el proyecto
Abrir el proyecto en un entorno de desarrollo compatible con Java como:

IntelliJ IDEA Visual Studio Code 3. Instalar dependencias

El proyecto utiliza Maven para la gestión de dependencias. Las dependencias se descargan automáticamente desde el archivo pom.xml.

En IntelliJ IDEA se puede seleccionar:

Load Maven Project Reload Maven Project 4. Configurar la base de datos

Configurar MySQL y verificar las credenciales de conexión en el archivo de configuración del proyecto.

Ejecutar el proyecto
Ejecutar la clase principal:

MindPetApplication.java

El servidor iniciará correctamente y permitirá acceder a los endpoints del backend.

Tecnologías utilizadas Java Spring Boot Maven MySQL JWT JPA / Hibernate Estructura del proyecto

El proyecto está organizado por capas:

Controller Service Repository Model Config Funcionalidades principales Gestión de usuarios Gestión de mascotas Sistema de foros Diario de mascotas Inventario Seguridad con JWT

Ejecución local
1 Clonar el repositorio:

git clone https://github.com/mindpet0-lang/backend_mindpet.git

2 Abrir el proyecto en IntelliJ IDEA o Visual Studio Code. 3 Verificar que Java JDK y Maven estén instalados. 4 Descargar las dependencias Maven desde el archivo pom.xml. 5 Configurar la conexión a MySQL en el archivo de propiedades del proyecto. 6 Ejecutar la clase principal: MindPetApplication.java

7 Esperar a que Spring Boot inicie correctamente.

El backend quedará ejecutándose localmente en el puerto configurado del proyecto.

Evidencias
Funcionamiento del proyecto
El proyecto permite gestionar diferentes módulos relacionados con mascotas, usuarios y funcionalidades del sistema MindPet.

Evidencias incluidas
Configuración del backend en Spring Boot.
Gestión de dependencias con Maven.
Estructura organizada por capas.
Conexión con base de datos MySQL.
Implementación de seguridad con JWT.
Capturas o pruebas
Las evidencias del funcionamiento pueden visualizarse mediante la ejecución local del proyecto desde la clase principal MindPetApplication.java.
