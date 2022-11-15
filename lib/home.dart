import 'package:buscapatas/cadastros/cadastro-post-avistado.dart';
import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-perdido-avistar.dart';
import 'package:buscapatas/listagens/lista-posts-avistados.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/publico/login.dart';
import 'package:buscapatas/cadastros/cadastro-post-perdido.dart';
import 'package:buscapatas/perfil_usuario.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/components/navbar.dart';

//OBS: Essa página é temporária e está simulando a página inicial
class Home extends StatefulWidget {
  bool autorizado;
  Home(bool usuario, {super.key, required this.title})
      : this.autorizado = usuario;

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    //Para pegar o valor da sessao
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    if (!widget.autorizado) {
      return Login(title: 'Busca Patas - Login');
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: const BuscapatasNavBar(selectedIndex: 0),
          body: Column(
            children: <Widget>[
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30.0, 50, 30.0, 10.0),
                child: Column(
                  children: <Widget>[
                    const Image(
                      image: AssetImage('imagens/mapa_holder.PNG'),
                    ),
                    SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          estilo.corsecundaria),
                                ),
                                onPressed: () {
                                  _cadastrarAnimalAvistado();
                                },
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.add)),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "Animal encontrado",
                                          style: TextStyle(
                                            color:
                                                Colors.white, /*fontSize: 20.0*/
                                          ),
                                        )),
                                  ],
                                )),
                            ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          estilo.corsecundaria),
                                ),
                                onPressed: () {
                                  _cadastrarAnimalPerdido();
                                },
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Animal perdido",
                                          style: TextStyle(
                                            color:
                                                Colors.white, /*fontSize: 20.0*/
                                          ),
                                        )),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.add))
                                  ],
                                ))
                          ],
                        ))
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide.none)),
                              onPressed: () {
                                _infoPostPerdidoAvistar();
                              },
                              child: AnimalCard()),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide.none)),
                              onPressed: () {
                                _infoPostPerdidoAvistar();
                              },
                              child: AnimalCard()),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide.none)),
                              onPressed: () {
                                _infoPostAvistado();
                              },
                              child: AnimalCard.avistado()),
                        ],
                      )))
            ],
          ));
    }
  }

  void _cadastrarAnimalPerdido() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CadastroPostPerdido(title: "Cadastrar Animal Perdido")),
    );
  }

  void _cadastrarAnimalAvistado() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CadastroPostAvistado(title: "Cadastrar Animal Avistado")),
    );
  }

  void _infoPostPerdidoAvistar() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              InfoPostPerdidoAvistar(title: "Animal Perdido")),
    );
  }

  void _infoPostAvistado() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InfoPostAvistado(title: "Animal Avistado")),
    );
  }
}
