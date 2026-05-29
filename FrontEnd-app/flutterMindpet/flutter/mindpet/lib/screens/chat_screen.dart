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
        _mensajes.clear(); // Limpia antes de cargar por si acaso
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

  // 🔹 Función para mostrar la alerta de confirmación
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
              onPressed: () => Navigator.of(context).pop(), // Cierra la alerta sin hacer nada
              child: Text("Cancelar", style: TextStyle(color: Colors.grey[700])),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                _confirmarBorradoChat();     // Llama a la función para borrar
              },
              child: const Text("Borrar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // 🔹 Función de borrado 
 Future<void> _confirmarBorradoChat() async {
    setState(() => _estaCargando = true);
    
    try {
      // 1. Llamamos al servicio de Flutter que conecta con Spring Boot
      final exito = await _chatService.borrarHistorial(widget.userId);
      
      if (exito) {
        // 2. Si el backend borró todo en MySQL, limpiamos la lista local de la UI
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
        // Si el backend tiró un error (ej. error 500)
        _mostrarErrorNotificacion("No se pudo borrar el historial en el servidor.");
      }
    } catch (e) {
      _mostrarErrorNotificacion("Error de conexión al intentar borrar.");
    } finally {
      setState(() => _estaCargando = false);
    }
  }

  // Pequeño helper visual para no ensuciar la lista de chat con errores de borrado
  void _mostrarErrorNotificacion(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
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
              image: AssetImage("assets/images/fondo/fondochat2.jpg"),
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
            
            // 🔹 SE AÑADIÓ EL BOTÓN DE BORRAR AQUÍ
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.black87),
                onPressed: _mensajes.isEmpty ? null : _mostrarDialogoBorrar, // Deshabilitado si no hay mensajes
              ),
            ],
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