import 'package:buscapatas/visualizacoes/contato.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class InfoNotificacaoAvistado extends StatefulWidget {
  const InfoNotificacaoAvistado({super.key, required this.title});

  final String title;

  @override
  State<InfoNotificacaoAvistado> createState() =>
      _InfoNotificacaoAvistadoState();
}

class _InfoNotificacaoAvistadoState extends State<InfoNotificacaoAvistado> {
  @override
  void initState() {
    //Para pegar o valor da sessao
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            foregroundColor: Colors.white,
            title: const Text("Notificação do Post",
                style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: estilo.corprimaria),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30.0, 30, 30.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('imagens/animal.jpg'),
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 10.0)),
              Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                        child: Text("Data da postagem: 14/10/2022 às 17:32",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10.0),
                        child: Text(
                            "O animal estava perto do super show do Amarante.",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10.0),
                        child: Text("Distância: 500 metros de você.",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
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
                                builder: (context) =>
                                    ContatoUsuario(title: "Perfil", usuario: UsuarioModel())),
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
        ));
  }
}
