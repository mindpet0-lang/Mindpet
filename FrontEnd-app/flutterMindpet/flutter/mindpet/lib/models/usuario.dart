class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final int monedas;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.monedas,
  });

  // Mapea perfectamente los tipos de Spring Boot a Dart
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? 'Sin nombre',
      correo: json['correo'] ?? 'Sin correo',
      monedas: json['monedas'] ?? 0,
    );
  }
}