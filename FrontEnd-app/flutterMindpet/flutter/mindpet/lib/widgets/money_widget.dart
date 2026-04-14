import 'package:flutter/material.dart';
import '../data/items_data.dart';
import '../widgets/item_card.dart';
import '../models/item.dart'; // 👈 FALTABA
import '../services/money_service.dart'; // 👈 FALTABA
import '../screens/carrito_screen.dart'; // 👈 FALTABA

class ComidaScreen extends StatefulWidget {
  const ComidaScreen({super.key});

  @override
  State<ComidaScreen> createState() => _ComidaScreenState();
}

class _ComidaScreenState extends State<ComidaScreen> {
  int monedas = 0;
  List<Item> carrito = []; // 👈 TIPADO CORRECTO

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
          content: Text("${item.nombre} agregado al carrito 🛒"),
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
        backgroundColor: Colors.blue,
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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: comidaItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (_, i) {
            final item = comidaItems[i];
            return ItemCard(item: item, onBuy: () => comprar(item));
          },
        ),
      ),
    );
  }
}
