import 'package:flutter/material.dart';

class NuevaEntradaScreen extends StatefulWidget {
  final Map<String, dynamic>? entrada;
  const NuevaEntradaScreen({super.key, this.entrada});

  @override
  State<NuevaEntradaScreen> createState() => _NuevaEntradaScreenState();
}

class _NuevaEntradaScreenState extends State<NuevaEntradaScreen> {
  String emocion = "Tristeza";
  Color color = Colors.blue;

<<<<<<< Updated upstream
=======
  // Los declaramos pero los inicializaremos en el initState
>>>>>>> Stashed changes
  late TextEditingController titulo;
  late TextEditingController texto;

  final List<Map<String, dynamic>> emociones = [
    {"nombre": "Alegría", "color": Colors.green},
    {"nombre": "Tristeza", "color": Colors.blue},
    {"nombre": "Enojo", "color": Colors.red},
    {"nombre": "Ansiedad", "color": Colors.purple},
    {"nombre": "Miedo", "color": Colors.deepPurple},
    {"nombre": "Estrés", "color": Colors.orange},
    {"nombre": "Calma", "color": Colors.teal},
    {"nombre": "Amor", "color": Colors.pink},
    {"nombre": "Cansancio", "color": Colors.brown},
    {"nombre": "Confusión", "color": Colors.indigo},
    {"nombre": "Motivación", "color": Colors.lightGreen},
    {"nombre": "Soledad", "color": Colors.blueGrey},
  ];

  @override
  void initState() {
    super.initState();
    
<<<<<<< Updated upstream
=======
    // 1. Inicializar controladores con datos existentes si estamos editando
>>>>>>> Stashed changes
    titulo = TextEditingController(
      text: widget.entrada != null ? widget.entrada!["titulo"] : ""
    );
    texto = TextEditingController(
      text: widget.entrada != null ? widget.entrada!["texto"] : ""
    );

<<<<<<< Updated upstream
    if (widget.entrada != null) {
      emocion = widget.entrada!["emocion"];
      final seleccionada = emociones.firstWhere(
        (e) => e["nombre"] == emocion,
        orElse: () => emociones[1],
=======
    // 2. Ajustar la emoción inicial si estamos editando
    if (widget.entrada != null) {
      emocion = widget.entrada!["emocion"];
      // Buscamos el color correspondiente a esa emoción
      final seleccionada = emociones.firstWhere(
        (e) => e["nombre"] == emocion,
        orElse: () => emociones[1], // Tristeza por defecto
>>>>>>> Stashed changes
      );
      color = seleccionada["color"];
    }
  }

  @override
  void dispose() {
<<<<<<< Updated upstream
=======
    // 3. Es importante liberar la memoria de los controladores
>>>>>>> Stashed changes
    titulo.dispose();
    texto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffdbe7ef),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.entrada != null ? "Editar entrada" : "Nueva entrada",
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Estado emocional: "),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: emocion,
                  underline: Container(height: 1, color: Colors.black45),
                  items: emociones.map((e) {
                    return DropdownMenuItem<String>(
                      value: e["nombre"],
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: e["color"],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(e["nombre"]),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final seleccion = emociones.firstWhere(
                      (e) => e["nombre"] == value,
                    );
                    setState(() {
                      emocion = seleccion["nombre"];
                      color = seleccion["color"];
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titulo,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "Título",
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xffa9c7da).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: texto,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Escriba aquí...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.check, color: Colors.white),
                onPressed: () {
<<<<<<< Updated upstream
                  // Validación: comprobamos que no estén vacíos
                  if (titulo.text.trim().isEmpty || texto.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Debes escribir un título y un contenido"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  } else {
                    // Solo si están llenos, cerramos y devolvemos los datos
                    Navigator.pop(context, {
                      "emocion": emocion,
                      "titulo": titulo.text,
                      "texto": texto.text,
                      "color": color,
                    });
                  }
=======
                  // Devolvemos el mapa con los datos actualizados
                  Navigator.pop(context, {
                    "emocion": emocion,
                    "titulo": titulo.text,
                    "texto": texto.text,
                    "color": color,
                  });
>>>>>>> Stashed changes
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}