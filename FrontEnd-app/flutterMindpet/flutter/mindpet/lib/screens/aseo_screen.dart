import 'package:flutter/material.dart';
import '../data/items_data.dart';
import '../models/item.dart';
import '../services/api_service.dart';
import '../widgets/item_card.dart';
import 'carrito_screen.dart';

class AseoScreen extends StatefulWidget {
  final int userId; 
  const AseoScreen({super.key, required this.userId});

  @override
  State<AseoScreen> createState() => _AseoScreenState();
}

class _AseoScreenState extends State<AseoScreen> {
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
        title: Text("Aseo 🧼 💛 $monedas"),
        backgroundColor: const Color(0xFFEAF6FB),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, size: 28),
                onPressed: () async {
                  final compraExitosa = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CarritoScreen(
                        carrito: carrito, 
                        categoria: "ASEO", 
                        userId: widget.userId
                      ),
                    ),
                  );

                  if (compraExitosa == true) {
                    setState(() => carrito.clear());
                    _actualizarMonedas();
                  }
                },
              ),
              if (carrito.isNotEmpty)
                Positioned( // 👈 CORREGIDO: Antes decía 'Position Newed'
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red, 
                      borderRadius: BorderRadius.circular(10)
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${carrito.length}', 
                      style: const TextStyle(color: Colors.white, fontSize: 10), 
                      textAlign: TextAlign.center
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: aseoItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, i) {
          final itemData = aseoItems[i];
          
          return ItemCard(
            item: itemData,
            onBuy: () {
              setState(() {
                // Si el item no está, lo agregamos
                if (!carrito.any((e) => e.nombre == itemData.nombre)) {
                  carrito.add(Item(
                    nombre: itemData.nombre,
                    precio: itemData.precio,
                    imagen: itemData.imagen,
                    cantidad: 1,
                  ));
                } else {
                  // Si ya está, sumamos a la cantidad
                  carrito.firstWhere((e) => e.nombre == itemData.nombre).cantidad++;
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${itemData.nombre} añadido"),
                  duration: const Duration(milliseconds: 600),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        },
      ),
    );
  }
}