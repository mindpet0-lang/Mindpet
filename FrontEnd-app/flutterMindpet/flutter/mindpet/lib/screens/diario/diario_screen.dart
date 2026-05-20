import 'package:flutter/material.dart';
import 'package:mindpet/screens/diario/nueva_entrada_screen.dart';
import 'package:mindpet/screens/diario/detalle_diario_screen.dart'; // Asegúrate de crear este archivo
import '../../widgets/tarjeta_emocion.dart';
import '../../services/diario_service.dart';

class DiarioScreen extends StatefulWidget {
  final int userId; // Recibimos el ID del usuario logueado

  const DiarioScreen({super.key, required this.userId});

  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  final DiarioService diarioService = DiarioService();
  List<Map<String, dynamic>> entradas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDiarios();
  }

  // 🔄 CARGAR DATOS FILTRADOS POR USUARIO
  Future<void> cargarDiarios() async {
    try {
      setState(() => cargando = true);
      // Usamos el userId del widget para la petición
      final data = await diarioService.obtenerDiarios(widget.userId);

      setState(() {
        entradas = data.map<Map<String, dynamic>>((e) {
          String emocion = normalizarEmocion(e["emocion"]);
          return {
            "id": e["id"] ?? 0,
            "emocion": emocion,
            "titulo": e["titulo"]?.toString() ?? "",
            "texto": e["contenido"]?.toString() ?? "",
            "color": obtenerColorPorEmocion(emocion),
          };
        }).toList();
        cargando = false;
      });
    } catch (e) {
      print("ERROR CARGANDO: $e");
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // FONDO PERSONALIZADO
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/fondo/fondodiario.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
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
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final nuevaEntrada = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NuevaEntradaScreen(),
                ),
              );

              if (nuevaEntrada != null) {
                // Pasamos el userId al crear
                await diarioService.crearDiario(
                  widget.userId,
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
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : entradas.isEmpty
                ? const Center(
                    child: Text(
                      "No hay nada aún. ¡Agrega tu primera nota!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          await diarioService.eliminarDiario(
                            entrada["id"],
                            widget.userId,
                          );
                          // No es necesario cargarDiarios() aquí si lo borras del local,
                          // pero es más seguro para sincronizar con Spring Boot.
                          cargarDiarios();
                        },
                        child: GestureDetector(
                          // AL DAR CLICK: Ver detalle, editar o borrar
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalleDiarioScreen(
                                  entrada: entrada,
                                  userId: widget.userId,
                                  onDelete: () async {
                                    await diarioService.eliminarDiario(
                                      entrada["id"],
                                      widget.userId,
                                    );
                                    if (mounted) {
                                      Navigator.pop(context); // Cierra detalle
                                      cargarDiarios();
                                    }
                                  },
                                  onEdit: () async {
                                    final editado = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NuevaEntradaScreen(
                                              entrada: entrada,
                                            ),
                                      ),
                                    );

                                    if (editado != null) {
                                      await diarioService.actualizarDiario(
                                        entrada["id"],
                                        widget.userId,
                                        editado["texto"],
                                        editado["titulo"],
                                        editado["emocion"],
                                      );
                                      if (mounted) {
                                        Navigator.pop(
                                          context,
                                        ); // Cierra detalle
                                        cargarDiarios();
                                      }
                                    }
                                  },
                                ),
                              ),
                            );
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
        ),
      ],
    );
  }

  // 🎨 LÓGICA DE COLORES POR EMOCIÓN
  Color obtenerColorPorEmocion(String emocion) {
    emocion = emocion.toLowerCase();

    if (emocion.contains("alegría")) return Colors.yellow.withOpacity(0.7);
    if (emocion.contains("tristeza")) return Colors.blue.withOpacity(0.7);
    if (emocion.contains("enojo")) return Colors.red.withOpacity(0.7);
    if (emocion.contains("ansiedad")) return Colors.purple.withOpacity(0.7);
    if (emocion.contains("miedo")) return Colors.deepPurple.withOpacity(0.7);
    if (emocion.contains("estres")) return Colors.orange.withOpacity(0.7);
    if (emocion.contains("calma")) return Colors.teal.withOpacity(0.7);
    if (emocion.contains("amor")) return Colors.pink.withOpacity(0.7);
    if (emocion.contains("cansancio")) return Colors.brown.withOpacity(0.7);
    if (emocion.contains("confusión")) return Colors.indigo.withOpacity(0.7);
    if (emocion.contains("motivación"))
      return Colors.lightGreen.withOpacity(0.7);
    if (emocion.contains("soledad")) return Colors.blueGrey.withOpacity(0.7);

    return Colors.grey.withOpacity(0.7); // Color por defecto
  }

  // 😊 NORMALIZACIÓN DE TEXTO
  String normalizarEmocion(String? emocion) {
    emocion = (emocion ?? "").toLowerCase();

    if (emocion.contains("alegr") || emocion.contains("feliz"))
      return "Alegría";
    if (emocion.contains("triste")) return "Tristeza";
    if (emocion.contains("enojo")) return "Enojo";
    if (emocion.contains("ansie")) return "Ansiedad";
    if (emocion.contains("miedo")) return "Miedo";
    if (emocion.contains("estr")) return "Estrés";
    if (emocion.contains("calma")) return "Calma";
    if (emocion.contains("amor")) return "Amor";
    if (emocion.contains("cans")) return "Cansancio";
    if (emocion.contains("confu")) return "Confusión";
    if (emocion.contains("motiv")) return "Motivación";
    if (emocion.contains("sol")) return "Soledad";

    return "Otros";
  }
}
