import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/model/PostModel.dart';


NotificacaoAvistamentoModel notificacaoAvistamentoModelJson(String str) => NotificacaoAvistamentoModel.fromJson(json.decode(str));

String NotificacaoAvistamentoModelToJson(NotificacaoAvistamentoModel data) => json.encode(data.toJson());

class NotificacaoAvistamentoModel {
  int? id;
  String? mensagem;
  double? latitude;
  double? longitude;
  DateTime? dataHora = DateTime.now();
  PostModel? post;
  UsuarioModel? usuario;

  NotificacaoAvistamentoModel(
      {this.id,
      this.mensagem,
      this.latitude,
      this.longitude,
      this.dataHora,
      this.post,
      this.usuario});

  factory NotificacaoAvistamentoModel.fromJson(Map<String, dynamic> json) {
    return NotificacaoAvistamentoModel(
        id: json["id"],
        mensagem: json["mensagem"],
        dataHora: DateTime.parse(json["dataHora"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
        post: PostModel.fromJson(json["post"]),
        usuario: UsuarioModel.fromJson(json["usuario"]));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "mensagem": mensagem,
        "latitude": latitude,
        "longitude": longitude,
        "post": jsonEncode(post),
        "usuario": jsonEncode(usuario),
      };


  static Future<List<NotificacaoAvistamentoModel>> getNotificacoesByPost(int? idPost) async {
    //AJUSTAR ISSO AQUI PARA PEGAR DO POST CERTO
    const request = "http://localhost:8080/notificacoes/post/4";
    //const request = "http://localhost:8080/notificacoes/post/${idUsuario}";

    http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var resposta = json.decode(utf8.decode(response.bodyBytes));
      List<NotificacaoAvistamentoModel> posts = [];

      for (var post in resposta) {
        posts.add(NotificacaoAvistamentoModel?.fromJson(post));
      }

      return posts;
    } else {
      throw Exception('Falha no servidor ao carregar posts');
    }
  }

  static Future<List<NotificacaoAvistamentoModel>> getNotificacoesByUsuario(int? idUsuario) async {
    //AJUSTAR ISSO AQUI PARA PEGAR DO USUARIO CERTO
    const request = "http://localhost:8080/notificacoes/usuario/1";
    //const request = "http://localhost:8080/notificacoes/usuario/${idUsuario}";

    http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var resposta = json.decode(utf8.decode(response.bodyBytes));
      List<NotificacaoAvistamentoModel> posts = [];

      for (var post in resposta) {
        posts.add(NotificacaoAvistamentoModel?.fromJson(post));
      }

      return posts;
    } else {
      throw Exception('Falha no servidor ao carregar posts');
    }
  }

}
