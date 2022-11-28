import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class CampoTextoCurto extends StatefulWidget {
  final String rotulo;
  final TextEditingController controlador;
  final TextInputType tipoCampo;
  String placeholder;
  bool obrigatorio;
  bool rotuloSuperior;
  bool mascarado;
  Function? validador;

  CampoTextoCurto({
    Key? key,
    required this.rotulo,
    required this.controlador,
    this.placeholder = "",
    this.rotuloSuperior = false,
    this.mascarado = false,
    required this.tipoCampo,
    this.validador,
    this.obrigatorio = false,
  }) : super(key: key);

  @override
  _CampoTextoCurtoState createState() => _CampoTextoCurtoState();
}

class _CampoTextoCurtoState extends State<CampoTextoCurto> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, (widget.rotuloSuperior)? 20:10, 0, (widget.rotuloSuperior)? 20:10),
        child: TextFormField(
          keyboardType: widget.tipoCampo,
          decoration: InputDecoration(
            floatingLabelBehavior:
                (widget.rotuloSuperior) ? FloatingLabelBehavior.always : null,
            labelText: widget.rotulo,
            labelStyle: (widget.rotuloSuperior)
                ? const TextStyle(fontSize: 21, color: estilo.corprimaria)
                : null ,
            hintText: (widget.rotuloSuperior) ? widget.placeholder : null,
            hintStyle: (widget.rotuloSuperior)
                ? const TextStyle(
                    fontSize: 14.0, color: Color.fromARGB(255, 187, 179, 179))
                : null,
            border: const OutlineInputBorder(),
          ),
          controller: widget.controlador,
          obscureText: widget.mascarado,
          validator: (_) {
            if (widget.obrigatorio) {
              if (widget.controlador.text.isEmpty) {
                return "O campo deve ser preenchido";
              } else {
                if (widget.validador != null){
                  return widget.validador!(context);
                }
              }
            }
            return null;
          },
        ));
  }
}
