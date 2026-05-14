import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/api_service.dart';

class CarritoScreen extends StatefulWidget {
  final List<Item> carrito;
  final String categoria;
  final int userId;

  const CarritoScreen({super.key, required this.carrito, required this.categoria, required this.userId});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  int monedasServidor = 0;

  @override
  void initState() {
    super.initState();
    _obtenerSaldoReal();
  }

  void _obtenerSaldoReal() async {
    int saldo = await ApiService.getMonedas(widget.userId);
    setState(() => monedasServidor = saldo);
  }

  int _calcularTotal() {
    return widget.carrito.fold(0, (sum, item) => sum + (item.precio * item.cantidad));
  }

  @override
  Widget build(BuildContext context) {
    int total = _calcularTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text("Pagar: 💛 $monedasServidor"), 
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.carrito.isEmpty
                ? const Center(child: Text("Carrito vacío"))
                : ListView.builder(
                    itemCount: widget.carrito.length,
                    itemBuilder: (_, i) {
                      final item = widget.carrito[i];
                      return ListTile(
                        leading: Image.asset(item.imagen, width: 40),
                        title: Text(item.nombre),
                        subtitle: Text("Subtotal: 💛 ${item.precio * item.cantidad}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline), 
                              onPressed: () => setState(() {
                                if (item.cantidad > 1) {
                                  item.cantidad--;
                                } else {
                                  widget.carrito.removeAt(i);
                                }
                              })
                            ),
                            Text('${item.cantidad}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline), 
                              onPressed: () => setState(() => item.cantidad++)
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          _botonPagar(total),
        ],
      ),
    );
  }

  Widget _botonPagar(int total) {
    bool puedePagar = monedasServidor >= total && total > 0;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55), 
          backgroundColor: puedePagar ? Colors.green : Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
        ),
        onPressed: puedePagar ? () async {
          bool exito = await ApiService.realizarCompra(widget.userId, widget.carrito, total, widget.categoria);
          if (exito) {
            if (!mounted) return;
            showDialog(
              context: context, 
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: const Text("¡Compra Exitosa! 🎉"),
                content: const Text("Tus nuevos items ya están en la cocina."),
                actions: [
                  TextButton(
                    onPressed: () { 
                      Navigator.pop(context); // Cierra Dialog
                      Navigator.pop(context, true); // Vuelve a la tienda enviando 'true'
                    }, 
                    child: const Text("LISTO")
                  )
                ],
              )
            );
          }
        } : null,
        child: Text("CONFIRMAR PAGO (💛 $total)", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}