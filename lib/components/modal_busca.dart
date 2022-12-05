import 'package:buscapatas/components/campo_select.dart';
import 'package:buscapatas/components/campo_texto_curto.dart';
import 'package:buscapatas/components/campo_texto_longo.dart';
import 'package:buscapatas/listagens/lista-posts-perdidos.dart';
import 'package:buscapatas/model/EspecieModel.dart';
import 'package:buscapatas/model/PostModel.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

import '../model/CorModel.dart';
import '../model/RacaModel.dart';
import '../model/UsuarioModel.dart';

class ModalBusca extends StatefulWidget {
  List<PostModel> listaPosts = [];
  ModalBusca({
    Key? key,
    required this.listaPosts,
  }) : super(key: key);

  @override
  _ModalBuscaState createState() => _ModalBuscaState();
}

class _ModalBuscaState extends State<ModalBusca> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController outrasinformacoesController = TextEditingController();

  String valorColeiraMarcado = "";
  String valorLarTemporario = "";
  String valorSexoMarcado = "";
  String? valorEspecieSelecionado;
  String? valorRacaSelecionado;

  List<dynamic> listaEspecies = [];
  List<dynamic> listaRacas = [];

  Map<String, bool> mapaCoresNomeBool = {};
  Map<String, int> mapaCoresNomeId = {};
  List<int> listaCoresSelecionadas = [];

  @override
  void initState() {
    cargaInicialBD();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(30.0, 50, 30.0, 20.0),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Filtre os posts pelas opções abaixo:",
                  style: TextStyle(color: estilo.corprimaria, fontSize: 18)),
              const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 1.0)),
              CampoTextoCurto(
                rotulo: "Termos da postagem",
                controlador: outrasinformacoesController,
                tipoCampo: TextInputType.text,
              ),
              CampoSelect(
                  rotulo: "Espécie",
                  valorSelecionado: valorEspecieSelecionado,
                  funcaoOnChange: selecionarEspecie,
                  listaItens: listaEspecies),
              if (listaRacas.isNotEmpty)
                CampoSelect(
                    rotulo: "Raça",
                    valorSelecionado: valorRacaSelecionado,
                    funcaoOnChange: selecionarRaca,
                    listaItens: listaRacas),
              const Text("Sexo:",
                  style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
              RadioListTile(
                visualDensity: const VisualDensity(horizontal: -4.0),
                dense: true,
                title: const Text("Macho",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
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
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
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
                            listaCoresSelecionadas.remove(mapaCoresNomeId[key]);
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
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                value: "Sim",
                groupValue: valorColeiraMarcado,
                onChanged: (value) {
                  setState(() {
                    valorColeiraMarcado = value.toString();
                  });
                },
              ),
              RadioListTile(
                visualDensity: const VisualDensity(horizontal: -4.0),
                dense: true,
                title: const Text("Não",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                value: "Não",
                groupValue: valorColeiraMarcado,
                onChanged: (value) {
                  setState(() {
                    valorColeiraMarcado = value.toString();
                  });
                },
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10.0)),
              /*
                Text("Deu lar temporário?",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Sim",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: "Sim",
                  groupValue: valorLarTemporario,
                  onChanged: (value) {
                    setState(() {
                      valorLarTemporario = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Não",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: "Não",
                  groupValue: valorLarTemporario,
                  onChanged: (value) {
                    setState(() {
                      valorLarTemporario = value.toString();
                    });
                  },
                ),
                
                const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10)),
                */
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(estilo.corprimaria),
                    ),
                    onPressed: () {
                      _filtrarPosts();
                    },
                    child: const Text(
                      "Filtrar",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  )),
              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
            ],
          )),
    );
  }

  void _filtrarPosts() {
    List<PostModel> listaTemp = [];
    for(var post in widget.listaPosts){
      if(valorEspecieSelecionado!= null){
        if(post.especieAnimal!.id != int.parse(valorEspecieSelecionado!)){
          continue;
        }
      }
      if(valorRacaSelecionado!= null){
        if(post.racaAnimal!.id != int.parse(valorRacaSelecionado!)){
          continue;
        }
      }
      if(valorSexoMarcado.isNotEmpty){
        if(post.sexoAnimal != valorSexoMarcado){
          continue;
        }
      }

      if(valorColeiraMarcado.isNotEmpty){
        if(post.coleira == true && valorColeiraMarcado=="Não"){
          continue;
        }else if(post.coleira == false && valorColeiraMarcado=="Sim"){
          continue;
        }
      }
      if(listaCoresSelecionadas.isNotEmpty){
        bool corEncontrada = false;

        for(var cor in post.coresAnimal!){
          corEncontrada = listaCoresSelecionadas.any((element) => element == cor.id);
          if(corEncontrada){
            break;
          }
        }
        if(!corEncontrada){
          continue;
        }
      }
      listaTemp.add(post);

    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ListaPostsPerdidos(title: 'Animais Perdidos', listaPostsFiltrada: listaTemp)));

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
