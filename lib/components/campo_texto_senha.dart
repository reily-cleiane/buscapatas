import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class CampoTextoSenha extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final TextInputType tipoCampo;
  final ValueChanged<String> onChanged;

  const CampoTextoSenha({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.tipoCampo,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CampoTextoSenhaState createState() => _CampoTextoSenhaState();
}

class _CampoTextoSenhaState extends State<CampoTextoSenha> {
  late final TextEditingController _controller;
  var _passwordVisible = false;

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
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: estilo.corprimaria,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_passwordVisible,
                validator: (valorDigitado) {
                if (_controller.text.isEmpty) {
                  return 'Campo não deve estar vazio';
                } else {
                  return null;
                }
              },
              onChanged: widget.onChanged,
            ),
          ),
        ],
      );
}
