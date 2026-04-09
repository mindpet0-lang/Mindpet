import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindpet/services/chat_service.dart'; 

class ChatScreen extends StatefulWidget {
  final int userId; // Recibe el ID del usuario logueado

  const ChatScreen({super.key, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<Map<String, String>> _mensajes = [];
  bool _estaCargando = false;

  @override
  void initState() {
    super.initState();
    _cargarHistorial(); // Carga mensajes viejos al abrir
  }

  // Carga el historial desde MySQL vía Spring Boot
  Future<void> _cargarHistorial() async {
    try {
      final historial = await _chatService.obtenerHistorial(widget.userId);
      setState(() {
        for (var m in historial) {
          _mensajes.add({
            "texto": m['content'] ?? "", 
            "tipo": m['sender'] == 'USER' ? 'user' : 'ia'
          });
        }
      });
      _scrollToBottom();
    } catch (e) {
      print("Error historial: $e");
    }
  }

  // Envía nuevo mensaje a la IA
  Future<void> _enviarMensajeAlServidor() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      _mensajes.add({"texto": texto, "tipo": "user"});
      _estaCargando = true;
    });
    
    _controller.clear();
    _scrollToBottom();

    try {
      final respuesta = await _chatService.enviarMensaje(texto, widget.userId);

      setState(() {
        _mensajes.add({
          "texto": respuesta['reply'] ?? "Sin respuesta",
          "tipo": "ia"
        });
      });
    } catch (e) {
      _mostrarError("Error de conexión con el servidor");
    } finally {
      setState(() => _estaCargando = false);
      _scrollToBottom();
    }
  }

  void _mostrarError(String mensaje) {
    setState(() => _mensajes.add({"texto": mensaje, "tipo": "ia"}));
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
  return Stack(
    children: [

      // 🔹 Imagen de fondo
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/fondochat2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),

      // 🔹 Tu UI encima
      Scaffold(
        backgroundColor: Colors.transparent, // 👈 CLAVE
        appBar: AppBar(
          title: Text(
            "MindPet ia",
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          backgroundColor: Colors.transparent, // 👈 CLAVE
          elevation: 0, // 👈 QUITA SOMBRA
        ),

        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _mensajes.length,
                itemBuilder: (context, index) {
                  final m = _mensajes[index];
                  final esUser = m["tipo"] == "user";

                  return Align(
                    alignment: esUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: esUser
                            ? const Color.fromARGB(251, 140, 202, 252)
                            : const Color.fromARGB(248, 192, 220, 247),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        m["texto"]!,
                        style: GoogleFonts.roboto(),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_estaCargando) const LinearProgressIndicator(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Escribe aquí...",
                        filled: true,
                        fillColor: Colors.white70, // 👈 para que se vea bien
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onSubmitted: (_) => _enviarMensajeAlServidor(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _estaCargando
                        ? null
                        : _enviarMensajeAlServidor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
  }
}