import 'package:flutter/material.dart';
import 'package:buscapatas/publico/login.dart';

class UsuarioCadastradoSucesso extends StatefulWidget {
  UsuarioCadastradoSucesso({super.key, required this.title});

  final String title;

  @override
  State<UsuarioCadastradoSucesso> createState() => _UsuarioCadastradoSucessoState();
}

class _UsuarioCadastradoSucessoState extends State<UsuarioCadastradoSucesso> {

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(

      body:
      SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30, 120 , 30.0, 80.0),
        child: Column(
        children: <Widget>[
        Text("Usuário cadastrado com sucesso", style: TextStyle(color: Color.fromARGB(255, 13, 167, 26),fontSize: 20 )),
        Padding( padding: const EdgeInsets.fromLTRB(0, 80.0, 0, 10.0)),
        SizedBox(
          width: double.infinity,
          height: 50,
          child:
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(255, 126, 107, 107)),
                ),
              onPressed: () {
                _redirecionar();
                   
              },
              child: const Text(
                "Ir para login",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
        ),
        ],
        )
     
      ),
    );
  }

  void _redirecionar(){
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Login(title: 'Busca Patas - Login')));
    }

}