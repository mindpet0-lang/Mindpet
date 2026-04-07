import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindPet Login',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mantenemos el fondo blanco puro para que coincida con tu ilustración
      backgroundColor: Colors.white, 
      body: Stack(
        children: [
          // 1. ILUSTRACIÓN DE FONDO (Alineada abajo)
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'images/imagen-terapia.png', // Verifica que esta ruta sea correcta
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
              // Calidad alta para evitar la línea de división
              filterQuality: FilterQuality.high,
            ),
          ),

          // 2. CONTENIDO SCROLLABLE
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // --- LOGO ---
                    Image.asset(
                      "images/logo.png", // Verifica que esta ruta sea correcta
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'MINDPET',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 18,
                        letterSpacing: 1.2
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // --- TÍTULO ---
                    const Text(
                      'Iniciar sesion',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'ComicSans', // O la fuente que tengas en pubspec
                      ),
                    ),
                    const SizedBox(height: 25),

                    // --- TARJETA DE FORMULARIO TRANSPARENTE ---
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        // Usamos blanco con opacidad para que se vea el dibujo atrás
                        color: Colors.white.withOpacity(0.65), 
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.05),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Correo', 
                            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(hint: 'ejemplo@correo.com'),
                          
                          const SizedBox(height: 20),
                          
                          const Text(
                            'Contraseña', 
                            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(isPassword: true, hint: '••••••••'),
                          
                          const SizedBox(height: 30),
                          
                          // BOTÓN DE ACCESO
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                // Lógica de autenticación aquí
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E2E2E), // Gris oscuro casi negro
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'Iniciar sesion',
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          const Center(
                            child: Text(
                              'Olvidaste la contraseña?',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Espacio final para asegurar que el dibujo sea visible al scrollear
                    const SizedBox(height: 150), 
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget personalizado para los campos de texto
  Widget _buildTextField({bool isPassword = false, String? hint}) {
    return TextField(
      obscureText: isPassword,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}