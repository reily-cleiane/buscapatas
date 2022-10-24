import 'dart:convert';

UsuarioModel usuairoModelJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  int? id;
  String? nome;
  String email;
  String senha;
  String? telefone;

  UsuarioModel(
      {required this.id,
      required this.nome,
      required this.email,
      required this.senha,
      required this.telefone});

  UsuarioModel.emailSenha(this.email, this.senha);

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
      id: json["id"],
      nome: json["nome"],
      email: json["email"],
      senha: json["senha"],
      telefone: json["telefone"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "email": email,
        "senha": senha,
        "telefone": telefone,
      };
      
}
