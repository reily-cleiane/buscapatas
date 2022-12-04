import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class CampoSelect extends StatefulWidget {
  final String rotulo;
  bool obrigatorio;
  Function? validador;
  String? valorSelecionado;
  Function funcaoOnChange;
  List<dynamic> listaItens = [];

  CampoSelect({
    Key? key,
    required this.rotulo,
    required this.valorSelecionado,
    required this.funcaoOnChange,
    required this.listaItens,
    this.validador,
    this.obrigatorio = false,
  }) : super(key: key);

  @override
  _CampoSelectState createState() => _CampoSelectState();
}

class _CampoSelectState extends State<CampoSelect> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
        child: DropdownButtonFormField<String>(
          hint: const Text("Selecione"),
          value: widget.valorSelecionado,
          icon: const Icon(Icons.arrow_drop_down_rounded),
          elevation: 16,
          validator: (_) {
            if (widget.obrigatorio) {
              if (widget.valorSelecionado == null) {
                return "O campo deve ser preenchido";
              } else {
                if (widget.validador != null){
                  return widget.validador!(context);
                }
              }
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: widget.rotulo,
            labelStyle:
                const TextStyle(fontSize: 21, color: estilo.corprimaria),
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: estilo.corprimaria),
          onChanged: (String? valor) {
            widget.funcaoOnChange(valor);
          },
          items: widget.listaItens.map<DropdownMenuItem<String>>((mapa) {
            return DropdownMenuItem<String>(
              value: mapa["id"].toString(),
              child: Text(mapa["nome"]),
            );
          }).toList(),
        ));
  }
}
