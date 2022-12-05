import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/components/navbar.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/components/modal_busca.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class ListaPostsAvistados extends StatefulWidget {
  ListaPostsAvistados(
      {super.key, required this.title, this.listaPostsFiltrada});

  final String title;
  List<PostModel>? listaPostsFiltrada;

  @override
  State<ListaPostsAvistados> createState() => _ListaPostsAvistados();
}

class _ListaPostsAvistados extends State<ListaPostsAvistados> {
  TextEditingController buscaController = TextEditingController();
  List<PostModel> postsAvistados = [];
  List<PostModel> postsAvistadosSemFiltro = [];

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
            Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10.0)),
            Container(
                height: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 8,
                        child: TextFormField(
                          controller: buscaController,
                          decoration: InputDecoration(
                              labelText: "Buscar",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  color: estilo.corprimaria,
                                  onPressed: () {
                                    _buscarTermo();
                                  })),
                        )),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                            icon: const Icon(Icons.filter_alt),
                            color: estilo.corprimaria,
                            onPressed: () {
                              showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ModalBusca(
                                        listaPosts: postsAvistadosSemFiltro);
                                  });
                            })),
                  ],
                )),
            if (widget.listaPostsFiltrada != null)
              Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 5)),
            if (widget.listaPostsFiltrada != null)
              Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          postsAvistados = postsAvistadosSemFiltro;
                          widget.listaPostsFiltrada = null;
                        });
                      },
                      child: Ink(
                        child: RichText(
                          text: const TextSpan(
                            text: "Limpar filtros",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: estilo.corprimaria,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ))),
            Padding(padding: const EdgeInsets.fromLTRB(0, 15, 0, 15)),
            Expanded(
              child: ListView.builder(
                  itemCount: postsAvistados.length,
                  itemBuilder: (context, index) {
                    PostModel? postAtual = null;
                    if (postsAvistados[index] != null) {
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
                        child: AnimalCard(post: postAtual),
                      ),
                    ));
                  }),
            ),
          ])),
    );
  }

  void _buscarTermo() {
    List<PostModel> listaTemp = [];
    for (var post in postsAvistados) {
      if (buscaController.text.isNotEmpty) {
        bool achouTermo = false;
        if ((post.outrasInformacoes == null ||
                post.outrasInformacoes!.isEmpty) &&
            (post.orientacoesGerais == null ||
                post.orientacoesGerais!.isEmpty)) {
          continue;
        }
        if (post.outrasInformacoes != null &&
            post.outrasInformacoes!.isNotEmpty) {
          if (post.outrasInformacoes!.contains(buscaController.text)) {
            achouTermo = true;
          }
        }
        if (post.orientacoesGerais != null &&
            post.orientacoesGerais!.isNotEmpty &&
            !achouTermo) {
          if (post.orientacoesGerais!.contains(buscaController.text)) {
            achouTermo = true;
          }
        }
        if (!achouTermo) {
          continue;
        }
      }
      listaTemp.add(post);
    }
    setState(() {
      postsAvistados = listaTemp;
      widget.listaPostsFiltrada = listaTemp;
    });
  }
  
  void getPostsAnimaisAvistados() async {
    List<PostModel> posts = await PostModel.getPostsAnimaisAvistados();
    setState(() {
      if (widget.listaPostsFiltrada != null) {
        postsAvistados = widget.listaPostsFiltrada!;
      } else {
        postsAvistados = posts;
      }
      postsAvistadosSemFiltro = posts;
    });
  }

  void _infoPostAvistado(PostModel? postAtual) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              InfoPostAvistado(title: "Animal Avistado", post: postAtual)),
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
