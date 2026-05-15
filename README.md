🧠🐾 MINDPET

MINDPET es una aplicación diseñada para acompañar a personas con problemas de salud mental relacionada con el bienestar emocional.
El sistema permite registrar, consultar, actualizar y eliminar usuarios mediante una API REST conectada a una base de datos MySQL.

Este proyecto implementa una arquitectura Cliente-Servidor donde el backend en Spring Boot gestiona la lógica y la conexión con la base de datos.

Integrantes
Laura Sofia Martinez
Juan Diego Solano
Isabella Valentina Sanchez
Sarid Nicole Quiroga
1. Clonar el repositorio
git clone https://github.com/mindpet0-lang/backend_backup.git

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

git clone https://github.com/mindpet0-lang/backend_backup.git

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
