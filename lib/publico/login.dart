import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  // This widget is the Login page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding( padding: EdgeInsets.fromLTRB(0, 120.0, 0, 0),
            ),
            Image.asset(
              "imagens/Logo.png",
              //fit: BoxFit.cover,
              fit: BoxFit.contain,
              height: 120,
            ),
            Padding( 
              padding: const EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 10.0),
              child:
                campoInput("E-mail", emailController, TextInputType.emailAddress, false),            
            ),
            Padding( 
              padding: const EdgeInsets.fromLTRB(30.0, 0 , 30.0, 10.0),
              child:
                campoInput("Senha", senhaController, TextInputType.visiblePassword, true),            
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20 , 30.0, 10.0),
              child: SizedBox(
              width: double.infinity,
              height: 50,
              child:
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                    ),
                  onPressed: () {
                  },
                  child: const Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )
              ),
            ),
            
          ],
          
        ),
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