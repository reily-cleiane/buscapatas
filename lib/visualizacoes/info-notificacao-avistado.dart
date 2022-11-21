import 'package:buscapatas/visualizacoes/contato.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:buscapatas/model/NotificacaoAvistamentoModel.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
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
  String distancia = "";
  double valorLatitudeAtual = 0;
  double valorLongitudeAtual = 0;
  UsuarioModel usuarioLogado = new UsuarioModel();

  @override
  void initState() {
    notificacao = widget.notificacao;

    getPosicao();
    formatarDados();
    getUsuarioLogado();
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
                  backgroundImage: AssetImage('imagens/animal.jpg'),
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

                      Padding(
                      padding: EdgeInsets.fromLTRB(0, 1, 0, 1)),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: estilo.corprimaria,
                            ),
                            Text(" A ${distancia} de você.",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14))
                          ]),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 30),
                      child: Row(children: <Widget>[
                        const Icon(
                          Icons.info,
                          size: 20,
                          color: estilo.corprimaria,
                        ),
                        Text("   Mensagem: ${notificacao.mensagem!}",
                            style: TextStyle(color: Colors.black, fontSize: 20))
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

  void formatarDados() {
    dataHora =
        "${notificacao.dataHora!.day.toString().padLeft(2, '0')}/${notificacao.dataHora!.month.toString().padLeft(2, '0')}/${notificacao.dataHora!.year.toString()} às ${notificacao.dataHora!.hour.toString()}:${notificacao.dataHora!.minute.toString()}";
    double dist = calcularDistancia(valorLatitudeAtual, valorLongitudeAtual,
        notificacao.latitude, notificacao.longitude);
    distancia = "${double.parse(dist.toStringAsFixed(2))} km";
  }

  void getUsuarioLogado() async {
    UsuarioModel usuario;
    usuario = UsuarioModel.fromJson(
        await (FlutterSession().get("sessao_usuarioLogado")));
    setState(() {
      usuarioLogado = usuario;
    });
  }

  void getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      valorLatitudeAtual = posicao.latitude;
      valorLongitudeAtual = posicao.longitude;
    } catch (e) {
      e.toString();
    }
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;

    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error('Por favor, habilite a localização no smartphone');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Você precisa autorizar o acesso à localização');
    }

    return await Geolocator.getCurrentPosition();
  }

  double calcularDistancia(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
