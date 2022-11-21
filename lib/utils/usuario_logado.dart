import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:flutter_session/flutter_session.dart';

Future<UsuarioModel>getUsuarioLogado()async{

  return UsuarioModel.fromJson(
      await (FlutterSession().get("sessao_usuarioLogado")));

}
