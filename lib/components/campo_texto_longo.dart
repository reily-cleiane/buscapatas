import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class CampoTextoLongo extends StatefulWidget {
  final String rotulo;
  final TextEditingController controlador;
  final String placeholder;
  final bool obrigatorio;

  const CampoTextoLongo({
    Key? key,
    required this.rotulo,
    required this.controlador,
    required this.placeholder,
    required this.obrigatorio,
  }) : super(key: key);

  @override
  _CampoTextoLongoState createState() => _CampoTextoLongoState();
}

class _CampoTextoLongoState extends State<CampoTextoLongo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 10.0),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          validator: (texto) {
            if (widget.obrigatorio && texto!.isEmpty) {
              return "O campo deve ser preenchido";
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: widget.rotulo,
              labelStyle:
                  const TextStyle(fontSize: 21, color: estilo.corprimaria),
              border: const OutlineInputBorder(),
              hintText: widget.placeholder,
              hintStyle: const TextStyle(
                  fontSize: 14.0, color: Color.fromARGB(255, 187, 179, 179)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              floatingLabelStyle:
                  const TextStyle(color: estilo.corprimaria, fontSize: 16)),
          controller: widget.controlador,
          maxLines: 4,
        ));
  }
}
