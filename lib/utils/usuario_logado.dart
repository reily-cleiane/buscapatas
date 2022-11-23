import 'dart:convert';

import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:flutter_session/flutter_session.dart';

Future setUsuarioLogado(UsuarioModel user) async {
  final json = jsonEncode(user.toJson());
  await (FlutterSession().set("sessao_usuarioLogado", json));
}

Future<UsuarioModel>getUsuarioLogado()async{

  return UsuarioModel.fromJson(
      await (FlutterSession().get("sessao_usuarioLogado")));

}
