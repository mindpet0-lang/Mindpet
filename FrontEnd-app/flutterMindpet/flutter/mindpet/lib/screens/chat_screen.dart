import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _mensajes = [];
  bool _cargando = false;

  void _enviar() async {
    if (_controller.text.isEmpty) return;
    
    String p = _controller.text;
    setState(() {
      _mensajes.add({"content": p, "sender": "USER"});
      _cargando = true;
    });
    _controller.clear();

    try {
      final respuesta = await _chatService.enviarMensaje(p);
      setState(() {
        _mensajes.add(respuesta);
        _cargando = false;
      });
    } catch (e) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gemini Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _mensajes.length,
              itemBuilder: (context, i) {
                final m = _mensajes[i];
                return ListTile(
                  title: Align(
                    alignment: m['sender'] == "USER" ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: m['sender'] == "USER" ? Colors.blue[100] : Colors.grey[300],
                      child: Text(m['content']),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_cargando) LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(icon: Icon(Icons.send), onPressed: _enviar),
              ],
            ),
          )
        ],
      ),
    );
  }
}