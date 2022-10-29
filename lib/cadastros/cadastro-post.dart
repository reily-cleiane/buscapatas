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
  TextEditingController nomeController = TextEditingController();
  TextEditingController racaController = TextEditingController();

  TextEditingController outrasinformacoesController = TextEditingController();
  TextEditingController orientacoesController = TextEditingController();

  TextEditingController recompensaController = TextEditingController();

  String valorSexoMarcado = "";
  bool valorColeiraMarcado = false;
  String? valorEspecieSelecionado;

  bool corMarcada = false;

  final _formKey = GlobalKey<FormState>();

  List<String> listaEspecies = <String>[
    'Gato',
    'Cachorro',
    'Hamster',
    'Cacatua',
  ];

  Map<String, bool> listaCores = {
    'Preto': false,
    'Branco': false,
    'Cinza': false,
    'Marrom': false,
    'Laranja': false,
  };

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
                DropdownButtonFormField<String>(
                  hint: const Text("Selecione"),
                  value: valorEspecieSelecionado,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  elevation: 16,
                  decoration: const InputDecoration(
                    labelText: "Espécie",
                    labelStyle:
                        TextStyle(fontSize: 21, color: estilo.corprimaria),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: estilo.corprimaria),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      valorEspecieSelecionado = value!;
                    });
                  },
                  items: listaEspecies
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                campoInput("Raça", racaController, TextInputType.name,
                    "Ex: Labrador, Siamês"),
                const Text("Sexo:",
                    style: TextStyle(color: estilo.corprimaria, fontSize: 16)),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  dense: true,
                  title: const Text("Macho",
                      style:
                          TextStyle(color: estilo.corprimaria, fontSize: 16)),
                  value: "MACHO",
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
                  value: "FEMEA",
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

  void _cadastrarPost() {
    // Colocar a validação depois
    //if (_formKey.currentState!.validate())
    _addPost(context);
  }

  void _addPost(BuildContext context) async {
    var url = "http://localhost:8080/posts";
    
    CorModel cor1 = CorModel.id(1);
    CorModel cor2 = CorModel.id(2);
    List<CorModel> cores = [cor1,cor2];

    var response = await http.post(
      Uri.parse(url),
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
//Conveter o valor para true ou false
        "coleira": false,
//ajustar quando pegar espécie
        "especieAnimal": {"id":1},
//ajustar quando pegar raça
        "racaAnimal": {"id":1},
//ajustar quando pegar cor
        "coresAnimal": cores,
        "sexoAnimal": valorSexoMarcado,
        "tipoPost": "ANIMAL_PERDIDO",
//ajustar quando pegar usuario
        "usuario": UsuarioModel.id(1),

      })
    );

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

  Widget campoInput(String label, TextEditingController controller,
      TextInputType tipoCampo, String placeholder) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
        child: TextFormField(
          keyboardType: tipoCampo,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 21, color: estilo.corprimaria),
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
              labelStyle: const TextStyle(fontSize: 21, color: estilo.corprimaria),
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
              backgroundColor: MaterialStatePropertyAll<Color>(
                  estilo.corprimaria),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Home(false,title: 'Busca Patas')));

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

