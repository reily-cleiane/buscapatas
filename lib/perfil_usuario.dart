import 'package:buscapatas/cadastros/cadastro-post-avistado.dart';
import 'package:buscapatas/cadastros/cadastro-post.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BuscapatasNavBar(selectedIndex: 2),
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
                    const Expanded(
                      flex: 7,
                      child: Text(
                        "Luan Gustavo Cláudio dos Santos",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditarPerfil(title: "Editar Perfil")),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('imagens/homem.jpg'),
                          ),
                        ),
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
                            backgroundColor: const Color(0xFFE0FFD6),
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
                            backgroundColor: const Color(0xFFFFA7A7),
                            side: const BorderSide(
                              color: Color(0xFFBF7D7D),
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
                    backgroundColor: Color(0xFFD7FFE2),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Sair da conta",
                        style: TextStyle(color: Colors.red),
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

  void _cadastroPostAnimalAvistado() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CadastroPostAvistado(title: "Cadastro Animal Avistado")),
    );
  }

  void _cadastroPostAnimalPerdido() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CadastroPost(title: "Cadastro Animal perdido")),
    );
  }
}
