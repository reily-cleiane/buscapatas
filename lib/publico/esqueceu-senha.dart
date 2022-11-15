import 'package:buscapatas/components/campo-texto.dart';
import 'package:buscapatas/model/test-user.dart';
import 'package:buscapatas/utils/mock_usuario.dart';
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
    User usuario = MockUsuario.getUser();

    TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Mudar Senha", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 126, 107, 107)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30.0, 50, 30.0, 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Digite o seu email e enviaremos um link para você mudar sua senha atual.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 126, 107, 107))),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 1.0)),

            CampoTexto(label: 'Email', 
              text: usuario.email, 
              tipoCampo: TextInputType.emailAddress,
              enableEdit: true,
              onChanged: (email) => usuario = usuario.copy(email: email)),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 1.0)),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 126, 107, 107)),
                  ),
                  onPressed: () {
                  },
                  child: const Text(
                    "Mudar Senha",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )),
          ],
        ),
        ),
      );
  }
}