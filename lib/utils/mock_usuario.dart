import 'dart:convert';

import 'package:buscapatas/model/test-user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockUsuario {
  static late SharedPreferences _preferences;

  static const _chaveUsuario =  'usuario';
  static const mockUsuario = User(
    imagem:
        'imagens/homem.jpg',
    nome: 'Luan Gustavo Cláudio dos Santos',
    email: 'luansantos@gmail.com',
    telefone: '(84)998786543'
  );

  static Future init() async => 
    _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_chaveUsuario, json);
  }

  static User getUser() {
    final json = _preferences.getString(_chaveUsuario);

    return json == null ? mockUsuario : User.fromJson(jsonDecode(json));
  }
}