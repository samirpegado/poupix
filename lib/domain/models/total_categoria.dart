class TotalCategoriaModel {
  final double valor;
  final String nomeCategoria;

  TotalCategoriaModel({
    required this.valor,
    required this.nomeCategoria,
  });

  factory TotalCategoriaModel.fromJson(Map<String, dynamic> json) {
    return TotalCategoriaModel(
      valor: (json['valor'] as num).toDouble(),
      nomeCategoria: json['nome_categoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'nome_categoria': nomeCategoria,
    };
  }
}