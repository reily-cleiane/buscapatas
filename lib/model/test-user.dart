class User {
  final String imagem;
  final String nome;
  final String email;
  final String telefone;
  final String senha;

  const User({
    required this.imagem,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
  });

  User copy({
    String? imagem,
    String? nome,
    String? email,
    String? telefone,
    String? senha,
  }) =>
      User(
        imagem: imagem ?? this.imagem,
        nome: nome ?? this.nome,
        email: email ?? this.email,
        telefone: telefone ?? this.telefone,
        senha: senha ?? this.senha,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        imagem: json['imagem'],
        nome: json['nome'],
        email: json['email'],
        telefone: json['telefone'],
        senha: json['senha'],
      );

  Map<String, dynamic> toJson() => {
        'imagem': imagem,
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'senha': senha,
      };
}