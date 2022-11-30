import 'package:buscapatas/cadastros/cadastro_post_avistado.dart';
import 'package:buscapatas/cadastros/cadastro_post_perdido.dart';
import 'package:buscapatas/publico/login.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-perdido.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/visualizacoes/editar-perfil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buscapatas/utils/usuario_logado.dart' as usuarioSessao;
import 'package:buscapatas/components/navbar.dart';
import 'package:buscapatas/components/animal_card.dart';

class VisualizarPerfil extends StatefulWidget {
  VisualizarPerfil({super.key, this.title = ""});

  final String title;

  @override
  State<VisualizarPerfil> createState() => _VisualizarPerfilState();
}

class _VisualizarPerfilState extends State<VisualizarPerfil> {
  List<PostModel> postsUsuario = [];
  UsuarioModel usuarioLogado = UsuarioModel();

  @override
  void initState() {
    carregarUsuarioLogado();
    super.initState();
  }

  void carregarUsuarioLogado() async {
    await usuarioSessao
        .getUsuarioLogado()
        .then((value) => usuarioLogado = value);
    //Posts depende do usuário, precisar estar em uma função async após o await do usuário
    //o getPostByUsuario recarrega a tela com um setState, necessário para ter acesso ao usuarioLogado
    getPostsByUsuario();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider fotoUsuario = (usuarioLogado.caminhoImagem != null)
        ? NetworkImage(
            'https://buscapatas.s3.sa-east-1.amazonaws.com/${usuarioLogado.caminhoImagem}')
        : const NetworkImage(
            'https://buscapatas.s3.sa-east-1.amazonaws.com/usuario-foto-padrao.png');

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BuscapatasNavBar(selectedIndex: 3),
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
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        (usuarioLogado.nome) != null ? usuarioLogado.nome! : "",
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: fotoUsuario,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: estilo.coravistado,
                            side: const BorderSide(
                              color: Color(0xFFA8BFA1),
                            ),
                          ),
                          onPressed: () => {
                            _cadastroPostAnimalAvistado(),
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            child: Text(
                              textAlign: TextAlign.center,
                              "Reportar animal avistado",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: estilo.corperdido,
                            side: const BorderSide(
                              color: Color.fromARGB(255, 238, 212, 176),
                            ),
                          ),
                          onPressed: () => {
                            _cadastroPostAnimalPerdido(),
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            child: Text(
                              textAlign: TextAlign.center,
                              "Perdi meu bichinho",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Atividade recente",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.create_rounded,
                        size: 18,
                        color: estilo.corprimaria,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0.0),
                        child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditarPerfil(
                                        title: "Editar Perfil",
                                        usuario: usuarioLogado)),
                              );
                            },
                            child: Ink(
                              child: RichText(
                                text: const TextSpan(
                                  text: "Editar Perfil",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: estilo.corprimaria,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.logout,
                        size: 18,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0.0),
                        child: InkWell(
                            onTap: () {
                              _deslogar();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login(
                                        title: 'Login - BuscaPatas')),
                              );
                            },
                            child: Ink(
                              child: RichText(
                                text: const TextSpan(
                                  text: "Sair da conta",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.red,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deslogar() async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    preferencias.remove('buscapatas.usuarioEmail');
    preferencias.remove('buscapatas.usuarioSenha');
    await FlutterSession().set("sessao_usuarioLogado", "");
  }

  void _infoPost(post) {
    if (post.tipoPost == "ANIMAL_PERDIDO") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InfoPostPerdido(title: "Animal Perdido", post: post),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InfoPostAvistado(title: "Animal Avistado", post: post),
          ));
    }
  }

  void getPostsByUsuario() async {
    List<PostModel> posts = await PostModel.getPostsByUsuario(usuarioLogado.id);
    setState(() {
      postsUsuario = posts;
    });
  }

  void _cadastroPostAnimalAvistado() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CadastroPostAvistado(title: "Cadastro de Animal Avistado")),
    );
  }

  void _cadastroPostAnimalPerdido() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CadastroPostPerdido(title: "Cadastro de Animal Perdido")),
    );
  }
}
