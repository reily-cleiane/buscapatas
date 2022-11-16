import 'package:buscapatas/cadastros/cadastro-notificacao-avistado.dart';
import 'package:buscapatas/perfil_usuario.dart';
import 'package:buscapatas/publico/cadastro-usuario.dart';
import 'package:buscapatas/publico/esqueceu-senha.dart';
import 'package:buscapatas/visualizacoes/contato.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/listagens/lista-notificacoes-avistado.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class InfoPostPerdido extends StatefulWidget {
  const InfoPostPerdido({super.key, required this.title});

  final String title;

  @override
  State<InfoPostPerdido> createState() => _InfoPostPerdidoState();
}

class _InfoPostPerdidoState extends State<InfoPostPerdido> {
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
            title: const Text("Animal Perdido",
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
                  child: Text(
                "Zeus",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    decorationThickness: 5.0),
              )),
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
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                        child: Text("Espécie: Cachorro",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                        child: Text("Raça: SRD",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                        child: Text("Sexo: Macho",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                        child: Text("Cor do pelo: Marrom, Preto",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                        child: Text(
                            "Descrição: Gente por favor me ajudem! Meu cachorro viu o portão de casa aberto e fugiu",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                        child: Text(
                            "Orientações gerais: Não é agressivo, pode se aproximar",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                        child: Text("Estava de coleira?: Sim",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 10.0),
                        child: Text("Recompensa: RS 120,00",
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
                                    PerfilUsuario(title: "Perfil")),
                          );
                        },
                        child: Ink(
                          child: RichText(
                            text: const TextSpan(
                              text: "Entrar em contato ",
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
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20)),
              Center(
                  child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(estilo.corprimaria),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)))),
                        onPressed: () {
                          _infoNotificacaoAvistado();
                        },
                        child: const Text("Registrar avistamento",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ))),
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 30)),
              Center(
                  child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(estilo.corprimaria),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)))),
                        onPressed: () {
                          _listaNotificacaoAvistado();
                        },
                        child: const Text("Ver notificacões",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ))),
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 30)),
            ],
          ),
        ));
  }

  void _infoNotificacaoAvistado() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CadastroNotificacaoAvistado(title: "Cadastro Notificação")),
    );
  }

  void _listaNotificacaoAvistado() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => 
            ListaNotificoesAvistado(title: "Cadastro Notificação")),
    );
  }
}
