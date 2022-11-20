import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/components/navbar-extra.dart';
import 'package:buscapatas/visualizacoes/info-notificacao-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-perdido.dart';
import 'package:buscapatas/model/NotificacaoAvistamentoModel.dart';
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
  List<NotificacaoAvistamentoModel> notificacoes = [];

  @override
  void initState() {
    _getNotificacoesByPost();
    //Para pegar o valor da sessao
  }

  @override
  Widget build(BuildContext context) {

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
                  itemCount: notificacoes.length,
                  itemBuilder: (context, index) {
                    NotificacaoAvistamentoModel? notificacaoAtual = null ;
                    if(notificacoes[index]!=null){
                      notificacaoAtual = notificacoes[index];                         
                    }
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
                        child: AnimalCard.notificacao(notificacao:notificacaoAtual
                      ),
                    )));
                  }),
            ),
          ])),
    );
  }

  void _getNotificacoesByPost() async{
    //AJUSTAR AQUI PARA PASSAR O ID POST DINÂMICO
    List<NotificacaoAvistamentoModel> listaNotificacoes = await NotificacaoAvistamentoModel.getNotificacoesByPost(4);
    setState(() {
      notificacoes = listaNotificacoes;
    });

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
