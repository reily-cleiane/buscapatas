import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class CadastroPostAvistado extends StatefulWidget {
  const CadastroPostAvistado({super.key, required this.title});

  final String title;

  @override
  State<CadastroPostAvistado> createState() => _CadastroPostAvistadoState();
}

class _CadastroPostAvistadoState extends State<CadastroPostAvistado> {
  TextEditingController racaController = TextEditingController();
  TextEditingController especieController = TextEditingController();
  TextEditingController sexoController = TextEditingController();
  TextEditingController outrasinformacoesController = TextEditingController();
  TextEditingController coleiraController = TextEditingController();
  TextEditingController lartemporarioController = TextEditingController();

  String? itemSexo;
  String grupoSexo = "";
  String grupoColeira = "";
  String grupoLarTemporario = "";
  String? especie;
  bool corMarcada = false;

  List<String> listaEspecies = <String>[
    'Gato',
    'Cachorro',
    'Hamster',
    'Cacatua'
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
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Cadastrar animal avistado"),
          centerTitle: true,
          backgroundColor: estilo.corprimaria),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.0, 50, 30.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              hint: const Text("Selecione"),
              value: especie,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              decoration: InputDecoration(
                labelText: "Espécie",
                border: const OutlineInputBorder(),
              ),
              style: const TextStyle(color: estilo.corprimaria),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  especie = value!;
                });
              },
              items:
                  listaEspecies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            campoInput("Raça", racaController, TextInputType.name,
                "Ex: Labrador, Siamês"),
            Text("Sexo:",
                style: TextStyle(
                    color: estilo.corprimaria, fontSize: 20)),
            RadioListTile(
              visualDensity: const VisualDensity(horizontal: -4.0),
              dense: true,
              title: const Text("Macho",
                  style: TextStyle(
                      color: estilo.corprimaria, fontSize: 16)),
              value: "macho",
              groupValue: grupoSexo,
              onChanged: (value) {
                setState(() {
                  grupoSexo = value.toString();
                });
              },
            ),
            RadioListTile(
              visualDensity: const VisualDensity(horizontal: -4.0),
              dense: true,
              title: const Text("Fêmea",
                  style: TextStyle(
                      color: estilo.corprimaria, fontSize: 16)),
              value: "femea",
              groupValue: grupoSexo,
              onChanged: (value) {
                setState(() {
                  grupoSexo = value.toString();
                });
              },
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 1.0)),
            Text("Cor:",
                style: TextStyle(
                    color: estilo.corprimaria, fontSize: 20)),
            FractionallySizedBox(
              widthFactor: 0.6,
              child: ListView(
                shrinkWrap: true,
                children: listaCores.keys.map((String key) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: new Text(key,
                        style: TextStyle(
                            color: estilo.corprimaria,
                            fontSize: 16)),
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
                style: TextStyle(
                    color: estilo.corprimaria, fontSize: 20)),
            RadioListTile(
              visualDensity: const VisualDensity(horizontal: -4.0),
              dense: true,
              title: const Text("Sim",
                  style: TextStyle(
                      color: estilo.corprimaria, fontSize: 16)),
              value: "sim",
              groupValue: grupoColeira,
              onChanged: (value) {
                setState(() {
                  grupoColeira = value.toString();
                });
              },
            ),
            RadioListTile(
              visualDensity: const VisualDensity(horizontal: -4.0),
              dense: true,
              title: const Text("Não",
                  style: TextStyle(
                      color: estilo.corprimaria, fontSize: 16)),
              value: "nao",
              groupValue: grupoColeira,
              onChanged: (value) {
                setState(() {
                  grupoColeira = value.toString();
                });
              },
            ),
            Text("Deu lar temporário:",
                style: TextStyle(
                    color: estilo.corprimaria, fontSize: 20)),
            RadioListTile(
              visualDensity: const VisualDensity(horizontal: -4.0),
              dense: true,
              title: const Text("Sim",
                  style: TextStyle(
                      color: estilo.corprimaria, fontSize: 16)),
              value: "sim",
              groupValue: grupoLarTemporario,
              onChanged: (value) {
                setState(() {
                  grupoLarTemporario = value.toString();
                });
              },
            ),
            RadioListTile(
              visualDensity: const VisualDensity(horizontal: -4.0),
              dense: true,
              title: const Text("Não",
                  style: TextStyle(
                      color: estilo.corprimaria, fontSize: 16)),
              value: "nao",
              groupValue: grupoLarTemporario,
              onChanged: (value) {
                setState(() {
                  grupoLarTemporario = value.toString();
                });
              },
            ),
            campoInputLongo(
                "Outras informações",
                outrasinformacoesController,
                TextInputType.multiline,
                "Outras características para ajudar na identificação do animal"),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10)),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        estilo.corprimaria),
                  ),
                  onPressed: () {
                    _cadastrarAnimal();
                  },
                  child: const Text(
                    "Cadastrar",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
          ],
        ),
      ),
    );
  }

  void _cadastrarAnimal() {}

  Widget campoInput(String label, TextEditingController controller,
      TextInputType tipoCampo, String placeholder) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
        child: TextFormField(
          keyboardType: tipoCampo,
          decoration: InputDecoration(
            labelText: label,
            hintText: placeholder,
            hintStyle: TextStyle(
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
        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
        child: TextFormField(
          keyboardType: tipoCampo,
          decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              hintText: placeholder,
              hintStyle: TextStyle(
                  fontSize: 14.0, color: Color.fromARGB(255, 187, 179, 179)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              floatingLabelStyle: const TextStyle(
                  color: estilo.corprimaria, fontSize: 16)),
          controller: controller,
          maxLines: 4,
        ));
  }
}
