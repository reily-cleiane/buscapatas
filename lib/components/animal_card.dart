import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/Model/PostModel.dart';

class AnimalCard extends StatefulWidget {
  AnimalCard({title, details, timestamp, distance, backgroundColor, image}) {
    super.key;
    this.title = "Cachorrinho desaparecido";
    this.details =
        "Gente por favor me ajudem! Meu cachorrinho viu o portão de casa aberto e fugiu";
    this.timestamp = "Postado há 3h";
    this.distance = 10;
    this.backgroundColor = estilo.corperdido;
    this.image = 'imagens/animal.jpg';
  }

  AnimalCard.antigoAvistado(
      {title, details, timestamp, distance, backgroundColor, image}) {
    super.key;
    this.title = "Cachorrinho desaparecido";
    this.details =
        "Gente por favor me ajudem! Meu cachorrinho viu o portão de casa aberto e fugiu";
    this.timestamp = "Postado há 3h";
    this.distance = 10;
    this.backgroundColor = estilo.coravistado;
    this.image = 'imagens/animal.jpg';
  }

  AnimalCard.novo(tipoPost, cor, {post}){
    super.key;
    if(post?.tipoPost == "ANIMAL_PERDIDO"){
      this.tipoPost = "perdido";
      this.backgroundColor = estilo.corperdido;
    }else if(post?.tipoPost == "ANIMAL_AVISTADO"){
      this.tipoPost = "avistado";
      this.backgroundColor = estilo.coravistado;
    }

    this.especie = post?.especieAnimal?.getNome();
    this.dataHora = post?.dataHora;
    this.latitude = post?.latitude;
    this.longitude = post?.longitude;
    this.outrasInformacoes = post?.outrasInformacoes;
    this.orientacoesGerais = post?.orientacoesGerais;

    this.image = 'imagens/animal.jpg';

  }

  AnimalCard.perdido({post}) : this.novo("perdido", estilo.corperdido, post:post);
  AnimalCard.avistado({post}) : this.novo("avistado", estilo.coravistado, post:post);
    
  String? title;
  String? especie;
  DateTime? dataHora;
  String? tipoPost;
  String? details;
  double? latitude;
  double? longitude;
  String? timestamp;
  PostModel? post;
  String outrasInformacoes = "";
  String orientacoesGerais = "";

  String? image;
  int? distance;
  Color? backgroundColor;

  @override
  AnimalCardState createState() => AnimalCardState();
}

class AnimalCardState extends State<AnimalCard> {
  double valorLatitudeAtual = 0;
  double valorLongitudeAtual = 0;
  double distancia = 0;
  String dataHoraExibida = "";
  String informacoes = "";
  String postadoHa = "";

  @override
  void initState() {
    getPosicao();
    informacoes = getInformacoesResumidas(widget.outrasInformacoes, widget.orientacoesGerais);
    postadoHa = getDistanciaTemporal(widget.dataHora);
    dataHoraExibida =
          "${widget.dataHora!.day.toString().padLeft(2, '0')}/${widget.dataHora!.month.toString().padLeft(2, '0')}/${widget.dataHora!.year.toString()} às ${widget.dataHora!.hour.toString()}:${widget.dataHora!.minute.toString()}";
    
    setState(() {
      distancia = calcularDistancia(widget.latitude, widget.longitude,
          valorLatitudeAtual, valorLongitudeAtual);
      distancia = double.parse(distancia.toStringAsFixed(2));
      });
      
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(widget.image!),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${postadoHa!}\n${dataHoraExibida}",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                color: estilo.corpreto),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${widget.especie!} ${widget.tipoPost!}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(informacoes!),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "A ${distancia} km de você",
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.location_on, color: estilo.corpreto)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String getInformacoesResumidas(
      String? outrasInformacoes, String? orientacoesGerais) {
        String informacoes = "";
    if (outrasInformacoes != null && outrasInformacoes.isNotEmpty) {
      if (outrasInformacoes.length > 100) {
        informacoes = outrasInformacoes.substring(0, 100);
      } else {
        informacoes = outrasInformacoes;
      }
    } else if (orientacoesGerais != null && orientacoesGerais.isNotEmpty) {
      if (orientacoesGerais.length > 100) {
        informacoes = orientacoesGerais.substring(0, 100);
      } else {
        informacoes = orientacoesGerais;
      }
    }
    return informacoes;
  }

  String getDistanciaTemporal(DateTime? dataHora){
    Duration? diferencaTempo;
    String texto = "Postado há ";

    diferencaTempo = DateTime.now().difference(dataHora!);
    if (diferencaTempo!.inDays >= 1 && diferencaTempo!.inDays <= 30) {
      texto = "${texto} ${diferencaTempo!.inDays} dias.";
    } else if (diferencaTempo!.inDays < 1) {
      texto = "${texto} ${diferencaTempo!.inHours} horas.";
    } else {
      int meses = diferencaTempo!.inDays % 30;
      texto = "${texto} ${meses} meses.";
    }
    return texto;

  }

  void getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      valorLatitudeAtual = posicao.latitude;
      valorLongitudeAtual = posicao.longitude;
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

  double calcularDistancia(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
