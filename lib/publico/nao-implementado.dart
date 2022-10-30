import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/componentes-interface/campo_input.dart';

class NaoImplementado extends StatefulWidget {
  const NaoImplementado({super.key, required this.title});

  final String title;

  @override
  State<NaoImplementado> createState() => _NaoImplementadoState();
}

class _NaoImplementadoState extends State<NaoImplementado> {
  TextEditingController nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
   
    return Material(

      child: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 120 , 30.0, 10.0),
        child:
        CampoInput("Teste label",nomeController,TextInputType.name),
        //Text("Funcionalidade ainda não implementada", style: TextStyle(color: estilo.corprimaria,fontSize: 20)),
     
      ),
      );
  }

}