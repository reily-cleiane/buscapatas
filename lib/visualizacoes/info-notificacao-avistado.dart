import 'package:buscapatas/visualizacoes/contato.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/utils/localizacao.dart' as localizacao;
import 'package:buscapatas/model/NotificacaoAvistamentoModel.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class InfoNotificacaoAvistado extends StatefulWidget {
  InfoNotificacaoAvistado({title, notificacao}) {
    super.key;
    this.title = title;
    this.notificacao = notificacao;
  }

  String title = "";
  NotificacaoAvistamentoModel notificacao = new NotificacaoAvistamentoModel();

  @override
  State<InfoNotificacaoAvistado> createState() =>
      _InfoNotificacaoAvistadoState();
}

class _InfoNotificacaoAvistadoState extends State<InfoNotificacaoAvistado> {
  NotificacaoAvistamentoModel notificacao = new NotificacaoAvistamentoModel();
  String dataHora = "";
  double distancia = 0;

  @override
  void initState() {
    notificacao = widget.notificacao;
    formatarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            foregroundColor: Colors.white,
            title: const Text("Notificação",
                style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: estilo.corprimaria),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(30.0, 30, 30.0, 10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                      'https://buspatas.blob.core.windows.net/buscapatas/${notificacao.caminhoImagem}'),
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 5)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      color: estilo.coravistado,
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text("Registrado em: ${dataHora}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ))))),
                  Padding(padding: EdgeInsets.fromLTRB(0, 1, 0, 1)),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: estilo.corprimaria,
                        ),
                        Text(" A ${distancia} km de você.",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.black, fontSize: 14))
                      ]),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 30),
                      child: Row(children: <Widget>[
                        const Icon(
                          Icons.info,
                          size: 20,
                          color: estilo.corprimaria,
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(0, 0, 15, 0)),
                        Expanded(
                            child: Text("Mensagem: ${notificacao.mensagem!}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20)))
                      ])),
                  Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('imagens/salsicha.jpg'),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContatoUsuario(
                                        title: "Contato",
                                        usuario: notificacao.usuario!)),
                              );
                            },
                            child: Ink(
                              child: RichText(
                                text: const TextSpan(
                                  text: "Ver informações de contato ",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: estilo.corprimaria,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 30)),
                ],
              ),
            ])));
  }

  void formatarDados() async {
    dataHora =
        "${notificacao.dataHora!.day.toString().padLeft(2, '0')}/${notificacao.dataHora!.month.toString().padLeft(2, '0')}/${notificacao.dataHora!.year.toString()} às ${notificacao.dataHora!.hour.toString()}:${notificacao.dataHora!.minute.toString()}";

    await localizacao
        .calcularDistanciaPosicaoAtual(
            notificacao.latitude, notificacao.longitude)
        .then((value) => distancia = value);
    setState(() {});
  }
}
