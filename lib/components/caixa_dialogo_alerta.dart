import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class CaixaDialogoAlerta extends StatelessWidget {
  final String titulo;
  final String conteudo;
  final void Function() funcao;

  CaixaDialogoAlerta({
    this.titulo = '',
    this.conteudo = '',
    required this.funcao,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        titulo,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: <Widget>[
        ElevatedButton(
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(estilo.corprimaria),
            ),
            onPressed: funcao,
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 10.0),
            ))
      ],
      content: Text(
        conteudo,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
