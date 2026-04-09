import 'package:flutter/material.dart';
import '../data/items_data.dart';
import '../widgets/item_card.dart';
import '../models/item.dart';
import '../services/money_service.dart';
import 'carrito_screen.dart';

class ComidaScreen extends StatefulWidget {
  const ComidaScreen({super.key});

  @override
  State<ComidaScreen> createState() => _ComidaScreenState();
}

class _ComidaScreenState extends State<ComidaScreen> {
  int monedas = 0;
  List<Item> carrito = [];

  @override
  void initState() {
    super.initState();
    cargarMonedas();
  }

  void cargarMonedas() async {
    monedas = await MoneyService.getMoney();
    setState(() {});
  }

  void comprar(Item item) async {
    if (monedas >= item.precio) {
      monedas -= item.precio;
      carrito.add(item);

      await MoneyService.saveMoney(monedas);

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("${item.nombre} agregado 🛒"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("No tienes monedas 😢"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comida 💛 $monedas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CarritoScreen(carrito: carrito),
                ),
              );
            },
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🍔 COMIDA
              const Center(
                child: Text(
                  "🍔 Comida",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comidaItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (_, i) {
                  final item = comidaItems[i];
                  return ItemCard(
                    item: item,
                    onBuy: () => comprar(item),
                  );
                },
              ),

              const SizedBox(height: 20),

              // 🥤 BEBIDAS
              const Center(
                child: Text(
                  "🥤 Bebidas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bebidaItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (_, i) {
                  final item = bebidaItems[i];
                  return ItemCard(
                    item: item,
                    onBuy: () => comprar(item),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}