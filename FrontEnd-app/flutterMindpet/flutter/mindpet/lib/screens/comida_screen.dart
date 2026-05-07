import 'package:flutter/material.dart';
import '../data/items_data.dart'; // Asegúrate de que aquí los items coincidan con el modelo
import '../models/item.dart';
import '../services/api_service.dart';
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
      appBar: AppBar(
        title: Text("Comida 💛 $monedas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () async {
              final result = await Navigator.push(context, MaterialPageRoute(
                builder: (_) => CarritoScreen(carrito: carrito, categoria: "COMIDA", userId: widget.userId)
              ));
              if (result == true) {
                setState(() => carrito.clear());
                _actualizarMonedas();
              }
            },
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: comidaItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8),
        itemBuilder: (_, i) {
          final itemData = comidaItems[i];
          return Card(
            child: Column(
              children: [
                Image.asset(itemData.imagen, height: 80),
                Text(itemData.nombre),
                Text("💛 ${itemData.precio}"),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Si ya existe en el carrito, no lo duplicamos en la lista, el carro maneja cantidad
                      if (!carrito.any((e) => e.nombre == itemData.nombre)) {
                        carrito.add(Item(
                          nombre: itemData.nombre, 
                          precio: itemData.precio, 
                          imagen: itemData.imagen
                        ));
                      }
                    });
                  }, 
                  child: const Text("Añadir")
                )
              ],
            ),
          );
        },
      ),
    );
  }
}