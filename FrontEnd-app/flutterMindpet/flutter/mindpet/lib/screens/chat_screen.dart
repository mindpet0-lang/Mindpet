import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Lista para almacenar el historial de mensajes localmente
  final List<Map<String, String>> _mensajes = [];
  bool _estaCargando = false;

  // Función para enviar el mensaje al Backend de Spring Boot
  Future<void> _enviarMensaje() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    // 1. Mostrar el mensaje del usuario de inmediato
    setState(() {
      _mensajes.add({"texto": texto, "tipo": "user"});
      _estaCargando = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      // 2. Petición HTTP al backend (Asegúrate de que el puerto sea 8080)
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/chat/send'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"text": texto}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // 'reply' es la llave que configuramos en el Map de Java
          _mensajes.add({
            "texto": data['reply'] ?? "No recibí respuesta.",
            "tipo": "ia"
          });
        });
      } else {
        _mostrarError("Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      _mostrarError("Error de conexión. ¿Spring Boot está encendido?");
      print("Detalle del error: $e");
    } finally {
      setState(() => _estaCargando = false);
      _scrollToBottom();
    }
  }

  void _mostrarError(String mensaje) {
    setState(() {
      _mensajes.add({"texto": mensaje, "tipo": "ia"});
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MindPet - Apoyo Emocional", 
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Área de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: _mensajes.length,
              itemBuilder: (context, index) {
                final m = _mensajes[index];
                final esUsuario = m["tipo"] == "user";
                return Align(
                  alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: esUsuario ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(15).copyWith(
                        bottomRight: esUsuario ? const Radius.circular(0) : const Radius.circular(15),
                        bottomLeft: esUsuario ? const Radius.circular(15) : const Radius.circular(0),
                      ),
                    ),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    child: Text(
                      m["texto"]!,
                      style: GoogleFonts.roboto(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),

          // Indicador de carga
          if (_estaCargando)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(minHeight: 2),
            ),

          // Campo de texto y botón enviar
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Cuéntame cómo te sientes...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onSubmitted: (_) => _enviarMensaje(),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _estaCargando ? null : _enviarMensaje,
                  backgroundColor: _estaCargando ? Colors.grey : Colors.blueAccent,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}