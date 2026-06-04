class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final int monedas;
  late final String foto_perfil;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.monedas,
    required this.foto_perfil
  });

  // Mapea perfectamente los tipos de Spring Boot a Dart
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? 'Sin nombre',
      correo: json['correo'] ?? 'Sin correo',
      foto_perfil: json['fotoPerfil'] ?? 'Sin foto de perfil',
      monedas: json['monedas'] ?? 0,
    );
  }
}