import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/components/navbar.dart';
import 'package:buscapatas/visualizacoes/info-post-perdido.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/model/PostModel.dart';

import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class ListaPostsPerdidos extends StatefulWidget {
  const ListaPostsPerdidos({super.key, required this.title});

  final String title;

  @override
  State<ListaPostsPerdidos> createState() => _ListaPostsPerdidos();
}

class _ListaPostsPerdidos extends State<ListaPostsPerdidos> {
  List<PostModel> postsPerdidos = [];
  TextEditingController buscaController = TextEditingController();

  @override
  void initState() {
    _getPostsAnimaisPerdidos();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Animais Perdidos",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: estilo.corprimaria),
      bottomNavigationBar: const BuscapatasNavBar(selectedIndex: 1),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10, 30.0, 10.0),
          child: Column(children: <Widget>[
            campoInput("Busca", buscaController, TextInputType.name,
                "Informe sua Busca"),
            Expanded(
              child: ListView.builder(
                  itemCount: postsPerdidos.length,
                  itemBuilder: (context, index) {
                    PostModel? postAtual = null ;
                    if(postsPerdidos[index]!=null){
                      postAtual = postsPerdidos[index];                         
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
                          _infoPostPerdido(postAtual);
                        },

                        child: AnimalCard(post:postAtual

                  ),
                      ),
                    ));
                  }),
            ),
          ])),
    );
  }

  void _infoPostPerdido(PostModel? postAtual) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InfoPostPerdido(title: "Animal Avistado", post:postAtual)),
    );
  }

  void _getPostsAnimaisPerdidos() async {
    List<PostModel> posts = await PostModel.getPostsAnimaisPerdidos();
    setState(() {
      postsPerdidos = posts;

    });
  }

  Widget campoInput(String label, TextEditingController controller,
      TextInputType tipoCampo, String placeholder) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
        child: TextFormField(
          keyboardType: tipoCampo,
          decoration: InputDecoration(
            labelText: label,
            labelStyle:
                const TextStyle(fontSize: 21, color: estilo.corprimaria),
            hintText: placeholder,
            hintStyle: const TextStyle(
                fontSize: 14.0, color: Color.fromARGB(255, 187, 179, 179)),
            border: const OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          controller: controller,
        ));
  }
}
