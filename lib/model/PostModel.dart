import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/model/CorModel.dart';
import 'package:buscapatas/model/EspecieModel.dart';
import 'package:buscapatas/model/RacaModel.dart';

PostModel postModelJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  int? id;
  String? tipoPost;
  String? outrasInformacoes;
  String? orientacoesGerais;
  int? recompensa;
  bool? larTemporario;
  double? latitude;
  double? longitude;
  String? nomeAnimal;
  bool? coleira;
  DateTime? dataHora = DateTime.now();
  UsuarioModel? usuario;
  //AJUSTAR QUANDO CRIAR O ESPECIEMODEL
  EspecieModel? especieAnimal;
  //AJUSTAR QUANDO CRIAR O RACAMODEL
  RacaModel? racaAnimal;
  //AJUSTAR QUANDO CRIAR O CORMODEL
  List<CorModel>? coresAnimal;
  String? sexoAnimal;

  PostModel(
      {this.id,
      this.outrasInformacoes,
      this.orientacoesGerais,
      this.recompensa,
      this.larTemporario,
      this.latitude,
      this.longitude,
      this.nomeAnimal,
      this.coleira,
      this.dataHora,
      this.especieAnimal,
      this.racaAnimal,
      this.coresAnimal,
      this.sexoAnimal,
      this.tipoPost,
      this.usuario});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        id: json["id"],
        dataHora: DateTime.parse(json["dataHora"]),
        outrasInformacoes: json["outrasInformacoes"],
        orientacoesGerais: json["orientacoesGerais"],
        recompensa: json["recompensa"],
        larTemporario: json["larTemporario"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        nomeAnimal: json["nomeAnimal"],
        coleira: json["coleira"],
        especieAnimal: EspecieModel.fromJson(json["especieAnimal"]),
        racaAnimal: RacaModel.fromJson(json["racaAnimal"]),
        coresAnimal: List<CorModel>.from(
            json["coresAnimal"]!.map((x) => CorModel.fromJson(x))),
        sexoAnimal: json["sexo"],
        tipoPost: json["tipoPost"],
        usuario: UsuarioModel.fromJson(json["usuario"]));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "outrasInformacoes": outrasInformacoes,
        "orientacoesGerais": orientacoesGerais,
        "recompensa": recompensa,
        "larTemporario": larTemporario,
        "latitude": latitude,
        "longitude": longitude,
        "nomeAnimal": nomeAnimal,
        "coleira": coleira,
        "especieAnimal": jsonEncode(especieAnimal),
        "racaAnimal": jsonEncode(racaAnimal),
        "coresAnimal": jsonEncode(coresAnimal),
        //"coresAnimal": List<CorModel>.from(coresAnimal!.map((x) => x.toJson())),
        "sexoAnimal": sexoAnimal,
        "tipoPost": tipoPost,
        "usuario": jsonEncode(usuario),
      };

  //Refatorar para o método completo para salvar post ficar aqui, e não só a URL
  static String getUrlSalvarPost() {
    return "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/posts";
  }

  EspecieModel? getEspecie(){
    return this.especieAnimal;

  }
  static Future<List<PostModel>> getPostsAnimaisPerdidos() async {
    const request = "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/posts/perdidos";

    http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var resposta = json.decode(utf8.decode(response.bodyBytes));
      List<PostModel> posts = [];

      for (var post in resposta) {
        posts.add(PostModel.fromJson(post));
      }

      return posts;
    } else {
      throw Exception('Falha no servidor ao carregar posts');
    }
  }

  static Future<List<PostModel>> getPostsAnimaisAvistados() async {
    const request = "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/posts/avistados";

    http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var resposta = json.decode(utf8.decode(response.bodyBytes));
      List<PostModel> posts = [];

      for (var post in resposta) {
        posts.add(PostModel?.fromJson(post));
      }

      return posts;
    } else {
      throw Exception('Falha no servidor ao carregar posts');
    }
  }

  static Future<List<PostModel>> getPostsAnimaisProximos() async {
    //AJUSTAR ISSO AQUI PARA SER POSTS PRÓXIMOS E NÃO TODOS OS POSTS
    const request = "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/posts";

    http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var resposta = json.decode(utf8.decode(response.bodyBytes));
      List<PostModel> posts = [];

      for (var post in resposta) {
        posts.add(PostModel?.fromJson(post));
      }

      return posts;
    } else {
      throw Exception('Falha no servidor ao carregar posts');
    }
  }

  static Future<List<PostModel>> getPostsByUsuario(int? idUsuario) async {

    var request = "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/posts/usuario/${idUsuario}";

    http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var resposta = json.decode(utf8.decode(response.bodyBytes));
      List<PostModel> posts = [];

      for (var post in resposta) {
        posts.add(PostModel?.fromJson(post));
      }

      return posts;
    } else {
      throw Exception('Falha no servidor ao carregar posts');
    }
  }

}
