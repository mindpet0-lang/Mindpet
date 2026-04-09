import 'package:flutter/material.dart';
import 'package:mindpet/screens/nueva_entrada_screen.dart';
import '../widgets/tarjeta_emocion.dart';
import '../services/diario_service.dart';

class DiarioScreen extends StatefulWidget {
  const DiarioScreen({super.key});

  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {

  final DiarioService diarioService = DiarioService();

  List<Map<String, dynamic>> entradas = [];

  @override
  void initState() {
    super.initState();
    cargarDiarios();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffdbe7ef),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Diario",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),

        onPressed: () async {

          final nuevaEntrada = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevaEntradaScreen()),
          );

          if (nuevaEntrada != null) {

            await diarioService.crearDiario(
              nuevaEntrada["texto"],
              nuevaEntrada["titulo"],
              nuevaEntrada["emocion"],
            );


            await cargarDiarios();
          }

        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: entradas.isEmpty
            ? const Center(
                child: Text("No hay diarios aún. ¡Agrega tu primer diario!"),
              )
            : ListView.builder(
                itemCount: entradas.length,
                itemBuilder: (context, index) {

                  final entrada = entradas[index];

                  return Dismissible(
                    key: Key(entrada["id"].toString()),
                    direction: DismissDirection.endToStart,

                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),

                    onDismissed: (direction) async {
                      await diarioService.eliminarDiario(entrada["id"]);
                      cargarDiarios();
                    },

                    child: GestureDetector(
                      onLongPress: () async {
                        final editado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NuevaEntradaScreen(entrada: entrada),
                          ),
                        );

                        if (editado != null) {
                          await diarioService.actualizarDiario(
                            entrada["id"],
                            editado["texto"],
                            editado["titulo"],
                            editado["emocion"],
                          );

                          cargarDiarios();
                        }
                      },

                      child: TarjetaEmocion(
                        emocion: entrada["emocion"],
                        titulo: entrada["titulo"],
                        texto: entrada["texto"],
                        color: entrada["color"],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  // 🎨 COLOR DINÁMICO
  Color obtenerColorPorEmocion(String emocion) {
  emocion = emocion.toLowerCase();

  if (emocion.contains("alegria")) return Colors.green;
  if (emocion.contains("tristeza")) return Colors.blue;
  if (emocion.contains("enojo")) return Colors.red;
  if (emocion.contains("ansiedad")) return Colors.purple;
  if (emocion.contains("miedo")) return Colors.deepPurple;
  if (emocion.contains("estrés")) return Colors.orange;
  if (emocion.contains("calma")) return Colors.teal;
  if (emocion.contains("amor")) return Colors.pink;
  if (emocion.contains("cansancio")) return Colors.brown;
  if (emocion.contains("confusion")) return Colors.indigo;
  if (emocion.contains("motivacion")) return Colors.lightGreen;
  if (emocion.contains("soledad")) return Colors.blueGrey;

  return Colors.grey;
}

  // 😊 NORMALIZAR EMOCIÓN
  String normalizarEmocion(String? emocion) {
  emocion = (emocion ?? "").toLowerCase();

  if (emocion.contains("alegr") || emocion.contains("feliz") || emocion.contains("😊")) return "Alegría";
  if (emocion.contains("triste") || emocion.contains("😢")) return "Tristeza";
  if (emocion.contains("enojo") || emocion.contains("😡")) return "Enojo";
  if (emocion.contains("ansiedad")) return "Ansiedad";
  if (emocion.contains("miedo")) return "Miedo";
  if (emocion.contains("estr")) return "Estrés";
  if (emocion.contains("calma")) return "Calma";
  if (emocion.contains("amor")) return "Amor";
  if (emocion.contains("cansancio") || emocion.contains("😴")) return "Cansancio";
  if (emocion.contains("confusi")) return "Confusión";
  if (emocion.contains("motiv")) return "Motivación";
  if (emocion.contains("soledad")) return "Soledad";

  return "Alegría";
}

  // 🔄 CARGAR DATOS
  Future<void> cargarDiarios() async {
    try {
      final data = await diarioService.obtenerDiarios();



      setState(() {
        entradas = data.map<Map<String, dynamic>>((e) {

          String emocion = normalizarEmocion(e["emocion"]);

          return {
            "id": e["id"], // 🔥 CLAVE
            "emocion": emocion,
            "titulo": e["fecha"],
            "texto": e["contenido"],
            "color": obtenerColorPorEmocion(emocion),
          };

        }).toList();
      });

    } catch (e) {
      print("ERROR CARGANDO: $e");
    }
  }
}