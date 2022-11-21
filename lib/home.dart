import 'package:buscapatas/cadastros/cadastro-post-avistado.dart';
import 'package:buscapatas/cadastros/cadastro-post-perdido.dart';
import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-perdido.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/publico/login.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/components/navbar.dart';

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
  double? valorLatitude = 45.521563;
  double? valorLongitude = -122.677433;
  LatLng _center = LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    getPosicao();
    _center = LatLng(valorLatitude, valorLongitude);
    getPostsAnimaisProximos();
    mockarUsuarioLogado();

  }

  void mockarUsuarioLogado() async{
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
              padding: EdgeInsets.fromLTRB(30.0, 10, 30.0, 20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10.0),
                  ),
                  Container(
                    height: 300,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 11.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10.0),
                  ),
                  SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            estilo.coravistado),
                                  ),
                                  onPressed: () {
                                    _cadastrarAnimalAvistado();
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.centerLeft,
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
                                  ))),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 1, 0, 1))),
                          Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            estilo.corperdido),
                                  ),
                                  onPressed: () {
                                    _cadastrarAnimalPerdido();
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                  ))),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10.0, 10, 10.0),
                  ),
                  Container(
                    height: 500,
                    child: ListView.builder(
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
                                if(postAtual!.tipoPost== "ANIMAL_PERDIDO"){
                                  _infoPostPerdido(postAtual);

                                }else if(postAtual.tipoPost== "ANIMAL_AVISTADO"){
                                  _infoPostAvistado(postAtual);

                                }
                               
                              },
                              child: AnimalCard(post: postAtual),
                            ),
                          ));
                        }),
                  )
                ],
              )));
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

  void _infoPostPerdido(PostModel? postAtual) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InfoPostPerdido(post:postAtual)),
    );
  }

  void _infoPostAvistado(PostModel? postAtual) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InfoPostAvistado(title: "Animal Avistado", post:postAtual)),
    );
  }

  void getPostsAnimaisProximos() async {
    List<PostModel> posts = await PostModel.getPostsAnimaisProximos();
    setState(() {
      postsProximos = posts;
    });
  }

  void getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      valorLatitude = posicao.latitude;
      valorLongitude = posicao.longitude;
    } catch (e) {
      e.toString();
    }
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;

    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error('Por favor, habilite a localização no smartphone');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Você precisa autorizar o acesso à localização');
    }

    return await Geolocator.getCurrentPosition();
  }
}
