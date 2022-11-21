import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-perdido.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class ContatoUsuario extends StatefulWidget {
  ContatoUsuario({super.key, required this.title, required this.usuario});

  final String title;
  UsuarioModel usuario = new UsuarioModel();

  @override
  State<ContatoUsuario> createState() => _ContatoUsuarioState();
}

class _ContatoUsuarioState extends State<ContatoUsuario> {
  UsuarioModel usuarioVisitado = new UsuarioModel();
  List<PostModel> postsUsuario = [];
  UsuarioModel usuarioLogado = UsuarioModel();

   @override
  void initState() {
    getUsuarioLogado();
    getPostsByUsuario();
    usuarioVisitado = widget.usuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Visualizar Perfil",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: estilo.corprimaria),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        usuarioVisitado.nome!,
                        style:
                            TextStyle(fontSize: 24, color: estilo.corprimaria),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('imagens/salsicha.jpg'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Informações de contato',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: estilo.corprimaria)),
                      SizedBox(height: 10),
                      Text(
                        'Número de celular: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 5),
                      Text(usuarioVisitado.telefone!, style: TextStyle(fontSize: 16)),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Email: ', style: TextStyle(fontSize: 16)),
                      Text.rich(TextSpan(
                        text: usuarioVisitado.email!,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      )),
                      SizedBox(height: 25),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Atividade recente",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: estilo.corprimaria),
                      ),
                      const SizedBox(height: 10),
                    Container(
                    height: 300,
                    child: ListView.builder(
                        itemCount: postsUsuario.length,
                        itemBuilder: (context, index) {
                          PostModel? postAtual = null;
                          if (postsUsuario[index] != null) {
                            postAtual = postsUsuario[index];
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
                                _infoPost(postAtual);
                              },
                              child: AnimalCard(post: postAtual),
                            ),
                          ));
                        }),
                  ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getUsuarioLogado() async {
    UsuarioModel usuario;
    usuario = UsuarioModel.fromJson(
        await (FlutterSession().get("sessao_usuarioLogado")));
    setState(() {
      usuarioLogado = usuario;
    });
  }

  void getPostsByUsuario() async {
    List<PostModel> posts = await PostModel.getPostsByUsuario(usuarioVisitado.id);
    setState(() {
      postsUsuario = posts;
    });
  }

   void _infoPost(PostModel? postAtual) {
    if (postAtual?.tipoPost == "ANIMAL_PERDIDO") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoPostPerdido(title: "Animal Perdido", post:postAtual),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoPostAvistado(title: "Animal Avistado", post:postAtual),
          ));
    }
  }


}
