import 'dart:convert';
import 'package:http/http.dart' as http;

RacaModel racaModelJson(String str) => RacaModel.fromJson(json.decode(str));

String RacaModelToJson(RacaModel data) => json.encode(data.toJson());

class RacaModel {
  int? id;
  String? nome;

  RacaModel({this.id, this.nome});

  RacaModel.id(this.id);

  String? getNome() {
    return this.nome;
  }

  factory RacaModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return RacaModel();
    } else {
      return RacaModel(id: json["id"], nome: json["nome"]);
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
      };

  static Future<List<dynamic>> getRacasByEspecie(
      var valorEspecieSelecionado) async {
    var request =
        "http://buscapatasbackend-env.eba-qtcpmdpp.sa-east-1.elasticbeanstalk.com/racas/especie/${valorEspecieSelecionado}";

    http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var resposta = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> racas = [];

      for (var raca in resposta) {
        racas.add({"id": raca["id"], "nome": raca["nome"]});
      }

      return racas;
    } else {
      throw Exception('Falha no servidor ao carregar raças');
    }
  }
}
