import 'package:buscapatas/model/EspecieModel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:buscapatas/home.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/model/CorModel.dart';
import 'package:http/http.dart' as http;
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class CadastroPost extends StatefulWidget {
  const CadastroPost({super.key, required this.title});

  final String title;

  @override
  State<CadastroPost> createState() => _CadastroPostState();
}

class _CadastroPostState extends State<CadastroPost> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController outrasinformacoesController = TextEditingController();
  TextEditingController orientacoesController = TextEditingController();
  TextEditingController recompensaController = TextEditingController();

  bool valorColeiraMarcado = false;
  bool corMarcada = false;
  String valorSexoMarcado = "";
  String? valorEspecieSelecionado;
  String? valorRacaSelecionado;

  List<dynamic> listaEspecies = [];
  List<dynamic> listaRacas = [];

  Map<String, bool> listaCores = {
    'Preto': false,
    'Branco': false,
    'Cinza': false,
    'Marrom': false,
    'Laranja': false,
  };

  @override
  void initState() {
    getEspecies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cadastro de Animal"),
          centerTitle: true,
          backgroundColor: estilo.corprimaria),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.0, 50, 30.0, 20.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                campoInput("Nome do animal", nomeController, TextInputType.name,
                    "Nome ou apelido"),
                campoSelect(
                    "Espécie", valorEspecieSelecionado, listaEspecies, selecionarEspecie),
                campoSelect(
                    "Raça", valorRacaSelecionado, listaRacas, selecionarRaca),
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
                    children: listaCores.keys.map((String key) {
                      return CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: new Text(key,
                            style: TextStyle(
                                color: estilo.corprimaria, fontSize: 16)),
                        value: listaCores[key],
                        onChanged: (bool? value) {
                          setState(() {
                            listaCores[key] = value!;
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
                campoInputLongo(
                    "Outras informações",
                    outrasinformacoesController,
                    TextInputType.multiline,
                    "Outras características para ajudar na identificação do animal"),
                campoInputLongo(
                    "Orientações gerais",
                    orientacoesController,
                    TextInputType.multiline,
                    "Temperamento do animal e outras instruções importantes"),
                campoInput("Recompensa", recompensaController,
                    TextInputType.number, "R\$ 0"),
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

  void getEspecies() async {
    const request = "http://localhost:8080/especies";

    http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var resposta = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> especiesTemp = [];

      for (var especie in resposta) {
        especiesTemp.add(especie);
      }
      setState(() {
        listaEspecies = especiesTemp;
      });
    } else {
      throw Exception('Falha no servidor ao carregar usuários');
    }
  }

  void getRacas() async {
    setState(() {
      valorRacaSelecionado = null;   
    });
    var request =
        "http://localhost:8080/racas/especie/${valorEspecieSelecionado}";

    http.Response response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var resposta = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> racasTemp = [];

      for (var raca in resposta) {
        racasTemp.add({"id": raca["id"], "nome": raca["nome"]});
      }
      setState(() {
        listaRacas.clear();
        listaRacas = racasTemp;
      });
    } else {
      throw Exception('Falha no servidor ao carregar usuários');
    }
  }

  void _cadastrarPost() {
    // Colocar a validação depois
    //if (_formKey.currentState!.validate())
    _addPost(context);
  }

  void _addPost(BuildContext context) async {
    var url = "http://localhost:8080/posts";

    CorModel cor1 = CorModel.id(1);
    CorModel cor2 = CorModel.id(2);
    List<CorModel> cores = [cor1, cor2];

    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "outrasInformacoes": outrasinformacoesController.text,
          "orientacoesGerais": orientacoesController.text,
          "recompensa": int.parse(recompensaController.text),
//ajustar quando pegar latitude
          "latitude": 987,
//ajustar quando pegar longitude
          "longitude": 9632,
          "nomeAnimal": nomeController.text,
          "coleira": valorColeiraMarcado,
          "especieAnimal": {"id": (valorEspecieSelecionado == null)? null: int.parse(valorEspecieSelecionado!)},
          "racaAnimal": {"id": (valorRacaSelecionado == null)? null: int.parse(valorRacaSelecionado!)},
//ajustar quando pegar cor
          "coresAnimal": cores,
          "sexoAnimal": valorSexoMarcado,
          "tipoPost": "ANIMAL_PERDIDO",
//ajustar quando pegar usuario
          "usuario": UsuarioModel.id(1),
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

  Widget campoSelect(String label, var valorSelecionado, var listaItens,
      Function funcaoOnChange) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
        child: DropdownButtonFormField<String>(
          hint: const Text("Selecione"),
          value: valorSelecionado,
          icon: const Icon(Icons.arrow_drop_down_rounded),
          elevation: 16,
          decoration: InputDecoration(
            labelText: label,
            labelStyle:
                const TextStyle(fontSize: 21, color: estilo.corprimaria),
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: estilo.corprimaria),
          onChanged: (String? valor) {
            funcaoOnChange(valor);
          },
          items: listaItens.map<DropdownMenuItem<String>>((mapa) {
            return DropdownMenuItem<String>(
              value: mapa["id"].toString(),
              child: Text(mapa["nome"]),
            );
          }).toList(),
        ));
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

  Widget campoInputLongo(String label, TextEditingController controller,
      TextInputType tipoCampo, String placeholder) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 10.0),
        child: TextFormField(
          keyboardType: tipoCampo,
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
