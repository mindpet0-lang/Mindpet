class Item {
  final String nombre;
  final int precio;
  final String imagen;
  int cantidad; // Para poder sumar y restar

  Item({
    required this.nombre,
    required this.precio,
    required this.imagen,
    this.cantidad = 1,
  });

  // Esto es vital para que al sumar monedas no se confunda con el carrito
  // En lib/models/item.dart
  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "imagen": imagen,
      "cantidad": cantidad ?? 1, // Aseguramos que nunca sea nulo
      "precio": precio,
      // "categoria" se envía en el cuerpo principal del POST, no dentro de cada item
    };
  }
}
