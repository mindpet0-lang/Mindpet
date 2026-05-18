import 'package:flutter/material.dart';
import '../../data/items_data.dart';
import '../../models/item.dart';
import '../../services/api_service.dart';
import 'carrito_screen.dart';

class ComidaScreen extends StatefulWidget {
  final int userId;
  const ComidaScreen({super.key, required this.userId});

  @override
  State<ComidaScreen> createState() => _ComidaScreenState();
}

class _ComidaScreenState extends State<ComidaScreen> {
  int monedas = 0;
  List<Item> carrito = [];

  @override
  void initState() {
    super.initState();
    _actualizarMonedas();
  }

  void _actualizarMonedas() async {
    int m = await ApiService.getMonedas(widget.userId);
    setState(() => monedas = m);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 221, 174),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 196, 102),
        title: Text("Comida       💛 $monedas"),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, size: 28),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CarritoScreen(
                        carrito: carrito,
                        categoria: "COMIDA", // <--- Aquí defines que es comida
                        userId: widget.userId,
                      ),
                    ),
                  );
                  if (result == true) {
                    setState(() => carrito.clear());
                    _actualizarMonedas();
                  }
                },
              ),
              if (carrito.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${carrito.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: comidaItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (_, i) {
          final itemData = comidaItems[i];
          final bool estaEnCarrito = carrito.any(
            (e) => e.nombre == itemData.nombre,
          );

          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 80,
                      height: 0,
                      child: Image.asset(itemData.imagen, fit: BoxFit.scaleDown),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    itemData.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("💛 ${itemData.precio}"),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: estaEnCarrito
                            ? const Color.fromARGB(255, 122, 184, 124)
                            : const Color.fromARGB(255, 248, 202, 109),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (!estaEnCarrito) {
                            carrito.add(itemData);
                          }
                        });
                      },
                      child: Text(
                        estaEnCarrito ? "Añadido" : "Añadir",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
