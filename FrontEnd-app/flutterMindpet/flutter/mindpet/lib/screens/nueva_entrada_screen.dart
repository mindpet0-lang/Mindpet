import 'package:flutter/material.dart';

class NuevaEntradaScreen extends StatefulWidget {
  final Map<String, dynamic>? entrada;
  const NuevaEntradaScreen({super.key , this.entrada});

  @override
  State<NuevaEntradaScreen> createState() => _NuevaEntradaScreenState();
}

class _NuevaEntradaScreenState extends State<NuevaEntradaScreen> {
  String emocion = "Tristeza";
  Color color = Colors.blue;

  TextEditingController titulo = TextEditingController();
  TextEditingController texto = TextEditingController();

  List<Map<String, dynamic>> emociones = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdbe7ef),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Nueva entrada"),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [
            Row(
              children: [
                Text("Estado emocional: "),
                SizedBox(width: 10),

                DropdownButton(
                  value: emocion,

                  items: emociones.map((e) {
                    return DropdownMenuItem(
                      value: e["nombre"],

                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: e["color"],
                              shape: BoxShape.circle,
                            ),
                          ),

                          SizedBox(width: 8),

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

            SizedBox(height: 20),

            TextField(
              controller: titulo,
              decoration: InputDecoration(
                hintText: "Título",
                border: UnderlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Color(0xffa9c7da),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: TextField(
                  controller: texto,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Escriba aquí...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: 15),

            Align(
              alignment: Alignment.bottomRight,

              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.blue,
                child: Icon(Icons.check),

                onPressed: () {
                  Navigator.pop(context, {
                    "emocion": emocion,
                    "titulo": titulo.text,
                    "texto": texto.text,
                    "color": color,
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
