import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-perdido.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class ContatoUsuario extends StatefulWidget {
  ContatoUsuario({super.key, required this.title, required this.usuario});

  final String title;
  UsuarioModel usuario = UsuarioModel();

  @override
  State<ContatoUsuario> createState() => _ContatoUsuarioState();
}

class _ContatoUsuarioState extends State<ContatoUsuario> {
  UsuarioModel usuarioVisitado = UsuarioModel();
  List<PostModel> postsUsuario = [];

  @override
  void initState() {
    usuarioVisitado = widget.usuario;

    getPostsByUsuario(usuarioVisitado.id!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider fotoUsuario = (usuarioVisitado.caminhoImagem != null)
        ? NetworkImage(
            'https://buspatas.blob.core.windows.net/buscapatas/${usuarioVisitado.caminhoImagem}')
        : const NetworkImage(
            'https://buspatas.blob.core.windows.net/buscapatas/usuario-foto-padrao.png');
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
                        style: const TextStyle(
                            fontSize: 24, color: estilo.corprimaria),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: fotoUsuario,
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
                      const Text('Informações de contato',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: estilo.corprimaria)),
                      const SizedBox(height: 10),
                      const Text(
                        'Número de celular: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 5),
                      Text(usuarioVisitado.telefone!,
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Email: ', style: TextStyle(fontSize: 16)),
                      Text.rich(TextSpan(
                        text: usuarioVisitado.email!,
                        style: const TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      )),
                      const SizedBox(height: 25),
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

  void getPostsByUsuario(int usuarioId) async {
    List<PostModel> posts = await PostModel.getPostsByUsuario(usuarioId);
    setState(() {
      postsUsuario = posts;
    });
  }

  void _infoPost(PostModel? postAtual) {
    if (postAtual?.tipoPost == "ANIMAL_PERDIDO") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InfoPostPerdido(title: "Animal Perdido", post: postAtual),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InfoPostAvistado(title: "Animal Avistado", post: postAtual),
          ));
    }
  }
}
