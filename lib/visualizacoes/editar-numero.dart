import 'package:buscapatas/visualizacoes/confirmar-numero.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:flutter/services.dart';

class EditarNumero extends StatefulWidget {
  const EditarNumero({super.key, required this.title});

  final String title;

  @override
  State<EditarNumero> createState() => _EditarNumeroState();
}

class _EditarNumeroState extends State<EditarNumero> {
  TextEditingController numeroController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Trocar número de celular"),
            centerTitle: true,
            foregroundColor: Colors.white,
            backgroundColor: estilo.corprimaria),
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(30.0, 50, 30.0, 10.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                    child: TextFormField(
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: "Número de celular",
                          border: const OutlineInputBorder(),
                        ),
                        controller: numeroController,
                        validator: (texto) {
                          if (numeroController.text.length != 11) {
                            return "O campo Telefone deve ser preenchido com um número válido de 11 dígitos";
                          }
                        })),
                        ElevatedButton(
                          onPressed: () {
                            _confirmarNumero(numeroController.text);
                          },
                          child: Text("confirmar",
                          style: TextStyle(color: Colors.white)),
                        )
              ]),
            )));
  }

  void _confirmarNumero(String num) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmarNumero(title: "Confirmar número de celular", numero: num))
      );
  }
}
