import 'package:flutter/material.dart';
import '../data/items_data.dart';
import '../widgets/item_card.dart';

class AseoScreen extends StatefulWidget {
  const AseoScreen({super.key});

  @override
  State<AseoScreen> createState() => _AseoScreenState();
}

class _AseoScreenState extends State<AseoScreen> {
  int monedas = 100;

  void comprar(int precio, String nombre) {
    if (monedas >= precio) {
      setState(() {
        monedas -= precio;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Compraste $nombre 🧼. Compra exitosa 🎉"), backgroundColor: const Color.fromARGB(255, 71, 92, 163), ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No tienes monedas 😢")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aseo 🧼 $monedas"), backgroundColor: Color(0xFFEAF6FB),),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: aseoItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (_, i) => ItemCard(
          item: aseoItems[i],
          onBuy: () => comprar(
            aseoItems[i].precio,
            aseoItems[i].nombre,
          ),
        ),
      ),
    );
  }
}