import 'package:buscapatas/components/campo-texto.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/model/test-user.dart';
import 'package:buscapatas/utils/mock_usuario.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class EsqueceuSenha extends StatefulWidget {
  EsqueceuSenha({super.key, required this.title, usuario}){
    if(usuario!=null){
      this.usuario = usuario;
    }
  }

  final String title;
  UsuarioModel usuario = new UsuarioModel();

  @override
  State<EsqueceuSenha> createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha> {
  UsuarioModel usuarioLogado = new UsuarioModel();

  @override
  void initState() {
    usuarioLogado = widget.usuario;
  }

  @override
  Widget build(BuildContext context) {
    User usuario = MockUsuario.getUser();
    
    // TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Mudar Senha", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: estilo.corprimaria),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30.0, 50, 30.0, 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Digite o seu email e enviaremos um link para você mudar sua senha atual.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: estilo.corprimaria)),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 1.0)),

            CampoTexto(label: 'Email', 
              usuarioId: usuarioLogado.id!,
              text: usuarioLogado.email!=null?usuarioLogado.email!:"", 
              tipoCampo: TextInputType.emailAddress,
              onChanged: (email) => usuario = usuario.copy(email: email)),
            
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 1.0)),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        estilo.corprimaria),
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