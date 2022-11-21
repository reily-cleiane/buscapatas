import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/components/navbar.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class ListaPostsAvistados extends StatefulWidget {
  const ListaPostsAvistados({super.key, required this.title});

  final String title;

  @override
  State<ListaPostsAvistados> createState() => _ListaPostsAvistados();
}

class _ListaPostsAvistados extends State<ListaPostsAvistados> {

  TextEditingController buscaController = TextEditingController();
  List<PostModel> postsAvistados = [];

  @override
  void initState() {
    getPostsAnimaisAvistados();

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Animais Avistados",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: estilo.corprimaria),
      bottomNavigationBar: const BuscapatasNavBar(selectedIndex: 2),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10, 30.0, 10.0),
          child: Column(children: <Widget>[
            campoInput("Busca", buscaController, TextInputType.name,
                "Informe sua Busca"),
            Expanded(
              child: ListView.builder(
                  itemCount: postsAvistados.length,
                  itemBuilder: (context, index) {
                    PostModel? postAtual = null ;
                    if(postsAvistados[index]!=null){
                      postAtual = postsAvistados[index];                         
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
                          _infoPostAvistado(postAtual);
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

  void getPostsAnimaisAvistados() async {
    List<PostModel> posts = await PostModel.getPostsAnimaisAvistados();
    setState(() {
      postsAvistados = posts;

    });
  }
  
  void _infoPostAvistado(PostModel? postAtual) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InfoPostAvistado(title: "Animal Avistado", post:postAtual)),
    );
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
