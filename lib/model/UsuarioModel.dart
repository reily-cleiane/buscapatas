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

  UsuarioModel({this.id, this.nome, this.email, this.senha, this.telefone});

  UsuarioModel.id(this.id);

  UsuarioModel.emailSenha(this.email, this.senha);

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
        id: json["id"],
        nome: json["nome"],
        email: json["email"],
        senha: json["senha"],
        telefone: json["telefone"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "email": email,
        "senha": senha,
        "telefone": telefone,
      };

      //Refatorar para o método completo para salvar usuário ficar aqui, e não só a URL
  static String getUrlSalvarUsuario(){
    return "http://localhost:8080/users";
  }
//Refatorar para o método completo para pesquisar usuário por email ficar aqui, e não só a URL
  static String getUrlFindByEmail(var email){
    return "http://localhost:8080/findbyemail?email=${email}";
  }

  //Refatorar para o método completo para verificar usuário cadastrado ficar aqui, e não só a URL
  static String getUrlVerificarUsuarioAutorizado(var email, var senha){
    return "http://localhost:8080/usuarioautorizado?email=${email}&senha=${senha}";
  }

}
