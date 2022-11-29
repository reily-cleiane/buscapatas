import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class CampoTexto extends StatefulWidget {
  // final int maxLines;
  final int usuarioId;
  final String label;
  final String text;
  final TextInputType tipoCampo;
  final bool enableEdit;
  final ValueChanged<String> onChanged;

  const CampoTexto({
    Key? key,
    // this.maxLines = 1,
    required this.usuarioId,
    required this.label,
    required this.text,
    required this.tipoCampo,
    required this.enableEdit,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CampoTextoState createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  late final TextEditingController _controller;
  bool _emailUnico = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: _controller,
              keyboardType: widget.tipoCampo,
              decoration: InputDecoration(
                labelText: widget.label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              validator: (valorDigitado) {
                if (_controller.text.isEmpty) {
                  return 'Campo não deve estar vazio';
                } else if (widget.tipoCampo == TextInputType.name) {
                  String pattern = r"^[\p{L} ]*$";
                  RegExp regExp = RegExp(pattern,
                      caseSensitive: false, unicode: true, dotAll: true);
                  if (!regExp.hasMatch(valorDigitado!)) {
                    return 'Nome inválido';
                  }
                } else if (widget.tipoCampo == TextInputType.emailAddress) {
                  if (_controller.text.isNotEmpty) {
                    validarEmail(context);
                  }
                  if (!_emailUnico) {
                    return "Já existe usuário cadastrado com esse e-mail";
                  }
                  String padraoEmail =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(padraoEmail);
                  if (!regExp.hasMatch(_controller.text)) {
                    return "O campo E-mail deve ser preenchido com um e-mail válido";
                  }
                  return null;

                } else if (widget.tipoCampo == TextInputType.phone) {
                  String pattern = r'(^\(?\d{2}\)?[\s-]?[\s9]?\d{4}-?\d{4}$)';
                  RegExp regExp = RegExp(pattern);
                  if (!regExp.hasMatch(valorDigitado!)) {
                    return 'Número inválido';
                  }
                } else {
                  return null;
                }
              },
              enabled: widget.enableEdit,
              onChanged: widget.onChanged,
            ),
          ),
        ],
      );

  void validarEmail(BuildContext context) async {
    if (_controller.text.isNotEmpty) {
      List<UsuarioModel> listaTemp =
          await UsuarioModel.getUsuariosByEmail(_controller.text);
      bool mesmoIdLogado = listaTemp.any((element) => element.id == widget.usuarioId);
      if (listaTemp.isEmpty || mesmoIdLogado) {
        setState(() {
           _emailUnico = true;
        });
      } else {
        setState(() {
          _emailUnico = false;
        });
      }
    }
  }
}
