import 'dart:convert';
import 'package:http/http.dart' as http;

CorModel corModelJson(String str) =>
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

  
   static Future<Map<String, int>> getCores() async {
    const request = "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/cores";

    http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var resposta = json.decode(utf8.decode(response.bodyBytes));
      Map<String, int> coresNomeId = {};

      for (var cor in resposta) {
        coresNomeId[cor["nome"]] = cor["id"];
      }
      return coresNomeId;
    } else {
      throw Exception('Falha no servidor ao carregar cores');
    }
  }

}
