import 'package:buscapatas/model/EspecieModel.dart';
import 'package:buscapatas/model/NotificacaoAvistamentoModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'dart:convert';
import 'package:buscapatas/home.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/model/RacaModel.dart';
import 'package:buscapatas/model/CorModel.dart';
import 'package:http/http.dart' as http;
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:geolocator/geolocator.dart';

class CadastroNotificacaoAvistado extends StatefulWidget {
  const CadastroNotificacaoAvistado({super.key, required this.title, required this.postId});

  final String title;
  final int postId;

  @override
  State<CadastroNotificacaoAvistado> createState() =>
      _CadastroNotificacaoAvistadoState();
}

class _CadastroNotificacaoAvistadoState
    extends State<CadastroNotificacaoAvistado> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mensagemController = TextEditingController();

  double? valorLatitude;
  double? valorLongitude;

  UsuarioModel usuarioLogado = UsuarioModel();

  @override
  void initState() {
    getUsuarioLogado();
    getPosicao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Cadastro de Notificação",
            style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: estilo.corprimaria,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.0, 50, 30.0, 20.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                campoInputLongo(
                    "Mensagem para o dono",
                    mensagemController,
                    TextInputType.multiline,
                    "Informe o estado, a descrição ou algumas informações sobre o animal avistado:"),
                const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10)),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(estilo.corprimaria),
                      ),
                      onPressed: () {
                        _cadastrarNotificacao();
                      },
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    )),
                const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
              ],
            )),
      ),
    );
  }

  void getUsuarioLogado() async {
    UsuarioModel usuario;
    usuario = UsuarioModel.fromJson(
        await (FlutterSession().get("sessao_usuarioLogado")));
    setState(() {
      usuarioLogado = usuario;
    });
  }

  void _cadastrarNotificacao() {    
    if (_formKey.currentState!.validate()){
      _addNotificacao();
    } 
  }

  void _addNotificacao() async {
    var url = NotificacaoAvistamentoModel.getUrlSalvarNotificacao();

    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          if (mensagemController.text.isNotEmpty)
            "mensagem": mensagemController.text,
          "latitude": valorLatitude,
          "longitude": valorLongitude,
          "usuario": usuarioLogado,
          "post": {"id": widget.postId}
        }));

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
              titulo: "Mensagem do servidor", conteudo: response.body);
        },
      );
    }
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

  Widget campoInputLongo(String label, TextEditingController controller,
      TextInputType tipoCampo, String placeholder) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 10.0),
        child: TextFormField(
          keyboardType: tipoCampo,
          validator: (value) {
            if (controller.text.isEmpty) {
              return "O campo deve ser preenchido";
            }
          },
          decoration: InputDecoration(
              labelText: label,
              labelStyle:
                  const TextStyle(fontSize: 21, color: estilo.corprimaria),
              border: const OutlineInputBorder(),
              hintText: placeholder,
              hintStyle: const TextStyle(
                  fontSize: 14.0, color: Color.fromARGB(255, 187, 179, 179)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              floatingLabelStyle:
                  const TextStyle(color: estilo.corprimaria, fontSize: 16)),
          controller: controller,
          maxLines: 4,
        ));
  }
}

class MyAlertDialog extends StatelessWidget {
  final String titulo;
  final String conteudo;

  MyAlertDialog({
    this.titulo = '',
    this.conteudo = '',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.titulo,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: <Widget>[
        ElevatedButton(
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(estilo.corprimaria),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(true, title: 'Busca Patas')));

              //Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 10.0),
            ))
      ],
      content: Text(
        conteudo,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
