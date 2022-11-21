import 'package:buscapatas/cadastros/cadastro-notificacao-avistado.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:buscapatas/perfil_usuario.dart';
import 'package:buscapatas/publico/cadastro-usuario.dart';
import 'package:buscapatas/publico/esqueceu-senha.dart';
import 'package:buscapatas/visualizacoes/contato.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/listagens/lista-notificacoes-avistado.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class InfoPostPerdido extends StatefulWidget {
  InfoPostPerdido({title, post}) {
    super.key;
    this.title = "Animal Perdido";
    this.post = post;
  }

  PostModel post = new PostModel();
  String title = "";

  @override
  State<InfoPostPerdido> createState() => _InfoPostPerdidoState();
}

class _InfoPostPerdidoState extends State<InfoPostPerdido> {
  PostModel post = new PostModel();

  String coleira = "";
  String dataHora = "";
  String especieAnimal = "";
  String racaAnimal = "";
  String coresAnimal = "";
  String sexoAnimal = "";

  @override
  void initState() {
    post = widget.post;
    formatarDados();
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
              Padding(padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0)),
              if (post.nomeAnimal != null && post.nomeAnimal!.isNotEmpty)
                Center(
                    child: Text(
                  post.nomeAnimal!,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      decorationThickness: 5.0),
                )),
              Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 5)),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
                Container(
                    color: estilo.corperdido,
                    child: Center(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text("Postado em: ${dataHora}",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    backgroundColor: estilo.corperdido))))),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                    child: Row(children: <Widget>[
                      const Icon(
                        Icons.pets,
                        size: 20,
                        color: estilo.corprimaria,
                      ),
                      Text("   Espécie: ${especieAnimal}",
                          style: TextStyle(color: Colors.black, fontSize: 20))
                    ])),
                if (racaAnimal.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                      child: Row(children: <Widget>[
                        const Icon(
                          Icons.pets,
                          size: 20,
                          color: estilo.corprimaria,
                        ),
                        Text("   Raça: ${racaAnimal}",
                            style: TextStyle(color: Colors.black, fontSize: 20))
                      ])),
                if (sexoAnimal.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                      child: Row(children: <Widget>[
                        const Icon(
                          Icons.male,
                          size: 20,
                          color: estilo.corprimaria,
                        ),
                        Text("   Sexo: ${sexoAnimal}",
                            style: TextStyle(color: Colors.black, fontSize: 20))
                      ])),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                    child: Row(children: <Widget>[
                      const Icon(
                        Icons.invert_colors,
                        size: 20,
                        color: estilo.corprimaria,
                      ),
                      Text("   Cor do pelo: ${coresAnimal}",
                          style: TextStyle(color: Colors.black, fontSize: 20))
                    ])),
                if (post.outrasInformacoes != null &&
                    post.outrasInformacoes!.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                      child: Row(children: <Widget>[
                        const Icon(
                          Icons.info,
                          size: 20,
                          color: estilo.corprimaria,
                        ),
                        Text("   Descrição: ${post.outrasInformacoes!}",
                            style: TextStyle(color: Colors.black, fontSize: 20))
                      ])),
                if (post.orientacoesGerais != null &&
                    post.orientacoesGerais!.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                      child: Row(children: <Widget>[
                        const Icon(
                          Icons.fact_check,
                          size: 20,
                          color: estilo.corprimaria,
                        ),
                        Text("   Orientações gerais: ${post.orientacoesGerais}",
                            style: TextStyle(color: Colors.black, fontSize: 20))
                      ])),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                    child: Row(children: <Widget>[
                      const Icon(
                        Icons.commit,
                        size: 20,
                        color: estilo.corprimaria,
                      ),
                      Text("   " + coleira,
                          style: TextStyle(color: Colors.black, fontSize: 20))
                    ])),
                if (post.recompensa! > 0)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                      child: Row(children: <Widget>[
                        const Icon(
                          Icons.payments,
                          size: 20,
                          color: estilo.corprimaria,
                        ),
                        Text("   Recompensa: R\$ ${post.recompensa}",
                            style: TextStyle(color: Colors.black, fontSize: 20))
                      ])),
              ]),
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
                          _registrarAvistamento();
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

  void formatarDados() {
    if (post.especieAnimal?.getNome() != null) {
      especieAnimal = post.especieAnimal!.getNome()!;
    }
    if (post.coleira!) {
      coleira = "Estava com coleira";
    } else {
      coleira = "Não estava com coleira";
    }
    dataHora =
        "${post.dataHora!.day.toString().padLeft(2, '0')}/${post.dataHora!.month.toString().padLeft(2, '0')}/${post.dataHora!.year.toString()} às ${post.dataHora!.hour.toString()}:${post.dataHora!.minute.toString()}";

    if (post.racaAnimal?.nome != null) {
      racaAnimal = post.racaAnimal!.nome!;
    }
    if (post.sexoAnimal != null) {
      if (post.sexoAnimal == "M") {
        sexoAnimal = "Macho";
      } else {
        sexoAnimal = "Fêmea";
      }
    }

    if (post.coresAnimal!.isNotEmpty) {
      for (var cor in post.coresAnimal!) {
        coresAnimal = coresAnimal + ", " + cor.nome!;
      }
      coresAnimal = coresAnimal.substring(1);
    }
  }

  void _registrarAvistamento() {
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
