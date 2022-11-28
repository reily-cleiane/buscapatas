import 'dart:convert';

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

  //Refatorar para o método completo para salvar usuário ficar aqui, e não só a URL
  static String getUrlSalvarUsuario() {
    return "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/users";
  }

//Refatorar para o método completo para pesquisar usuário por email ficar aqui, e não só a URL
  static String getUrlFindByEmail(var email) {
    return "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/findbyemail?email=${email}";
  }

  //Refatorar para o método completo para verificar usuário cadastrado ficar aqui, e não só a URL
  static String getUrlVerificarUsuarioAutorizado(var email, var senha) {
    return "http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/usuarioautorizado?email=${email}&senha=${senha}";
  }
}
