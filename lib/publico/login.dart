import 'package:flutter/material.dart';
import 'package:buscapatas/publico/esqueceu-senha.dart';
import 'package:buscapatas/publico/nao-implementado.dart';
import 'package:buscapatas/publico/cadastro-usuario.dart';
import 'package:buscapatas/home.dart';

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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 10, 30.0, 10.0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 60.0, 0, 0),
            ),
            Image.asset(
              "imagens/Logo.png",
              //fit: BoxFit.cover,
              fit: BoxFit.contain,
              width: 180,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 10.0),
              child: campoInput(
                  "E-mail", emailController, TextInputType.emailAddress, false),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
              child: campoInput("Senha", senhaController,
                  TextInputType.visiblePassword, true),
            ),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 126, 107, 107)),
                  ),
                  onPressed: () {
                    _entrar();
                  },
                  child: const Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20.0, 0, 15.0),
              child: Text("OU",
                  style: TextStyle(
                      color: Color.fromARGB(255, 126, 107, 107), fontSize: 20)),
            ),
            FractionallySizedBox(
                widthFactor: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NaoImplementado(
                              title:
                                  'Busca Patas - Funcionalidade ainda não implementada')),
                    );
                  },
                  child: Image.asset(
                    "imagens/entrar-com-google2.png",
                    fit: BoxFit.contain,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 40.0),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EsqueceuSenha(
                                title: 'Busca Patas - Esqueci minha senha')),
                      );
                    },
                    child: Ink(
                      width: double.infinity,
                      height: 30,
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            text: "Esqueceu sua senha? ",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color.fromARGB(255, 126, 107, 107),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ))),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CadastroUsuario(title: 'Novo usuário')),
                );
              },
              child: Ink(
                width: double.infinity,
                height: 30,
                child: Center(
                    child: RichText(
                        text: const TextSpan(
                  text: "Não possui conta? ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 126, 107, 107),
                    fontSize: 16.0,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Cadastre-se',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(255, 126, 107, 107),
                          fontSize: 16.0,
                        )),
                    // can add more TextSpans here...
                  ],
                ))),
              ),
            )
          ],
        ),
      ),
    ));
  }

  void _entrar() {
    bool autorizado = false;
    String email = emailController.text;
    String senha = senhaController.text;
    if (email.isNotEmpty && senha.isNotEmpty) {
      autorizado = true;
    } else {
      senhaController.text = "";
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Home(autorizado, title: "Página inicial")),
    );
  }

  Widget campoInput(String label, TextEditingController controller,
      TextInputType tipoCampo, bool oculto) {
    return TextFormField(
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
