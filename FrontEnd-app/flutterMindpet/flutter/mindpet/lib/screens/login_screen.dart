import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'pet_loader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError("Por favor, llena todos los campos");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/usuarios/login'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': _emailController.text.trim().toLowerCase(),
          'contrasena': _passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        final String token = userData['token'];
        
        // 1. Extraemos el ID del JSON que responde Spring Boot
        final int idRecuperado = userData['id']; 

        // GUARDAR SESIÓN LOCALMENTE
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', idRecuperado);
        await prefs.setString('token', token);
        
        if (mounted) {
          // 2. PASAMOS EL ID AL PET LOADER (Aquí se quita la línea roja)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PetLoader(userId: idRecuperado),
            ),
          );
        }
      } else {
        _showError("Correo o contraseña incorrectos");
      }
    } catch (e) {
      print("Error de conexión: $e");
      _showError("No se pudo conectar con el servidor");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'images/imagen-terapia.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
              filterQuality: FilterQuality.high,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Image.asset("images/logo.png", height: 150),
                    const SizedBox(height: 40),
                    const Text(
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Correo', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _emailController, 
                            hint: 'test@correo.com'
                          ),
                          const SizedBox(height: 20),
                          const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _passwordController, 
                            isPassword: true, 
                            hint: '••••••••'
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E2E2E),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: _isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildTextField({required TextEditingController controller, bool isPassword = false, String? hint}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }
}