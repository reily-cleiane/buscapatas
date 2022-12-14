import 'dart:io';

import 'package:buscapatas/components/campo_select.dart';
import 'package:buscapatas/components/imagem_dialogo.dart';
import 'package:buscapatas/model/EspecieModel.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/home.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:buscapatas/model/RacaModel.dart';
import 'package:buscapatas/model/CorModel.dart';
import 'package:buscapatas/components/caixa_dialogo_alerta.dart';
import 'package:buscapatas/components/campo_texto_longo.dart';
import 'package:buscapatas/components/campo_texto_curto.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/utils/localizacao.dart' as localizacao;
import 'package:buscapatas/utils/usuario_logado.dart' as usuario_sessao;
import 'package:image_picker/image_picker.dart';

class CadastroPostPerdido extends StatefulWidget {
  const CadastroPostPerdido({super.key, required this.title});

  final String title;

  @override
  State<CadastroPostPerdido> createState() => _CadastroPostPerdidoState();
}

class _CadastroPostPerdidoState extends State<CadastroPostPerdido> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController outrasinformacoesController = TextEditingController();
  TextEditingController orientacoesController = TextEditingController();
  TextEditingController recompensaController = TextEditingController();
  String _mensagemValidacao = "";

  File? imagem;

  bool valorColeiraMarcado = false;
  String valorSexoMarcado = "";
  String? valorEspecieSelecionado;
  String? valorRacaSelecionado;

  List<dynamic> listaEspecies = [];
  List<dynamic> listaRacas = [];

  Map<String, bool> mapaCoresNomeBool = {};
  Map<String, int> mapaCoresNomeId = {};
  List<int> listaCoresSelecionadas = [];
  UsuarioModel usuarioLogado = UsuarioModel();

  @override
  void initState() {
    cargaInicialBD();
    carregarUsuarioLogado();
    super.initState();
  }

  void carregarUsuarioLogado() async {
    await usuario_sessao
        .getUsuarioLogado()
        .then((value) => usuarioLogado = value);
    //Necess??rio para recarregar a p??gina ap??s ter pegado o valor de usuarioLogado
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider fotoNotificacao;
    if ((imagem != null)) {
      fotoNotificacao = FileImage(imagem!);
    } else {
      fotoNotificacao = const NetworkImage(
          'https://buspatas.blob.core.windows.net/buscapatas/post-foto-padrao.png');
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text("Cadastro de Animal Perdido"),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: estilo.corprimaria),
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
                CampoTextoCurto(
                    rotulo: "Nome do pet",
                    controlador: nomeController,
                    tipoCampo: TextInputType.name,
                    rotuloSuperior: true,
                    placeholder: "Nome/apelido"),
                CampoSelect(
                    rotulo: "Esp??cie",
                    valorSelecionado: valorEspecieSelecionado,
                    funcaoOnChange: selecionarEspecie,
                    listaItens: listaEspecies,
                    obrigatorio: true),
                if (listaRacas.isNotEmpty)
                  CampoSelect(
                      rotulo: "Ra??a",
                      valorSelecionado: valorRacaSelecionado,
                      funcaoOnChange: selecionarRaca,
                      listaItens: listaRacas),
                const Text("Sexo:",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Macho",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: "M",
                  groupValue: valorSexoMarcado,
                  onChanged: (value) {
                    setState(() {
                      valorSexoMarcado = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("F??mea",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: "F",
                  groupValue: valorSexoMarcado,
                  onChanged: (value) {
                    setState(() {
                      valorSexoMarcado = value.toString();
                    });
                  },
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 1.0)),
                const Text("Cor:",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ListView(
                    shrinkWrap: true,
                    children: mapaCoresNomeBool.keys.map((String key) {
                      return CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: new Text(key,
                            style: TextStyle(
                                color: estilo.corprimaria, fontSize: 16)),
                        value: mapaCoresNomeBool[key],
                        onChanged: (bool? value) {
                          setState(() {
                            mapaCoresNomeBool[key] = value!;
                            if (mapaCoresNomeBool[key] == true) {
                              listaCoresSelecionadas.add(mapaCoresNomeId[key]!);
                            } else {
                              listaCoresSelecionadas
                                  .remove(mapaCoresNomeId[key]);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10.0)),
                Text("Estava de coleira:",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Sim",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: true,
                  groupValue: valorColeiraMarcado,
                  onChanged: (value) {
                    setState(() {
                      valorColeiraMarcado = value!;
                    });
                  },
                ),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("N??o",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: false,
                  groupValue: valorColeiraMarcado,
                  onChanged: (value) {
                    setState(() {
                      valorColeiraMarcado = value!;
                    });
                  },
                ),
                CampoTextoLongo(
                  rotulo: "Outras informa????es",
                  controlador: outrasinformacoesController,
                  placeholder:
                      "Outras caracter??sticas para ajudar na identifica????o do animal",
                ),
                CampoTextoLongo(
                  rotulo: "Orienta????es gerais",
                  controlador: orientacoesController,
                  placeholder:
                      "Temperamento do animal e outras instru????es importantes",
                ),
                CampoTextoCurto(
                    rotulo: "Recompensa",
                    controlador: recompensaController,
                    tipoCampo: TextInputType.number,
                    rotuloSuperior: true,
                    placeholder: "R\$ 0"),
                const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                Text(
                  _mensagemValidacao,
                  style: TextStyle(color: Color(0xFFe53935)),
                ),
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
                        _cadastrarPost();
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

  void cargaInicialBD() async {
    List<dynamic> especiesTemp = await EspecieModel.getEspecies();
    Map<String, int> coresNomeIdTemp = await CorModel.getCores();
    Map<String, bool> coresTempNomeBool = {};

    for (var cor in coresNomeIdTemp.entries) {
      coresTempNomeBool[cor.key] = false;
    }
    setState(() {
      listaEspecies = especiesTemp;
      mapaCoresNomeId = coresNomeIdTemp;
      mapaCoresNomeBool = coresTempNomeBool;
    });
  }

  void getRacas() async {
    setState(() {
      valorRacaSelecionado = null;
    });

    List<dynamic> racasTemp =
        await RacaModel.getRacasByEspecie(valorEspecieSelecionado);

    setState(() {
      listaRacas.clear();
      listaRacas = racasTemp;
    });
  }

  void _cadastrarPost() {
    // Colocar a valida????o depois
    if (_formKey.currentState!.validate() &&
        valorEspecieSelecionado != null &&
        listaCoresSelecionadas.isNotEmpty) {
      _salvarPost();
    } else {
      _mensagemValidacao = "";
      if (valorEspecieSelecionado == null) {
        setState(() {
          _mensagemValidacao += "O campo Esp??cie deve ser preenchido. ";
        });
      }
      if (listaCoresSelecionadas.isEmpty) {
        setState(() {
          _mensagemValidacao += "\nO campo Cor deve ser preenchido. ";
        });
      }
    }
  }

  void _salvarPost() async {
    PostModel post = PostModel();

    double valorLatitude = 0;
    await localizacao.getLatitudeAtual().then((value) => valorLatitude = value);
    double valorLongitude = 0;
    await localizacao
        .getLongitudeAtual()
        .then((value) => valorLongitude = value);

    List<CorModel> cores = [];

    for (int corId in listaCoresSelecionadas) {
      CorModel corSelecionada = CorModel.id(corId);
      cores.add(corSelecionada);
    }

    if (nomeController.text.isNotEmpty) post.nomeAnimal = nomeController.text;
    post.coleira = valorColeiraMarcado;
    post.coresAnimal = cores;
    post.especieAnimal = EspecieModel(id: int.parse(valorEspecieSelecionado!));
    if (valorRacaSelecionado != null)
      post.racaAnimal = RacaModel(id: int.parse(valorRacaSelecionado!));
    post.latitude = valorLatitude;
    post.longitude = valorLongitude;
    if (orientacoesController.text.isNotEmpty)
      post.orientacoesGerais = orientacoesController.text;
    if (outrasinformacoesController.text.isNotEmpty)
      post.outrasInformacoes = outrasinformacoesController.text;
    if (recompensaController.text.isNotEmpty)
      post.recompensa = int.parse(recompensaController.text);
    if (valorSexoMarcado.isNotEmpty) post.sexoAnimal = valorSexoMarcado;
    post.tipoPost = "ANIMAL_PERDIDO";
    post.usuario = usuarioLogado;

    var response = await post.salvar(imagem);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return CaixaDialogoAlerta(
            titulo: "Mensagem do servidor",
            conteudo: response.body,
            funcao: _redirecionarPaginaAposSalvar);
      },
    );
  }

  void _redirecionarPaginaAposSalvar() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home(true, title: 'Busca Patas')));
  }

  void selecionarRaca(String racaSelecionada) {
    setState(() {
      valorRacaSelecionado = racaSelecionada;
    });
  }

  void selecionarEspecie(String especieSelecionada) {
    setState(() {
      valorEspecieSelecionado = especieSelecionada;
      valorRacaSelecionado = null;
    });
    getRacas();
  }

  Future pegarImagem(ImageSource source) async {
    final imagem = await ImagePicker.pickImage(source: source, maxHeight: 350, maxWidth: 400);
    if (imagem == null) return;

    final imagemTemporaria = File(imagem.path);
    setState(() => this.imagem = imagemTemporaria);
  }

  void mostrarDialogo(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Selecione uma das op????es"),
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
