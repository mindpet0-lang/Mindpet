import 'package:flutter/material.dart';

class DetalleDiarioScreen extends StatelessWidget {
  final Map<String, dynamic> entrada;
  final int userId;
  final Function onDelete;
  final Function onEdit;

  const DetalleDiarioScreen({
    super.key,
    required this.entrada,
    required this.userId,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo azul grisáceo claro acorde a la interfaz de Nueva Entrada
      backgroundColor: const Color(0xFFE5EBF0), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detalle de nota",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black54, size: 20),
            onPressed: () => onEdit(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: () => _confirmarBorrado(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // Azul de las tarjetas del diario
            color: const Color(0xFFA9C6D9).withOpacity(0.6), 
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estado emocional estilo selector
              Row(
                children: [
<<<<<<< Updated upstream
                  const Text("Estado emocional: ", style: TextStyle(fontSize: 14, color: Colors.black87)),
                  const SizedBox(width: 8),
=======
                  const SizedBox(width: 8),
                  Icon(Icons.circle, color: entrada['color'] ?? Colors.blue, size: 10),
                  const SizedBox(width: 5),
>>>>>>> Stashed changes
                  Text(
                    entrada['emocion'],
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Título con fuente más pequeña y elegante
              const SizedBox(height: 5),
              Text(
                entrada['titulo'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Divider(color: Colors.black26, thickness: 0.8),
              const SizedBox(height: 20),

              // Contenido en caja de texto suave
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    entrada['texto'],
                    style: const TextStyle(
                      fontSize: 14, // Fuente más pequeña solicitada
                      color: Colors.black,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmarBorrado(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("¿Borrar nota?", style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("No")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            }, 
            child: const Text("Sí, borrar", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}