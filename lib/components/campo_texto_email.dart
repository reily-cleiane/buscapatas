import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:flutter/material.dart';

class CampoTextoEmail extends StatefulWidget {
  final int usuarioId;
  final String label;
  final String text;
  final TextEditingController controlador;
  final TextInputType tipoCampo;
  final ValueChanged<String> onChanged;
  final Function? validador;

  const CampoTextoEmail({
    Key? key,
    required this.usuarioId,
    required this.label,
    required this.text,
    required this.controlador,
    required this.tipoCampo,
    required this.onChanged,
    this.validador
    
  }) : super(key: key);

  @override
  _CampoTextoEmailState createState() => _CampoTextoEmailState();
}

class _CampoTextoEmailState extends State<CampoTextoEmail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.controlador,
            keyboardType: widget.tipoCampo,
            decoration: InputDecoration(
              labelText: widget.label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            validator: (_) {
              if (widget.controlador.text.isEmpty) {
                return "O campo deve ser preenchido";
              } else {
                if (widget.validador != null){
                  return widget.validador!(context);
                }
              }
              return null;
            },
            onChanged: widget.onChanged,
          ),
        ],
      );
}
