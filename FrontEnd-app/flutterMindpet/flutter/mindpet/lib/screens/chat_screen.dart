import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindpet/services/chat_service.dart'; 

class ChatScreen extends StatefulWidget {
  final int userId; 

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
  // 🔹 NUEVA VARIABLE: Para saber si es la carga inicial del historial
  bool _cargandoHistorial = true; 

  @override
  void initState() {
    super.initState();
    _cargarHistorial(); 
  }

  Future<void> _cargarHistorial() async {
    try {
      final historial = await _chatService.obtenerHistorial(widget.userId);
      setState(() {
        _mensajes.clear(); 
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
    } finally {
      // 🔹 Terminó de cargar el historial (ya sea con datos o vacío)
      setState(() {
        _cargandoHistorial = false;
      });
    }
  }

  void _mostrarDialogoBorrar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "¿Borrar historial?", 
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)
          ),
          content: Text(
            "Esta acción eliminará todos los mensajes de esta conversación permanentemente y la IA no va a recordar mensajes pasados.",
            style: GoogleFonts.roboto(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text("Cancelar", style: TextStyle(color: Colors.grey[700])),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                _confirmarBorradoChat();     
              },
              child: const Text("Borrar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarBorradoChat() async {
    setState(() => _estaCargando = true);
    
    try {
      final exito = await _chatService.borrarHistorial(widget.userId);
      
      if (exito) {
        setState(() {
          _mensajes.clear();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Historial de chat eliminado correctamente."),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _mostrarErrorNotificacion("No se pudo borrar el historial en el servidor.");
      }
    } catch (e) {
      _mostrarErrorNotificacion("Error de conexión al intentar borrar.");
    } finally {
      setState(() => _estaCargando = false);
    }
  }

  void _mostrarErrorNotificacion(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

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
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fondo/fondochat3.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent, 
          appBar: AppBar(
            title: Text(
              "MindPet ia",
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            backgroundColor: Colors.transparent, 
            elevation: 0, 
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.black87),
                onPressed: _mensajes.isEmpty ? null : _mostrarDialogoBorrar, 
              ),
            ],
          ),

          body: Column(
            children: [
              // 🔹 CONTROL DE FLUJO AQUÍ
              Expanded(
                child: _cargandoHistorial
                    ? const Center(
                        // Muestra un círculo de carga centrado mientras conecta con Spring Boot
                        child: CircularProgressIndicator(),
                      )
                    : _mensajes.isEmpty
                        ? Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8), 
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.chat_bubble_outline, 
                                    size: 40, 
                                    color: Colors.black54
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Chat vacío",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Prueba saludando a tu nutria",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontSize: 14, 
                                      color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
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

              if (_estaCargando && !_cargandoHistorial) const LinearProgressIndicator(),

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
                          fillColor: Colors.white70, 
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