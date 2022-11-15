import 'package:buscapatas/cadastros/cadastro-post-avistado.dart';
import 'package:buscapatas/cadastros/cadastro-post-perdido.dart';
import 'package:buscapatas/utils/mock_usuario.dart';
import 'package:buscapatas/publico/login.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/visualizacoes/editar-perfil.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/components/navbar.dart';
import 'package:buscapatas/components/animal_card.dart';

class VisualizarPerfil extends StatefulWidget {
  const VisualizarPerfil({super.key, required this.title});

  final String title;

  @override
  State<VisualizarPerfil> createState() => _VisualizarPerfilState();
}

class _VisualizarPerfilState extends State<VisualizarPerfil> {
  @override
  Widget build(BuildContext context) {
    final usuario = MockUsuario.getUser();

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
                        usuario.nome,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(usuario.imagem),
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
                            backgroundColor:estilo.corperdido,
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
                  const AnimalCard(),
                  const SizedBox(height: 10),
                  const AnimalCard(
                    title: "Animal encontrado",
                    details:
                        "Gente, encontrei esse cachorrinho perto da ponte, tava virando uma lata de lixo.",
                    backgroundColor: estilo.coravistado,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.create_rounded, size: 18, color: estilo.corprimaria,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0.0),
                        child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditarPerfil(title: "Editar Perfil")),
                              );
                              setState(() {});
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
                      const Icon(Icons.logout, size: 18, color: Colors.red,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0.0),
                        child: InkWell(
                            onTap: () {
                              _deslogar();
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Login(title: 'Login - BuscaPatas')),
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

  void _deslogar() async{
    await FlutterSession().set("sessao_usuarioLogado", null);
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
          builder: (context) => CadastroPostPerdido(title: "Cadastro de Animal Perdido")),
    );
  }
}
