import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/api_service.dart';
import 'comida_screen.dart';
import 'aseo_screen.dart';

class TiendaScreen extends StatefulWidget {
  final int userId; 
  const TiendaScreen({super.key, required this.userId});

  @override
  State<TiendaScreen> createState() => _TiendaScreenState();
}

class _TiendaScreenState extends State<TiendaScreen> {
  int monedas = 0;

  @override
  void initState() {
    super.initState();
    _cargarMonedas();
  }

  void _cargarMonedas() async {
    int m = await ApiService.getMonedas(widget.userId);
    setState(() => monedas = m);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text("Tienda", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    // Indicador de Monedas
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                          const SizedBox(width: 5),
                          Text("$monedas", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Image.asset("images/nutria-acostada.gif", height: 180),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _boton(context, "Comida", Icons.fastfood, ComidaScreen(userId: widget.userId)),
                  _boton(context, "Aseo", Icons.soap, AseoScreen(userId: widget.userId)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _boton(BuildContext context, String texto, IconData icono, Widget screen) {
    return GestureDetector(
      onTap: () async {
        // Al volver de Comida o Aseo, refrescamos monedas
        await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        _cargarMonedas();
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          children: [
            Icon(icono, size: 40, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(texto, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}