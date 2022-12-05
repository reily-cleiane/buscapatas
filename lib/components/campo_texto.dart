import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget {
  final int usuarioId;
  final String label;
  final String text;
  final TextInputType tipoCampo;
  final ValueChanged<String> onChanged;

  const CampoTexto({
    Key? key,
    required this.usuarioId,
    required this.label,
    required this.text,
    required this.tipoCampo,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CampoTextoState createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  late final TextEditingController _controller;

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
          TextFormField(
            controller: _controller,
            keyboardType: widget.tipoCampo,
            decoration: InputDecoration(
              labelText: widget.label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            validator: (valorDigitado) {
              if (valorDigitado!.isEmpty) {
                return 'Campo não deve estar vazio';
              } else if (widget.tipoCampo == TextInputType.name) {
                String pattern = r"^[\p{L} ]*$";
                RegExp regExp = RegExp(pattern,
                    caseSensitive: false, unicode: true, dotAll: true);
                if (!regExp.hasMatch(valorDigitado)) {
                  return 'Nome inválido';
                }
              } else if (widget.tipoCampo == TextInputType.phone) {
                String pattern = r'(^\(?\d{2}\)?[\s-]?[\s9]?\d{4}-?\d{4}$)';
                RegExp regExp = RegExp(pattern);
                if (!regExp.hasMatch(valorDigitado)) {
                  return 'Número inválido';
                }
              } else {
                return null;
              }
            },
            onChanged: widget.onChanged,
          ),
        ],
      );
}
