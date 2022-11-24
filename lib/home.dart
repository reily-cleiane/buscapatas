import 'package:buscapatas/cadastros/cadastro-post-avistado.dart';
import 'package:buscapatas/cadastros/cadastro-post-perdido.dart';
import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-perdido.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/publico/login.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:buscapatas/utils/localizacao.dart' as localizacao;
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/components/navbar.dart';
import 'dart:math';

class Home extends StatefulWidget {
  bool autorizado;
  Home(bool usuario, {super.key, required this.title})
      : this.autorizado = usuario;

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PostModel> postsProximos = [];
  late GoogleMapController mapController;
  //double? valorLatitude = 45.521563;
  //double? valorLongitude = -122.677433;
  double? valorLatitude = 0;
  double? valorLongitude = 0;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    getPostsAnimaisProximos();
    //mockarUsuarioLogado();
  }

  void mockarUsuarioLogado() async {
    //MOCKAR UM USUARIO LOGADO PARA QUANDO INICIA DIRETO PELA MAIN
    UsuarioModel usuarioLogado = new UsuarioModel(
        id: 1,
        nome: "cleiane",
        email: "cleiane@gmail.com",
        senha: "abc",
        telefone: "8498778787");

    await FlutterSession().set("sessao_usuarioLogado", usuarioLogado);
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
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          bottomNavigationBar: const BuscapatasNavBar(selectedIndex: 0),
          body: SingleChildScrollView(
              child: Column(children: <Widget>[
            if (valorLatitude != 0 && valorLongitude != 0)
              Container(
                height: 300,
                child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: markers.values.toSet(),
                    initialCameraPosition: CameraPosition(
                        //bearing: 192.8334901395799,
                        target: LatLng(valorLatitude, valorLongitude),
                        //tilt: 59.440717697143555,
                        zoom: 15)),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Column(children: <Widget>[
                IntrinsicHeight(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 6,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                backgroundColor: estilo.coravistado),
                            onPressed: () {
                              _cadastrarAnimalAvistado();
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15.0),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.center,
                                        child: Icon(Icons.add,
                                            color: estilo.corpreto)),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Animal avistado",
                                          style: TextStyle(
                                              color: estilo.corpreto,
                                              fontWeight: FontWeight
                                                  .bold /*fontSize: 20.0*/
                                              ),
                                        )),
                                  ],
                                )))),
                    Expanded(
                        flex: 1,
                        child:
                            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0))),
                    Expanded(
                        flex: 6,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                backgroundColor: estilo.corperdido),
                            onPressed: () {
                              _cadastrarAnimalPerdido();
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15.0),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Animal perdido",
                                          style: TextStyle(
                                              color: estilo.corpreto,
                                              fontWeight: FontWeight
                                                  .bold /*fontSize: 20.0*/
                                              ),
                                        )),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Icon(Icons.add,
                                            color: estilo.corpreto))
                                  ],
                                )))),
                  ],
                )),
                 Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                  ),
                Column(children: <Widget>[
                  Container(
                      height: 400,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 180),
                          //shrinkWrap: true,
                          itemCount: postsProximos.length,
                          itemBuilder: (context, index) {
                            PostModel? postAtual = null;
                            if (postsProximos[index] != null) {
                              postAtual = postsProximos[index];
                            }

                            //precisa desse GestureDetector e desse card?
                            //não dava certo só colocar direto o elevatedButton?
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
                                  if (postAtual!.tipoPost == "ANIMAL_PERDIDO") {
                                    _infoPostPerdido(postAtual);
                                  } else if (postAtual.tipoPost ==
                                      "ANIMAL_AVISTADO") {
                                    _infoPostAvistado(postAtual);
                                  }
                                },
                                child: AnimalCard(post: postAtual),
                              ),
                            ));
                          })),
                ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                ),
              ]),
            )
          ])));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    for (var post in postsProximos) {
      String tipo = "";
      var funcao;
      if (post.tipoPost == "ANIMAL_PERDIDO") {
        tipo = "perdido";
        funcao = _infoPostPerdido;
      } else {
        tipo = "avistado";
        funcao = _infoPostAvistado;
      }
      final marker = Marker(
        onTap: () => funcao(post),
        markerId: MarkerId(post.id.toString()),
        position: LatLng(post.latitude, post.longitude),
        // icon: BitmapDescriptor.,
        infoWindow: InfoWindow(
          title: "",
          snippet: "${post.especieAnimal!.nome} ${tipo}",
        ),
      );

      markers[MarkerId(post.id.toString())] = marker;
    }

    setState(() {});
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

  void _infoPostPerdido(PostModel? postAtual) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfoPostPerdido(post: postAtual)),
    );
  }

  void _infoPostAvistado(PostModel? postAtual) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              InfoPostAvistado(title: "Animal Avistado", post: postAtual)),
    );
  }

  void getPostsAnimaisProximos() async {
    List<PostModel> posts = await PostModel.getPostsAnimaisProximos();
    await carregarLocalizacao();
    List<PostModel> postsProximosTemp = [];

    double distancia = 0;
    for (var post in posts) {
      distancia = localizacao.calcularDistancia(
          valorLatitude, valorLongitude, post.latitude, post.longitude);
      if (distancia < 5) {
        postsProximosTemp.add(post);
      }
    }

    setState(() {
      postsProximos = postsProximosTemp;
    });
  }

  Future<void> carregarLocalizacao() async {
    await localizacao.getLatitudeAtual().then((value) => valorLatitude = value);

    await localizacao
        .getLongitudeAtual()
        .then((value) => valorLongitude = value);

    //Necessário para recarregar a página após ter pegado o valor de usuarioLogado
    setState(() {});
  }
}
