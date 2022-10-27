import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class EsqueceuSenha extends StatefulWidget {
  const EsqueceuSenha({super.key, required this.title});

  final String title;

  @override
  State<EsqueceuSenha> createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha> {

  @override
  Widget build(BuildContext context) {
   
    return const Material(

      child: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 120 , 30.0, 10.0),
        child:
        Text("Contate um administrador para recuperar sua senha", style: TextStyle(color: estilo.corprimaria,fontSize: 20)),
     
      ),
    );
  }

}