import 'dart:convert';

EspecieModel usuairoModelJson(String str) =>
    EspecieModel.fromJson(json.decode(str));

String especieModelToJson(EspecieModel data) => json.encode(data.toJson());

class EspecieModel {
  int? id;
  String? nome;

  EspecieModel({this.id, this.nome});

  EspecieModel.id(this.id);

  factory EspecieModel.fromJson(Map<String, dynamic> json) {
    return EspecieModel(
        id: json["id"],
        nome: json["nome"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
      };
}
