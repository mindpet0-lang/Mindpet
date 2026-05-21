import 'package:flutter/material.dart';
import 'package:mindpet/widgets/bottom_menu.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';
import '../services/api_service.dart';
import 'dart:async';
import '../screens/tienda/tienda_screen.dart'; 

class KitchenScreen extends StatefulWidget {
  final Pet pet;
  final PageController controller;
  final int userId;

  const KitchenScreen({
    super.key,
    required this.pet,
    required this.controller,
    required this.userId,
  });

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  late String imgNutria;
  late String imagenComiendo;
  late String imagenTomando;
  bool comiendo = false;
  bool tomando = false;

  final PageController _pageController = PageController(viewportFraction: 0.35);
  int _currentIndex = 0;

  List<dynamic> inventarioComida = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    imgNutria = widget.pet.imagenActual;
    imagenComiendo = widget.pet.imagenComiendo;
    imagenTomando = widget.pet.imagenTomando;
    _iniciarReloj();
    _cargarInventario();
  }

  void _cargarInventario() async {
    if (!mounted) return;
    setState(() => cargando = true);

    List<dynamic> items = await ApiService.getInventarioComida(widget.userId);

    if (!mounted) return;
    setState(() {
      // Dejamos en el inventario local solo los ítems que tengan stock real > 0
      inventarioComida = List.from(items).where((item) => item['cantidad'] > 0).toList();
      cargando = false;
      _currentIndex = 0;
    });
  }

  // Alerta interactiva que redirige a la tienda pasando el userId
  void _mostrarAlertaTienda() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¡Sin comida!"),
          content: const Text("No tienes alimentos en tu inventario. ¿Quieres ir a la tienda a comprar algo rico?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                // Navegación directa pasando el userId
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TiendaScreen(userId: widget.userId),
                  ),
                ).then((_) {
                  // Al regresar, refresca automáticamente el inventario de la cocina
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

  void _procesarAlimentacion(Map<String, dynamic> item) async {
    if (comiendo || tomando || widget.pet.isSleeping) return;

    if (widget.pet.hambre >= 100) {
      _mensaje("¡Tu nutria está llena!");
      return;
    }

    bool esBebida = item['categoria'] == 'BEBIDA';

    setState(() {
      if (esBebida) {
        tomando = true;
      } else {
        comiendo = true;
      }
    });

    widget.pet.comer();
    widget.pet.notifyListeners();

    bool exito = await ApiService.consumirItem(widget.userId, item['nombre']);

    if (exito) {
      await widget.pet.saveLocal();
      await widget.pet.saveToServer(widget.pet.id);

      if (mounted) {
        setState(() {
          item['cantidad']--;
          // Si el alimento se agotó por completo, lo borramos de la lista de forma reactiva
          if (item['cantidad'] <= 0) {
            inventarioComida.removeAt(_currentIndex);
            if (_currentIndex >= inventarioComida.length && _currentIndex > 0) {
              _currentIndex--;
            }
          }
        });
      }
    } else {
      _mensaje("Hubo un problema al consumir el alimento. ⚠️");
      setState(() {
        comiendo = false;
        tomando = false;
      });
      return;
    }

    // Duración de la animación (2 segundos)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        comiendo = false;
        tomando = false; 
        imgNutria = widget.pet.imagenActual;
      });
    }
  }

  void _mensaje(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
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

  Widget _buildSelector() {
    if (cargando) return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
    
    // Si la lista está vacía, mostramos el botón para saltar a TiendaScreen
    if (inventarioComida.isEmpty) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: _mostrarAlertaTienda,
          icon: const Icon(Icons.shopping_cart),
          label: const Text("Ir a la tienda a comprar comida"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orangeAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildArrow(Icons.arrow_back_ios_new, () {
          if (inventarioComida.length <= 1) return;
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
          );
        }),

        Expanded(
          child: SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _pageController,
              itemCount: inventarioComida.length,
              onPageChanged: (index) {
                if (mounted) setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final item = inventarioComida[index];
                bool esSeleccionado = (_currentIndex == index);

                double escala = esSeleccionado ? 1.1 : 0.8;
                double opacidad = esSeleccionado ? 1.0 : 0.6;

                return GestureDetector(
                  onTap: () {
                    if (esSeleccionado) {
                      _procesarAlimentacion(item);
                    } else {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: opacidad,
                    child: Transform.scale(
                      scale: escala,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item['imagen'],
                            height: 75,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(Icons.restaurant, color: Colors.white60, size: 45),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${item['cantidad']}",
                            style: TextStyle(
                              color: esSeleccionado ? Colors.black : Colors.black38,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        _buildArrow(Icons.arrow_forward_ios, () {
          if (inventarioComida.length <= 1) return;
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
          );
        }),
      ],
    );
  }

  Widget _buildArrow(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white30,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildSleepingPet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.bedtime, color: Colors.white, size: 80),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            "Zzz... Durmiendo",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 1️⃣ FONDO DE LA COCINA
          Image.asset(
            "images/fondo/kitchen.png",
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
  onRegresoTienda: () => _cargarInventario(), // ⚡ Recarga comida al volver
)
          ),

          /// 3️⃣ MASCOTA (NUTRIA CON SUS ESTADOS ANIMADOS)
          Center(
            child: ListenableBuilder(
              listenable: widget.pet,
              builder: (context, child) {
                late double size = 250;

                if (comiendo) {
                  imgNutria = imagenComiendo;
                  size = 300;
                } else if (tomando) {
                  imgNutria = imagenTomando;
                  size = 300;
                } else {
                  imgNutria = widget.pet.imagenActual;
                }

                return widget.pet.isSleeping
                    ? _buildSleepingPet()
                    : Image.asset(
                        imgNutria,
                        width: size,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.pets,
                          size: 100,
                          color: Colors.white54,
                        ),
                      );
              },
            ),
          ),

          /// 4️⃣ SELECTOR DE INVENTARIO DINÁMICO
          Positioned(
            bottom: 130, 
            left: 0, 
            right: 0, 
            child: _buildSelector()
          ),

          /// 5️⃣ MENÚ GLOBAL INFERIOR
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: bottomMenu(widget.controller, 2),
          ),
        ],
      ),
    );
  }
}