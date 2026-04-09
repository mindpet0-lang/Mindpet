import 'package:flutter/material.dart';
import '../models/item.dart';

class CarritoScreen extends StatelessWidget {
  final List<Item> carrito;

  const CarritoScreen({super.key, required this.carrito});

  @override
  Widget build(BuildContext context) {
    int total = carrito.fold(0, (sum, item) => sum + item.precio);

    return Scaffold(
      appBar: AppBar(title: const Text("Carrito 🛒")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: carrito.length,
              itemBuilder: (_, i) {
                final item = carrito[i];
                return ListTile(
                  leading: Image.asset(item.imagen),
                  title: Text(item.nombre),
                  trailing: Text("💛 ${item.precio}"),
                );
              },
            ),
          ),
          Text("Total: 💛 $total",
              style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}