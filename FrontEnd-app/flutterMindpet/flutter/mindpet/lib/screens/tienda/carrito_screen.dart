import 'package:flutter/material.dart';
import '../../models/item.dart';
import '../../services/api_service.dart';

class CarritoScreen extends StatefulWidget {
  final List<Item> carrito;
  final String categoria;
  final int userId;

  const CarritoScreen({
    super.key,
    required this.carrito,
    required this.categoria,
    required this.userId,
  });

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  int monedasServidor = 0;
  bool cargando = false;

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
    return widget.carrito.fold(
      0,
      (sum, item) => sum + (item.precio * item.cantidad),
    );
  }

  @override
  Widget build(BuildContext context) {
    int total = _calcularTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text(" Tu carrito: 💛 $monedasServidor"),
        backgroundColor: const Color.fromARGB(255, 159, 205, 255),
        elevation: 0,
        actions: [
          // Botón para vaciar todo el carrito de golpe
          if (widget.carrito.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => setState(() => widget.carrito.clear()),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fondo/fondocarrito.png"), // Imagen local
              fit: BoxFit.cover, // Ajusta la imagen al tamaño
            ), 
            ),
        child: Column(
          children: [
            Expanded(
              child: widget.carrito.isEmpty
              
                  ? Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: const Align(
                      alignment: Alignment.topCenter,
                        child: Text(
                          "El carrito está vacío 🛒",
                          style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                  )
                  : ListView.builder(
                      itemCount: widget.carrito.length,
                      itemBuilder: (_, i) {
                        final item = widget.carrito[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: ListTile(
                            leading: Image.asset(item.imagen, width: 40),
                            title: Text(
                              item.nombre,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Subtotal: 💛 ${item.precio * item.cantidad}",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => setState(() {
                                    if (item.cantidad > 1) {
                                      item.cantidad--;
                                    } else {
                                      widget.carrito.removeAt(i);
                                    }
                                  }),
                                ),
                                Text(
                                  '${item.cantidad}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green,
                                  ),
                                  onPressed: () =>
                                      setState(() => item.cantidad++),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Resumen de saldo después de la compra
            if (widget.carrito.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.circular(5), color: Colors.white),
                
                child: Text(
                  "Saldo restante: 💛 ${monedasServidor - total}",
                  style: TextStyle(
                    color: (monedasServidor - total) < 0
                        ? const Color.fromARGB(255, 254, 113, 103)
                        : const Color.fromARGB(255, 103, 175, 106),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            _botonPagar(total),
          ],
        ),
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
          backgroundColor: puedePagar ? const Color.fromARGB(255, 103, 169, 105) : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: (puedePagar && !cargando)
            ? () async {
                setState(() => cargando = true);

                // Esto ya está en tu CarritoScreen
                bool exito = await ApiService.realizarCompra(
                  widget.userId,
                  widget.carrito,
                  total,
                  widget
                      .categoria, // <--- Aquí envía "COMIDA" o "ASEO" según de dónde venga
                );

                setState(() => cargando = false);

                if (exito) {
                  if (!mounted) return;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text("¡Compra Exitosa!"),
                      content: const Text(
                        "Tus nuevos items ya están listos para usar.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Cierra Dialog
                            Navigator.pop(
                              context,
                              true,
                            ); // Vuelve a la tienda y avisa que limpie el carro
                          },
                          child: const Text(
                            "Entendido",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Error al procesar la compra"),
                    ),
                  );
                }
              }
            : null,
        child: cargando
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                puedePagar
                    ? "CONFIRMAR PAGO (💛 $total)"
                    : (total == 0 ? "CARRITO VACÍO" : "SALDO INSUFICIENTE"),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
