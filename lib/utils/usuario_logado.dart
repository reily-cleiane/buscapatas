import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:flutter_session/flutter_session.dart';

UsuarioModel usuario = UsuarioModel();

UsuarioModel getUsuarioLogado(){
  getUsuarioSessao();
  return usuario;
}

void getUsuarioSessao()async{
  UsuarioModel usuarioSessao;
  usuarioSessao = UsuarioModel.fromJson(
      await (FlutterSession().get("sessao_usuarioLogado")));

  usuario = usuarioSessao;
}
