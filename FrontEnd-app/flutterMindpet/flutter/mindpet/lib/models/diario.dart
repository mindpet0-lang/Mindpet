class Diario {
  final int id;
  final int userId;
  final String mensaje;
  final String fecha; // Opcional según tu API

  Diario({
    required this.id,
    required this.userId,
    required this.mensaje,
    this.fecha = "",
  });

  factory Diario.fromJson(Map<String, dynamic> json) {
    return Diario(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      mensaje: json['mensaje'] ?? '',
      fecha: json['fecha'] ?? '',
    );
  }
}