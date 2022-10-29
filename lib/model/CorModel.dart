import 'dart:convert';

CorModel usuairoModelJson(String str) =>
    CorModel.fromJson(json.decode(str));

String corModelToJson(CorModel data) => json.encode(data.toJson());

class CorModel {
  int? id;
  String? nome;

  CorModel({this.id, this.nome});

  CorModel.id(this.id);

  factory CorModel.fromJson(Map<String, dynamic> json) {
    return CorModel(
        id: json["id"],
        nome: json["nome"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
      };
}
