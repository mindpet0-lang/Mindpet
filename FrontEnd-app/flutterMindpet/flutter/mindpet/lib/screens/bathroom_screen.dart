import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindpet/widgets/bottom_menu.dart';
import '../services/api_service.dart'; 
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';
import '../screens/tienda/tienda_screen.dart'; 

class BathroomScreen extends StatefulWidget {
  final Pet pet;
  final PageController controller;
  final int userId;

  const BathroomScreen({
    super.key,
    required this.controller,
    required this.userId,
    required this.pet,
  });

  @override
  State<BathroomScreen> createState() => _BathroomScreenState();
}

class _BathroomScreenState extends State<BathroomScreen> {
  bool animandoAccion = false;
  bool jabonUsado = false;
  late String imgNutria;

  // Lista del inventario (únicamente jabones)
  List<dynamic> inventarioAseo = [];
  int objetoActual = 0;
  bool cargandoInventario = true;

  // Guarda la carpeta del último jabón usado
  String carpetaJabonActual = "jabon"; 

  @override
  void initState() {
    super.initState();
    imgNutria = widget.pet.imagenActual;
    _iniciarReloj();
    _cargarInventario();
  }

  // Carga el inventario inicial desde la base de datos
Future<void> _cargarInventario() async {
    try {
      final itemsApi = await ApiService.getInventarioAseo(widget.userId);
      

      setState(() {
        // Filtramos para dejar solo los jabones que tengan stock > 0
        inventarioAseo = List.from(itemsApi).where((item) => item["cantidad"] > 0).toList();
        objetoActual = 0;
        cargandoInventario = false;
      });
    } catch (e) {
    
      if (!mounted) return;

      setState(() {
        inventarioAseo = [];
        cargandoInventario = false;
      });
    }
  }

  void _iniciarReloj() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        widget.pet.updateWithTime();
      });
      return true;
    });
  }

  void siguiente() {
    if (inventarioAseo.length <= 1) return;
    setState(() => objetoActual = (objetoActual + 1) % inventarioAseo.length);
  }

  void anterior() {
    if (inventarioAseo.length <= 1) return;
    setState(() => objetoActual = (objetoActual - 1 + inventarioAseo.length) % inventarioAseo.length);
  }

  // Alerta interactiva que redirige a TiendaScreen pasando el userId
  void _mostrarAlertaTienda() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¡Sin existencias!"),
          content: const Text("No tienes jabones disponibles. ¿Quieres ir a la tienda a comprar más?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                
                // Navegación directa pasando el userId de este widget
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TiendaScreen(userId: widget.userId),
                  ),
                ).then((_) {
                  // Al regresar de la tienda, recargamos el inventario por si compró algo
                  setState(() => cargandoInventario = true);
                  _cargarInventario();
                });
              },
              child: const Text("Ir a la Tienda", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Aplica el jabón actual y lo consume tanto en backend como en frontend
  void usarJabon() async {
   if (widget.pet.isSleeping || animandoAccion || inventarioAseo.isEmpty) return;

    // 🛑 EL CANDADO: Si ya está limpia, frenamos todo antes de consumir el jabón
    if (widget.pet.higiene > 35) {
      _mensaje("¡Tu mascota ya está limpia! No desperdicies jabón. 🧼");
      return; // 🔥 Evita que se ejecute el código de abajo
    }

    final item = inventarioAseo[objetoActual];
    String nombreOriginal = item["nombre"].toString();
    String nombreObjeto = nombreOriginal.toLowerCase().trim();

    // 1. Llamar a la API para consumir el ítem en la base de datos
    setState(() => animandoAccion = true);
    bool consumidoOk = await ApiService.consumirItem(widget.userId, nombreOriginal);

    if (!consumidoOk) {
      setState(() => animandoAccion = false);
      _mensaje("Hubo un problema al usar el jabón. Inténtalo de nuevo. ⚠️");
      return;
    }

    // 2. Si la API responde OK, procesamos la animación correspondientemente
    if (nombreObjeto == "flores") {
      carpetaJabonActual = "jabonflores";
    } else if (nombreObjeto == "coco") {
      carpetaJabonActual = "jaboncoco";
    } else {
      carpetaJabonActual = "jabon"; 
    }

    setState(() {
      jabonUsado = true;
      imgNutria = "images/nutria/banio/$carpetaJabonActual/jabon.gif";
      
      // Restamos la cantidad localmente
      item["cantidad"]--;
    });

    widget.pet.higiene = (widget.pet.higiene + 30).clamp(0, 100);
    widget.pet.notifyListeners();
    await widget.pet.saveLocal();

    // Esperamos los 3 segundos que dura la animación enjabonando
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        animandoAccion = false;
        imgNutria = "images/nutria/banio/$carpetaJabonActual/enjabonada.gif";

        // 3. Si se agotó el jabón por completo, se borra de la lista inmediatamente
        if (item["cantidad"] <= 0) {
          inventarioAseo.removeAt(objetoActual);
          // Reajustamos el índice para evitar desbordamiento de rango
          if (objetoActual >= inventarioAseo.length && inventarioAseo.isNotEmpty) {
            objetoActual = 0;
          }
        }
      });
    }
  }

  void usarDucha() async {
    if (animandoAccion || !jabonUsado) return;

    setState(() {
      animandoAccion = true;
      imgNutria = "images/nutria/banio/$carpetaJabonActual/ducha.gif";
    });

    widget.pet.higiene = 100;
    widget.pet.notifyListeners();
    await widget.pet.saveLocal();

    // Esperamos los 8 segundos que dura la ducha
    await Future.delayed(const Duration(seconds: 8));

    if (mounted) {
      setState(() {
        animandoAccion = false;
        jabonUsado = false; 
        imgNutria = widget.pet.imagenActual; 
      });
    }
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Pet>(
      builder: (context, pet, child) {
        return Scaffold(
          body: Stack(
            children: [
              /// 1️⃣ FONDO
              Image.asset(
                "images/fondo/bano.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              /// 2️⃣ BARRA SUPERIOR
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: TopStatusBar(
  pet: widget.pet, 
  userId: widget.userId,
  onRegresoTienda: () {
    setState(() => cargandoInventario = true);
    _cargarInventario(); // ⚡ Recarga jabones al volver
  },
)
              ),

              /// 3️⃣ MASCOTA (NUTRIA)
              Center(
                child: ListenableBuilder(
                  listenable: widget.pet,
                  builder: (context, child) {
                    if (!animandoAccion) {
                      if (jabonUsado) {
                        imgNutria = "images/nutria/banio/$carpetaJabonActual/enjabonada.gif";
                      } else {
                        imgNutria = widget.pet.imagenActual;
                      }
                    }

                    return widget.pet.isSleeping
                        ? _buildSleepingPlaceholder()
                        : Image.asset(
                            imgNutria,
                            key: ValueKey(imgNutria + animandoAccion.toString()),
                            width: 250,
                            gaplessPlayback: false,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.pets,
                              size: 100,
                              color: Colors.white54,
                            ),
                          );
                  },
                ),
              ),

              /// 4️⃣ PANEL DE CONTROL DINÁMICO
              if (!widget.pet.isSleeping)
                Positioned(
                  bottom: 130,
                  left: 0,
                  right: 0,
                  child: cargandoInventario
                      ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
                      : _buildControlPanel(),
                ),

              /// 5️⃣ MENÚ INFERIOR
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: bottomMenu(widget.controller, 1),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlPanel() {
    // FASE DE ENJUAGAR: Muestra únicamente el botón de la ducha independiente
    if (jabonUsado && !animandoAccion) {
      return Center(
        child: GestureDetector(
          onTap: usarDucha,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "images/ducha.png", 
                width: 75,
                height: 75,
              ),
              const SizedBox(height: 6),
              const Text(
                "¡Enjuagar!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // SI NO HAY JABONES: Botón directo que redirige a la Tienda Screen pasando el userId
    if (inventarioAseo.isEmpty) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: _mostrarAlertaTienda,
          icon: const Icon(Icons.shopping_cart),
          label: const Text("Ir a la tienda a comprar jabón"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      );
    }

    // FASE DE ENJABONAR: Selector de Jabones limpio sin repetirse
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: (animandoAccion || inventarioAseo.length <= 1) ? null : anterior,
          icon: Icon(
            Icons.chevron_left, 
            size: 45, 
            color: inventarioAseo.length <= 1 ? Colors.white24 : Colors.white
          ),
        ),
        SizedBox(
          width: 240,
          height: 115,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (inventarioAseo.length > 2)
                Positioned(
                  left: 5,
                  child: Opacity(
                    opacity: 0.4,
                    child: _buildItemPreview(
                      (objetoActual - 1 + inventarioAseo.length) % inventarioAseo.length,
                    ),
                  ),
                ),

              if (inventarioAseo.length > 1)
                Positioned(
                  right: 5,
                  child: Opacity(
                    opacity: 0.4,
                    child: _buildItemPreview(
                      (objetoActual + 1) % inventarioAseo.length,
                    ),
                  ),
                ),

              Positioned(
                child: AnimatedScale(
                  scale: animandoAccion ? 0.9 : 1.1,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: animandoAccion ? null : usarJabon,
                    child: _buildItemCentral(objetoActual),
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: (animandoAccion || inventarioAseo.length <= 1) ? null : siguiente,
          icon: Icon(
            Icons.chevron_right, 
            size: 45, 
            color: inventarioAseo.length <= 1 ? Colors.white24 : Colors.white
          ),
        ),
      ],
    );
  }

  Widget _buildItemPreview(int index) {
    if (inventarioAseo.isEmpty) return const SizedBox();
    final item = inventarioAseo[index];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          item["imagen"], 
          width: 45, 
          height: 45,
          errorBuilder: (_, __, ___) => const Icon(Icons.soap, color: Colors.white60, size: 35),
        ),
        const SizedBox(height: 6),
        Text(
          "${item["cantidad"]}",
          style: const TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildItemCentral(int index) {
    if (inventarioAseo.isEmpty) return const SizedBox();
    final item = inventarioAseo[index];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          item["imagen"], 
          width: 70, 
          height: 70,
          errorBuilder: (_, __, ___) => const Icon(Icons.soap, color: Colors.white, size: 55),
        ),
        const SizedBox(height: 4),
        Text(
          "${item["cantidad"]}",
          style: const TextStyle(
            color: Colors.black, 
            fontSize: 22, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSleepingPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bedtime, color: Colors.white, size: 50),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.black54,
            child: const Text(
              "Tu mascota está durmiendo...",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}