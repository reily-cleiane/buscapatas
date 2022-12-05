import 'dart:io';

import 'package:buscapatas/components/imagem_dialogo.dart';
import 'package:buscapatas/model/NotificacaoAvistamentoModel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:buscapatas/home.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/components/campo_texto_longo.dart';
import 'package:http/http.dart' as http;
import 'package:buscapatas/components/caixa_dialogo_alerta.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/utils/localizacao.dart' as localizacao;
import 'package:buscapatas/utils/usuario_logado.dart' as usuario_sessao;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class CadastroNotificacaoAvistado extends StatefulWidget {
  const CadastroNotificacaoAvistado(
      {super.key, required this.title, required this.postId});

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

  UsuarioModel usuarioLogado = UsuarioModel();

  File? imagem;

  @override
  void initState() {
    carregarUsuarioLogado();
    super.initState();
  }

  void carregarUsuarioLogado() async {
    await usuario_sessao
        .getUsuarioLogado()
        .then((value) => usuarioLogado = value);
    //Necessário para recarregar a página após ter pegado o valor de usuarioLogado
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider fotoNotificacao;
    if ((imagem != null)) {
      fotoNotificacao = FileImage(imagem!);
    } else {
      fotoNotificacao = const NetworkImage(
          'https://buspatas.blob.core.windows.net/buscapatas/notificacao-foto-padrao.png');
    }

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
                Center(
                  child: Stack(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: Ink.image(
                            image: fotoNotificacao,
                            fit: BoxFit.cover,
                            width: 128,
                            height: 128,
                            child: InkWell(onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (_) =>
                                      ImagemDialogo(foto: fotoNotificacao));
                            }),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 0, right: 4, child: construirBotaoEdicao()),
                    ],
                  ),
                ),
                CampoTextoLongo(
                    rotulo: "Mensagem para o dono",
                    controlador: mensagemController,
                    placeholder:
                        "Informe o estado, a descrição ou algumas informações sobre o animal avistado",
                    obrigatorio: true),
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

  void _cadastrarNotificacao() {
    if (_formKey.currentState!.validate()) {
      _addNotificacao();
    }
  }

  void _addNotificacao() async {
    var url = NotificacaoAvistamentoModel.getUrlSalvarNotificacao();
    double valorLatitude = 0;
    await localizacao.getLatitudeAtual().then((value) => valorLatitude = value);

    double valorLongitude = 0;
    await localizacao
        .getLongitudeAtual()
        .then((value) => valorLongitude = value);

    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(url));

    request.fields['jsondata'] = jsonEncode(<String, dynamic>{
      if (mensagemController.text.isNotEmpty)
        "mensagem": mensagemController.text,
      "latitude": valorLatitude,
      "longitude": valorLongitude,
      "usuario": usuarioLogado,
      "post": {"id": widget.postId}
    });

    var length = 1;
    var fileType;

    if (imagem != null) {
      length = await imagem!.length();

      var stream = new http.ByteStream(imagem!.openRead());
      stream.cast();

      String? mimeStr = lookupMimeType(imagem!.path);
      fileType = mimeStr!.split('/');

      var multipart = await http.MultipartFile.fromPath('file', imagem!.path,
          contentType: new MediaType('image', fileType[0]));
      request.files.add(multipart);
    }

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return CaixaDialogoAlerta(
              titulo: "Mensagem do servidor",
              conteudo: responsed.body,
              funcao: _redirecionarPaginaAposSalvar);
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return CaixaDialogoAlerta(
              titulo: "Mensagem do servidor problema",
              conteudo: responsed.body,
              funcao: _redirecionarPaginaAposSalvar);
        },
      );
    }
  }

  void _redirecionarPaginaAposSalvar() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home(true, title: 'Busca Patas')));
  }

  Future pegarImagem(ImageSource source) async {
    final imagem = await ImagePicker.pickImage(source: source);
    if (imagem == null) return;

    final imagemTemporaria = File(imagem.path);
    setState(() => this.imagem = imagemTemporaria);
  }

  void mostrarDialogo(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Selecione uma das opções"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                pegarImagem(ImageSource.camera);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.add_a_photo,
                    size: 18,
                    color: estilo.corprimaria,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0.0),
                    child: InkWell(
                        child: Ink(
                      child: RichText(
                        text: const TextSpan(
                          text: "Tirar Foto",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                pegarImagem(ImageSource.gallery);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.add_photo_alternate,
                    size: 18,
                    color: estilo.corprimaria,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0.0),
                    child: InkWell(
                        child: Ink(
                      child: RichText(
                        text: const TextSpan(
                          text: "Selecionar da galeria",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ],
        );
      });

  Widget construirBotaoEdicao() => construirCirculo(
        color: Colors.white,
        all: 3,
        child: InkWell(
          onTap: () => {mostrarDialogo(context)},
          child: construirCirculo(
            color: estilo.corprimaria,
            all: 8,
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
      );

  Widget construirCirculo({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
