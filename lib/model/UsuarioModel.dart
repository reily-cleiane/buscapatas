import 'dart:convert';

UsuarioModel usuairoModelJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  int id;
  String username;
  String email;
  String senha;
  String telefone;

  UsuarioModel(
      {required this.id,
      required this.username,
      required this.email,
      required this.senha,
      required this.telefone});

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      senha: json["senha"],
      telefone: json["telefone"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "senha": senha,
        "telefone": telefone,
      };
}
