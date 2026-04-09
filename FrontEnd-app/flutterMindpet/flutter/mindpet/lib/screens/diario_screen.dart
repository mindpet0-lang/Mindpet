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
            MaterialPageRoute(
              builder: (context) => NuevaEntradaScreen(),
            ),
          );

          if (nuevaEntrada != null) {

            // ✅ Guardar en backend
            await diarioService.crearDiario(
              nuevaEntrada["texto"],
              nuevaEntrada["titulo"],
            );

            // ✅ Recargar datos
            await cargarDiarios();
          }

        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: entradas.isEmpty
            ? const Center(child: Text("No hay entradas 😢"))
            : ListView.builder(
                itemCount: entradas.length,
                itemBuilder: (context, index) {

                  final entrada = entradas[index];

                  return TarjetaEmocion(
                    emocion: entrada["emocion"],
                    titulo: entrada["titulo"],
                    texto: entrada["texto"],
                    color: entrada["color"],
                  );
                },
              ),
      ),
    );
  }

  // ✅ CARGAR DATOS DESDE API
  Future<void> cargarDiarios() async {
    try {
      final data = await diarioService.obtenerDiarios();

      print("DATA: $data");

      setState(() {
        entradas = data.map<Map<String, dynamic>>((e) {
          return {
            "emocion": "😊",
            "titulo": e["fecha"],
            "texto": e["contenido"],
            "color": Colors.white
          };
        }).toList();
      });

    } catch (e) {
      print("ERROR CARGANDO: $e");
    }
  }
}