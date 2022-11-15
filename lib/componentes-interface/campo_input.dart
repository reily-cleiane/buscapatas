import 'package:flutter/material.dart';

class CampoInput extends StatelessWidget {
  final String? label;
  bool campoSenha = false;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  CampoInput(this.label,this.controller,this.keyboardType,{
    Key? key,    
    this.campoSenha = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
        child: TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          validator:validator,
          obscureText:campoSenha,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            //errorText: validarCamposObrigatorios(controller.text),
          ),
        ));
  }
}
