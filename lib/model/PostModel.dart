import 'dart:convert';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/model/CorModel.dart';

PostModel usuairoModelJson(String str) => PostModel.fromJson(json.decode(str));

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
  DateTime dataHora = DateTime.now();
  UsuarioModel? usuario;
  //AJUSTAR QUANDO CRIAR O ESPECIEMODEL
  int? especieAnimal;
  //AJUSTAR QUANDO CRIAR O RACAMODEL
  int? racaAnimal;
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
      this.especieAnimal,
      this.racaAnimal,
      this.coresAnimal,
      this.sexoAnimal,
      this.tipoPost,
      this.usuario});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        id: json["id"],
        outrasInformacoes: json["outrasInformacoes"],
        orientacoesGerais: json["orientacoesGerais"],
        recompensa: json["recompensa"],
        larTemporario: json["larTemporario"],
        latitude: json["larTemporario"],
        longitude: json["longitude"],
        nomeAnimal: json["nomeAnimal"],
        coleira: json["coleira"],
        especieAnimal: json["especieAnimal"],
        racaAnimal: json["racaAnimal"],
        coresAnimal: json["coresAnimal"],
        sexoAnimal: json["sexo"],
        tipoPost: json["tipoPost"],
        usuario: json["usuario"]);
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
        "especieAnimal": especieAnimal,
        "racaAnimal": racaAnimal,
        "coresAnimal": List<CorModel>.from(coresAnimal!.map((x) => x.toJson())),
        "sexoAnimal": sexoAnimal,
        "tipoPost": tipoPost,
        "usuario": jsonEncode(usuario),
      };


  //Refatorar para o método completo para salvar post ficar aqui, e não só a URL
  static String getUrlSalvarPost(){
    return "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/posts";
  }
  
}
