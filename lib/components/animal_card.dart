import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/model/PostModel.dart';
import 'package:buscapatas/utils/localizacao.dart' as localizacao;

class AnimalCard extends StatefulWidget {
  AnimalCard({super.key, post}) {
    super.key;
    if (post?.tipoPost == "ANIMAL_PERDIDO") {
      tipoPost = "perdido";
      backgroundColor = estilo.corperdido;
    } else if (post?.tipoPost == "ANIMAL_AVISTADO") {
      tipoPost = "avistado";
      backgroundColor = estilo.coravistado;
    }
    especie = post?.especieAnimal?.getNome();
    dataHora = post?.dataHora;
    dataHora = dataHora!.subtract(const Duration(hours: 3));
    latitude = post?.latitude;
    longitude = post?.longitude;
    outrasInformacoes = post?.outrasInformacoes;
    orientacoesGerais = post?.orientacoesGerais;

    image = 'imagens/animal.jpg';
  }

  AnimalCard.notificacao({super.key, notificacao}) {
    super.key;
    tipoPost = "visto";
    backgroundColor = estilo.coravistado;

    especie =
        "Seu ${notificacao.post.getEspecie().getNome().toLowerCase()} foi";
    dataHora = notificacao?.dataHora;
    dataHora = dataHora!.subtract(const Duration(hours: 3));
    latitude = notificacao?.latitude;
    longitude = notificacao?.longitude;
    outrasInformacoes = notificacao?.mensagem;

    image = 'imagens/animal.jpg';
  }

  String? especie;
  DateTime? dataHora;
  String? tipoPost;
  double? latitude;
  double? longitude;
  String? timestamp;
  PostModel? post;
  String outrasInformacoes = "";
  String orientacoesGerais = "";
  String? image;
  Color? backgroundColor;

  @override
  AnimalCardState createState() => AnimalCardState();
}

class AnimalCardState extends State<AnimalCard> {
  double distancia = 0;
  String dataHoraExibida = "";
  String informacoes = "";
  String postadoHa = "";

  @override
  void initState() {
    carregarDistancia();
    informacoes = getInformacoesResumidas(
        widget.outrasInformacoes, widget.orientacoesGerais);
    postadoHa = getTempoDecorrido(widget.dataHora);

    dataHoraExibida =
        "${widget.dataHora!.day.toString().padLeft(2, '0')}/${widget.dataHora!.month.toString().padLeft(2, '0')}/${widget.dataHora!.year.toString()} às ${widget.dataHora!.hour.toString()}:${widget.dataHora!.minute.toString()}";

    super.initState();
  }

  void carregarDistancia() async {
    await localizacao
        .calcularDistanciaPosicaoAtual(widget.latitude, widget.longitude)
        .then((value) => distancia = value);
    //Necessário para recarregar a página após ter pegado o valor de distancia
    if (this.mounted) {
      setState(() {});
    }
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
                            "${postadoHa}\n${dataHoraExibida}",
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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: estilo.corpreto),
                      ),
                      Text(informacoes,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "A ${distancia} km de você",
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.location_on, color: estilo.corcinza)
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

  String getTempoDecorrido(DateTime? dataHora) {
    Duration? diferencaTempo;
    String texto = "Postado há";

    diferencaTempo = DateTime.now().difference(dataHora!);
    if (diferencaTempo.inDays >= 1 && diferencaTempo.inDays <= 30) {
      if (diferencaTempo.inDays == 1) {
        texto = "${texto} ${diferencaTempo.inDays} dia.";
      } else {
        texto = "${texto} ${diferencaTempo.inDays} dias.";
      }
    } else if (diferencaTempo.inDays < 1) {
      if (diferencaTempo.inHours == 1) {
        texto = "${texto} ${diferencaTempo.inHours} hora.";
      } else {
        texto = "${texto} ${diferencaTempo.inHours} horas.";
      }
    } else {
      int meses = diferencaTempo.inDays % 30;
      texto = "${texto} ${meses} meses.";
    }
    return texto;
  }
}
