import 'dart:convert';
import 'package:http/http.dart' as http;

UsuarioModel usuairoModelJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  int? id;
  String? nome;
  String? email;
  String? senha;
  String? telefone;
  String? caminhoImagem;

  UsuarioModel(
      {this.id,
      this.nome,
      this.email,
      this.senha,
      this.telefone,
      this.caminhoImagem});

  UsuarioModel.id(this.id);

  UsuarioModel.emailSenha(this.email, this.senha);

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
        id: json["id"],
        nome: json["nome"],
        email: json["email"],
        senha: json["senha"],
        telefone: json["telefone"],
        caminhoImagem: json["caminhoImagem"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "email": email,
        "senha": senha,
        "telefone": telefone,
        "caminhoImagem": caminhoImagem,
      };

  UsuarioModel copy({
    int? id,
    String? nome,
    String? email,
    String? senha,
    String? telefone,
    String? caminhoImagem,
  }) =>
      UsuarioModel(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        email: email ?? this.email,
        senha: senha ?? this.senha,
        telefone: telefone ?? this.telefone,
        caminhoImagem: caminhoImagem ?? this.caminhoImagem,
      );

  Future<http.Response> salvar() async {
    var url =
        "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/users";

    var request = new http.MultipartRequest("POST", Uri.parse(url));

    request.fields['jsondata'] = json.encode(this.toJson());

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);

    return responsed;
  }

  static Future<List<UsuarioModel>> getUsuariosByEmailSenha(
      String email, String senha) async {
    var url =
        "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/usuarioautorizado?email=${email}&senha=${senha}";

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    List<UsuarioModel> listaUsarios = [];
    if (response.statusCode == 200) {
      var resposta = json.decode(response.body);

      for (var usuario in resposta) {
        if (usuario['email'].isNotEmpty) {
          listaUsarios.add(UsuarioModel.fromJson(usuario));
        }
      }
      //print(jsonDecode(response.body));
    } else {
      throw Exception('Falha no servidor ao carregar usuários');
    }

    return listaUsarios;
  }

  static Future<List<UsuarioModel>> getUsuariosByEmail(String email) async {
    var url =
        "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/findbyemail?email=${email}";
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    List<UsuarioModel> listaUsarios = [];
    if (response.statusCode == 200) {
      var resposta = json.decode(response.body);

      for (var usuario in resposta) {
        if (usuario['email'].isNotEmpty) {
          listaUsarios.add(UsuarioModel.fromJson(usuario));
        }
      }

      //print(jsonDecode(response.body));
    } else {
      throw Exception('Falha no servidor ao carregar usuários');
    }
    return listaUsarios;
  }
}
