import 'package:flutter/material.dart';
import 'package:mindpet/widgets/bottom_menu.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';
import '../services/api_service.dart';
import 'dart:async';

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
  String imgNutria = "images/nutria-parada.gif";
  bool comiendo = false;
  
  final PageController _pageController = PageController(viewportFraction: 0.35);
  int _currentIndex = 0;

  List<dynamic> inventarioComida = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _iniciarReloj();
    _cargarInventario();
  }

  void _cargarInventario() async {
    setState(() => cargando = true);
    List<dynamic> items = await ApiService.getInventarioComida(widget.userId);
    setState(() {
      inventarioComida = items;
      cargando = false;
      _currentIndex = 0;
    });
  }

  void _procesarAlimentacion(Map<String, dynamic> item) async {
    if (comiendo || widget.pet.isSleeping) return;

    if (widget.pet.hambre >= 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Tu nutria está llena!")),
      );
      return;
    }

    setState(() {
      comiendo = true;
      imgNutria = "images/nutria-comiendo.gif";
    });

    widget.pet.comer(); 
    
    bool exito = await ApiService.consumirItem(widget.userId, item['nombre']);
    
    if (exito) {
      await widget.pet.saveLocal();
      await widget.pet.saveToServer(widget.pet.id);

      setState(() {
        if (item['cantidad'] > 1) {
          item['cantidad']--;
        } else {
          inventarioComida.removeAt(_currentIndex);
          if (_currentIndex >= inventarioComida.length && _currentIndex > 0) {
            _currentIndex--;
          }
        }
      });
    }

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        comiendo = false;
        imgNutria = "images/nutria-parada.gif";
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

  Widget _buildSelector() {
    if (cargando) return const Center(child: CircularProgressIndicator());
    if (inventarioComida.isEmpty) {
      return const Center(
        child: Text("Sin comida. ¡Ve a la tienda!", 
        style: TextStyle(color: Colors.white, backgroundColor: Colors.black45, fontSize: 16))
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildArrow(Icons.arrow_back_ios_new, () {
          _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutBack);
        }),

        Expanded(
          child: SizedBox(
            height: 150,
            child: // Busca esta parte dentro de tu _buildSelector
PageView.builder(
  controller: _pageController,
  itemCount: inventarioComida.length,
  onPageChanged: (index) => setState(() => _currentIndex = index),
  itemBuilder: (context, index) {
    final item = inventarioComida[index];
    bool esSeleccionado = (_currentIndex == index);
    
    // AJUSTE DE VISIBILIDAD:
    double escala = esSeleccionado ? 1.1 : 0.8; // Laterales un poco más grandes
    double opacidad = esSeleccionado ? 1.0 : 0.6; // Opacidad aumentada para que se vean

    return GestureDetector(
      onTap: () {
        if (esSeleccionado) {
          _procesarAlimentacion(item);
        } else {
          _pageController.animateToPage(index, 
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
              // Icono de toque solo si está seleccionado
              Opacity(
                opacity: esSeleccionado ? 1.0 : 0.0,
              ),
              
              Image.asset(item['imagen'], height: 75, fit: BoxFit.contain),
              
              const SizedBox(height: 5),

              // Cantidad (Solo mostramos el número si es el seleccionado para no saturar)
              // O puedes dejarlo para todos, tú decides:
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
          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOutBack);
        }),
      ],
    );
  }

  Widget _buildArrow(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
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
          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(15)),
          child: const Text("Zzz... Durmiendo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/kitchen.png", 
            width: double.infinity, height: double.infinity, fit: BoxFit.cover,
          ),

          Positioned(
            top: 0, left: 0, right: 0,
            child: TopStatusBar(pet: widget.pet, userId: widget.userId),
          ),

          Center(
            child: widget.pet.isSleeping
                ? _buildSleepingPet()
                : Image.asset(imgNutria, width: 250),
          ),

          Positioned(
            bottom: 130,
            left: 0, right: 0,
            child: _buildSelector(),
          ),  
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: bottomMenu(widget.controller, 2),
          ),
        ],
      ),
    );
  }
}