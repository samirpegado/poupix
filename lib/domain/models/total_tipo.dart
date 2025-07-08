class TotalTipoModel {
  final double valor;
  final String nomeTipo;

  TotalTipoModel({
    required this.valor,
    required this.nomeTipo,
  });

  factory TotalTipoModel.fromJson(Map<String, dynamic> json) {
    return TotalTipoModel(
      valor: (json['valor'] as num).toDouble(),
      nomeTipo: json['nome_tipo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'nome_tipo': nomeTipo,
    };
  }
}
