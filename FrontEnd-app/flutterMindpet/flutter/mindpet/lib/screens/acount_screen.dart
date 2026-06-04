import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart'; // Tu modelo de usuario con el campo 'monedas'
import '../services/api_service.dart'; // Tu ApiService con la baseUrl corregida
import 'login_screen.dart'; // Asegúrate de importar tu pantalla de Login real

class AccountScreen extends StatefulWidget {
  final int userId;

  const AccountScreen({super.key, required this.userId});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<Usuario?> _futureUsuario;

  @override
  void initState() {
    super.initState();
    // Dispara la petición HTTP al inicializar la pantalla usando el int userId
    _futureUsuario = ApiService.obtenerUsuarioPorId(widget.userId);
  }

  // Función local para limpiar la sesión de SharedPreferences
  Future<void> _handleCerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Fondo azul claro limpio
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: Botón atrás (Flecha recta y sin borde morado) y Título
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Cuenta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tarjeta Blanca Principal controlada por el FutureBuilder
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: FutureBuilder<Usuario?>(
                    future: _futureUsuario,
                    builder: (context, snapshot) {
                      // 1. Estado de carga de la API de Spring Boot
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // 2. Si hay error o el usuario no existe en la BD (404)
                      if (snapshot.hasError || snapshot.data == null) {
                        return const Center(
                          child: Text(
                            'No se pudieron cargar los datos del usuario.',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        );
                      }

                      // 3. Datos obtenidos con éxito
                      final usuario = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sección del Perfil Dinámica (Avatar + Datos de la BD)
                          Row(
                            children: [
                              usuario.foto_perfil == 'Sin foto de perfil'
                                  ? ClipOval(
                                      child: Image.asset(
                                        'assets/images/sin-foto.png',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit
                                            .cover, // Ajusta la imagen para llenar el círculo sin deformarse
                                      ),
                                    )
                                  : ClipOval(
                                      child: Image.network(
                                        usuario.foto_perfil,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit
                                            .cover, // Ajusta la imagen de red perfectamente
                                        // Muestra un indicador de carga mientras se descarga la imagen
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return SizedBox(
                                                width: 60,
                                                height: 60,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(
                                                    8.0,
                                                  ), // Margen para que el loader no toque los bordes
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                              );
                                            },

                                        // Muestra un ícono si ocurre un error al cargar la imagen
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors
                                                .grey[200], // Fondo sutil para el error
                                            child: const Icon(
                                              Icons.error,
                                              size:
                                                  24, // Ajustado al tamaño de 50 del contenedor
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nombre real desde Java
                                    Text(
                                      usuario.nombre,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),

                                    const SizedBox(height: 4),
                                    // Correo real desde Java
                                    Text(
                                      usuario.correo,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Monedas en tiempo real de tu entidad Usuario
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.monetization_on,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${usuario.monedas} monedas',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Botón de Cerrar Sesión
                          OutlinedButton(
                            onPressed: () async {
                              // Mostrar diálogo de confirmación antes de salir
                              bool confirmar =
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Cerrar Sesión'),
                                      content: const Text(
                                        '¿Estás seguro de que deseas salir de MindPet?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text(
                                            'Cancelar',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text(
                                            'Salir',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;

                              // Si confirma, limpia SharedPreferences y va al Login
                              if (confirmar) {
                                await _handleCerrarSesion();

                                if (mounted) {
                                  // Redirige eliminando todo el historial de pantallas hacia atrás
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.logout_rounded,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Cerrar Sesión',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
