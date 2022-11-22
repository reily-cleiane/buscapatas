import 'package:buscapatas/model/PostModel.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/visualizacoes/contato.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/utils/localizacao.dart' as localizacao;
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/utils/usuario_logado.dart' as usuarioSessao;

class InfoPostAvistado extends StatefulWidget {
  InfoPostAvistado({title, required post}) {
    super.key;
    this.title = "Animal avistado";
    this.post = post;
  }

  String title = "";
  PostModel post = new PostModel();

  @override
  State<InfoPostAvistado> createState() => _InfoPostAvistadoState();
}

class _InfoPostAvistadoState extends State<InfoPostAvistado> {
  PostModel post = new PostModel();

  String coleira = "";
  String dataHora = "";
  String larTemporario = "";
  String especieAnimal = "";
  String racaAnimal = "";
  String coresAnimal = "";
  String sexoAnimal = "";
  UsuarioModel usuarioLogado = UsuarioModel();
  double distancia = 0;

  @override
  void initState() {
    carregarUsuarioLogado();
    post = widget.post;
    formatarDados();
  }

  void carregarUsuarioLogado() async {
    await usuarioSessao
        .getUsuarioLogado()
        .then((value) => usuarioLogado = value);
    //Necessário para recarregar a página após ter pegado o valor de usuarioLogado
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            foregroundColor: Colors.white,
            title: const Text("Animal Avistado",
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
              Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 5)),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
                Container(
                    color: estilo.coravistado,
                    child: Center(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text("Postado em: ${dataHora}",
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
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                    child: Row(children: <Widget>[
                      const Icon(
                        Icons.pets,
                        size: 20,
                        color: estilo.corprimaria,
                      ),
                      Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0)),
                      Text("Espécie: ${especieAnimal}",
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
                        Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0)),
                        Text("Raça: ${racaAnimal}",
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
                        Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0)),
                        Text("Sexo: ${sexoAnimal}",
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
                      Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0)),
                        Expanded(child:   
                      Text("Cor do pelo: ${coresAnimal}",
                          style: TextStyle(color: Colors.black, fontSize: 20)))
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
                        Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0)),
                        Expanded(child:   
                        Text("Descrição: ${post.outrasInformacoes!}",
                            style: TextStyle(color: Colors.black, fontSize: 20)))
                      ])),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                    child: Row(children: <Widget>[
                      const Icon(
                        Icons.commit,
                        size: 20,
                        color: estilo.corprimaria,
                      ),
                      Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0)),
                      Text( coleira,
                          style: TextStyle(color: Colors.black, fontSize: 20))
                    ])),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                    child: Row(children: <Widget>[
                      const Icon(
                        Icons.roofing,
                        size: 20,
                        color: estilo.corprimaria,
                      ),
                      Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0)),
                      Text(larTemporario,
                          style: TextStyle(color: Colors.black, fontSize: 20))
                    ])),
              ]),
              if (usuarioLogado.id != post.usuario!.id)
                Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20)),
              if (usuarioLogado.id != post.usuario!.id)
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
                                      usuario: post.usuario!)),
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

  void formatarDados() async{
    await localizacao.calcularDistanciaPosicaoAtual(post.latitude, post.longitude)
        .then((value) => distancia = value);

    setState(() {
      if (post.especieAnimal?.getNome() != null) {
        especieAnimal = post.especieAnimal!.getNome()!;
      }
      if (post.coleira!) {
        coleira = "Estava com coleira";
      } else {
        coleira = "Não estava com coleira";
      }

      if (post.larTemporario!) {
        larTemporario = "Está em lar temporário";
      } else {
        larTemporario = "Não está em lar temporário";
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
    });
  }
}
