import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/components/navbar-extra.dart';
import 'package:buscapatas/visualizacoes/info-notificacao-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-perdido.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class ListaNotificoesAvistado extends StatefulWidget {
  const ListaNotificoesAvistado({super.key, required this.title});

  final String title;

  @override
  State<ListaNotificoesAvistado> createState() =>
      _ListaNotificoesAvistadoState();
}

class _ListaNotificoesAvistadoState extends State<ListaNotificoesAvistado> {
  List<String> listaNotificacoesAvistado = [];
  TextEditingController buscaController = TextEditingController();

  @override
  void initState() {
    //Para pegar o valor da sessao
  }

  @override
  Widget build(BuildContext context) {
    listaNotificacoesAvistado.add("Pessoa 1");
    listaNotificacoesAvistado.add("Pessoa 2");
    listaNotificacoesAvistado.add("Pessoa 3");
    listaNotificacoesAvistado.add("Pessoa 4");
    listaNotificacoesAvistado.add("Pessoa 5");
    listaNotificacoesAvistado.add("Pessoa 6");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Notificações do Post",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: estilo.corprimaria),
        bottomNavigationBar: const BuscapatasNavBarExtra(),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10, 30.0, 10.0),
          child: Column(children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: listaNotificacoesAvistado.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        child: Card(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide.none,
                          ),
                        ),
                        onPressed: () {
                          _infoNotificacaoAvistado();
                        },
                        child: AnimalCard(
                            title: listaNotificacoesAvistado[index],
                            details:
                                "Ele foi encontrado perto do supershow do Amarante.",
                            backgroundColor: estilo.coravistado,
                            image: "imagens/homem.jpg"),
                      ),
                    ));
                  }),
            ),
          ])),
    );
  }

  void _infoNotificacaoAvistado() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              InfoNotificacaoAvistado(title: "Notificação do Post")),
    );
  }
}
