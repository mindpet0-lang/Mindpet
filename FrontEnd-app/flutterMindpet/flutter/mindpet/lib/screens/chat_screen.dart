import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> mensajes = []; // { "texto": "...", "tipo": "user/ia" }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // DISEÑO DEL APPBAR
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.teal[600],
        title: const Column(
          children: [
            Text("Apoyo Emocional", style: TextStyle(fontSize: 18, color: Colors.white)),
            Text("MindPet AI", style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[100], // Fondo suave para no cansar la vista
        child: Column(
          children: [
            // LISTA DE MENSAJES
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: mensajes.length,
                itemBuilder: (context, index) {
                  bool esUsuario = mensajes[index]["tipo"] == "user";
                  return Align(
                    alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: esUsuario ? Colors.teal[100] : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 2)],
                      ),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      child: Text(mensajes[index]["texto"]!),
                    ),
                  );
                },
              ),
            ),
            // INPUT DE TEXTO
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "¿Cómo te sientes hoy?",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.teal),
                    onPressed: () {
                      // Aquí llamarías a tu servicio de Spring Boot
                      _enviarMensaje(_controller.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enviarMensaje(String texto) {
    if (texto.isEmpty) return;
    setState(() {
      mensajes.add({"texto": texto, "tipo": "user"});
      _controller.clear();
    });
    // Aquí implementas la llamada HTTP a tu backend...
  }
}