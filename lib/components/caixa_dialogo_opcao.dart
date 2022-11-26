import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class CaixaDialogoOpcao extends StatelessWidget {
  final String titulo;
  final String conteudo;
  final String textoPrincipal;
  final String textoSecundario;
  final void Function(dynamic parametrofp) funcaoPrincipal;
  final void Function(dynamic parametrofs) funcaoSecundaria;
  dynamic parametrofs;
  dynamic parametrofp;
  Widget? cancelar;
  Widget? confirmar;

  CaixaDialogoOpcao({
    super.key,
    this.titulo = '',
    this.conteudo = '',
    required this.funcaoPrincipal,
    required this.funcaoSecundaria,
    required this.textoPrincipal,
    required this.textoSecundario,
    required this.parametrofs,
    required this.parametrofp,
  }) {
    confirmar = ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Color.fromARGB(255, 245, 245, 245)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)))),
      child: Text(textoPrincipal,
          style: TextStyle(color: estilo.corpreto, fontSize: 12)),
      onPressed: () => funcaoPrincipal(parametrofp),
    );

    cancelar = ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(estilo.corprimaria)),
        child: Text(textoSecundario,
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), fontSize: 12)),
        onPressed: () => funcaoSecundaria(parametrofs));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        titulo,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: <Widget>[
        confirmar!,
        cancelar!,
      ],
      content: Text(
        conteudo,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
