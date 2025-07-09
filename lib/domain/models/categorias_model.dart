import 'dart:convert';

class Categorias {
  final int id;
  final String createdAt;
  final String titulo;
  final String userId;

  Categorias({
    required this.id,
    required this.createdAt,
    required this.titulo,
    required this.userId,
  });

  factory Categorias.fromJson(Map<String, dynamic> json) {
    return Categorias(
      id: json['id'],
      createdAt: json['created_at'],
      titulo: json['titulo'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt,
      'titulo': titulo,
      'user_id': userId,
    };
  }

  static Categorias fromMap(Map<String, dynamic> map) {
    return Categorias(
      id: map['id'],
      createdAt: map['created_at'],
      titulo: map['titulo'],
      userId: map['user_id'],
    );
  }

  String toJson() => jsonEncode(toMap());

  static List<Map<String, dynamic>> listToMap(List<Categorias> list) =>
      list.map((e) => e.toMap()).toList();

  static List<Categorias> listFromJson(String jsonString) {
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded.map((e) => Categorias.fromMap(e)).toList();
  }
}
