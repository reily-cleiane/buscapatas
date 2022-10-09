import 'package:flutter/material.dart';

class CompFormulario extends StatefulWidget {
  const CompFormulario({super.key, required this.title});

  final String title;

  @override
  State<CompFormulario> createState() => _CompFormularioState();
}

class _CompFormularioState extends State<CompFormulario> {

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
            title: const Text("\$ Conversor de Moedas by Cleiane \$"),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 126, 107, 107)),
            

      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 120 , 30.0, 10.0),
        child:
        Text("Contate um administrador para recuperar sua senha", style: TextStyle(color: Color.fromARGB(255, 126, 107, 107),fontSize: 20)),
     
      ),
      );
  }

  Widget campoInput(String label, TextEditingController controller, TextInputType tipoCampo, bool oculto){
    return
      TextFormField(
        keyboardType: tipoCampo,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),       
        ),
        controller: controller,
        obscureText: oculto,
    ); 

  }

}