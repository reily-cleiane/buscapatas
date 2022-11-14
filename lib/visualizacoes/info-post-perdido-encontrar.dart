import 'package:buscapatas/perfil_usuario.dart';
import 'package:buscapatas/publico/cadastro-usuario.dart';
import 'package:buscapatas/publico/esqueceu-senha.dart';
import 'package:buscapatas/visualizacoes/contato.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class InfoPostPerdidoEncontrar extends StatefulWidget {
  const InfoPostPerdidoEncontrar({super.key, required this.title});

  final String title;

  @override
  State<InfoPostPerdidoEncontrar> createState() => _InfoPostPerdidoEncontrarState();
}

class _InfoPostPerdidoEncontrarState extends State<InfoPostPerdidoEncontrar> {
  @override
  void initState() {
    //Para pegar o valor da sessao
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text("Animal Perdido"),
            centerTitle: true,
            backgroundColor: estilo.corprimaria),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30.0, 30, 30.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: CircleAvatar(
                  radius: 250,
                  backgroundImage: AssetImage('imagens/animal.jpg'),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 400.0, 0, 10.0),
                    child: Center(
                      child: Text("Zeus",
                        style: TextStyle(
                          color: Colors.black, fontSize: 30, decorationThickness: 5.0),
                      )
                      ),
                    ),
                  ),
                ),
              Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5.0),
                        child: Text("Espécie: Cachorro",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5.0),
                        child: Text("Sexo: Macho",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5.0),
                        child: Text("Cor do pelo: Branco",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5.0),
                        child: Text("Descrição: Gente por favor me ajudem! Meu cachorro viu o portão de casa aberto e fugiu",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5.0),
                        child: Text("Orientações gerais: branco",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5.0),
                        child: Text("Estava de coleira?: Sim",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 10.0),
                        child: Text("Recompensa: RS 120,00",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20))),
                  ])),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(estilo.corprimaria),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ))
                  ),
                  onPressed: () {
                    //Remova o card dos registrados
                  }, 
                  child: const Text("Animal encontrado", 
                    style: TextStyle(
                      color: Colors.white
                    )
                  ),
                )
              )
            ],
          ),
        ));
  }
}