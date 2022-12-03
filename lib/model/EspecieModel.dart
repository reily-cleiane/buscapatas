import 'dart:convert';
import 'package:http/http.dart' as http;

EspecieModel especieModelJson(String str) =>
    EspecieModel.fromJson(json.decode(str));

String especieModelToJson(EspecieModel data) => json.encode(data.toJson());

class EspecieModel {
  int? id;
  String? nome;

  EspecieModel({this.id, this.nome});

  EspecieModel.id(this.id);

  String? getNome() {
    return this.nome;
  }

  factory EspecieModel.fromJson(Map<String, dynamic> json) {
    return EspecieModel(id: json["id"], nome: json["nome"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
      };

  static Future<List<dynamic>> getEspecies() async {
    const request =
        "http://buscapatasbackend-env.eba-qtcpmdpp.sa-east-1.elasticbeanstalk.com/especies";

    http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var resposta = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> especies = [];

      for (var especie in resposta) {
        especies.add(especie);
      }

      return especies;
    } else {
      throw Exception('Falha no servidor ao carregar espécies');
    }
  }
}
