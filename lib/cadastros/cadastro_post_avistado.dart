import 'package:buscapatas/components/campo_select.dart';
import 'package:buscapatas/model/EspecieModel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:buscapatas/home.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:buscapatas/model/RacaModel.dart';
import 'package:buscapatas/model/CorModel.dart';
import 'package:buscapatas/components/caixa_dialogo_alerta.dart';
import 'package:buscapatas/components/campo_texto_longo.dart';
import 'package:http/http.dart' as http;
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/utils/localizacao.dart' as localizacao;
import 'package:buscapatas/utils/usuario_logado.dart' as usuario_sessao;

class CadastroPostAvistado extends StatefulWidget {
  const CadastroPostAvistado({super.key, required this.title});

  final String title;

  @override
  State<CadastroPostAvistado> createState() => _CadastroPostAvistadoState();
}

class _CadastroPostAvistadoState extends State<CadastroPostAvistado> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController outrasinformacoesController = TextEditingController();

  bool valorColeiraMarcado = false;
  bool valorLarTemporario = false;
  String valorSexoMarcado = "";
  String? valorEspecieSelecionado;
  String? valorRacaSelecionado;
  String _mensagemValidacao = "";

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
    //Necessário para recarregar a página após ter pegado o valor de usuarioLogado
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cadastro de Animal Avistado"),
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
                CampoSelect(rotulo: "Espécie", valorSelecionado: valorEspecieSelecionado, funcaoOnChange: selecionarEspecie, listaItens: listaEspecies, obrigatorio: true),
                if(listaRacas.isNotEmpty)
                CampoSelect(rotulo: "Raça", valorSelecionado: valorRacaSelecionado, funcaoOnChange: selecionarRaca, listaItens: listaRacas),
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
                  title: const Text("Fêmea",
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
                Text("Estava de coleira?",
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
                  title: const Text("Não",
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
                const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10.0)),
                Text("Deu lar temporário?",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Sim",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: true,
                  groupValue: valorLarTemporario,
                  onChanged: (value) {
                    setState(() {
                      valorLarTemporario = value!;
                    });
                  },
                ),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Não",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: false,
                  groupValue: valorLarTemporario,
                  onChanged: (value) {
                    setState(() {
                      valorLarTemporario = value!;
                    });
                  },
                ),
                CampoTextoLongo(
                  rotulo: "Outras informações",
                  controlador: outrasinformacoesController,
                  placeholder:
                      "Outras características para ajudar na identificação do animal",
                ),
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
    // Colocar a validação depois
    if (_formKey.currentState!.validate() &&
        valorEspecieSelecionado != null &&
        listaCoresSelecionadas.isNotEmpty) {
      _salvarPost();
    } else {
      _mensagemValidacao = "";
      if (valorEspecieSelecionado == null) {
        setState(() {
          _mensagemValidacao += "O campo Espécie deve ser preenchido. ";
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

    post.coleira = valorColeiraMarcado;
    post.coresAnimal = cores;
    post.especieAnimal = EspecieModel(id:int.parse(valorEspecieSelecionado!));
    if(valorRacaSelecionado!=null) post.racaAnimal = RacaModel(id:int.parse(valorRacaSelecionado!));
    post.latitude = valorLatitude;
    post.longitude = valorLongitude;
    if(outrasinformacoesController.text.isNotEmpty) post.outrasInformacoes = outrasinformacoesController.text;
    post.larTemporario = valorLarTemporario;
    if(valorSexoMarcado.isNotEmpty) post.sexoAnimal = valorSexoMarcado;
    post.tipoPost = "ANIMAL_AVISTADO";
    post.usuario = usuarioLogado;

    var response = await post.salvar();

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

}
