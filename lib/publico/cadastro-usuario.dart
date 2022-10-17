import 'dart:convert';

import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/publico/usuario-cadastrado-sucesso.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/publico/login.dart';
import 'package:http/http.dart' as http;

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key, required this.title});

  final String title;

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

Future<UsuarioModel?> cadastrarUsuario(String username, String email,
    String senha, String telefone, BuildContext context) async {
  var url = "http://localhost:8080/addusuario";

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "username": username,
      "email": email,
      "senha": senha,
      "telefone": telefone,
    }),
  );

  String responseString = response.body;
  if (response.statusCode == 200) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return MyAlertDialog(
            titulo: "Backend Response", conteudo: response.body);
      },
    );
  }
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController repetirsenhaController = TextEditingController();

  UsuarioModel? usuario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Cadastro de Usuário"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 126, 107, 107)),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.0, 50, 30.0, 10.0),
        child: Column(
          children: [
            campoInput("Nome", nomeController, TextInputType.name),
            campoInput("Email", emailController, TextInputType.emailAddress),
            campoInput("Telefone", telefoneController, TextInputType.phone),
            campoInputObscuro(
                "Senha", senhaController, TextInputType.visiblePassword),
            campoInputObscuro("Confirmar senha", repetirsenhaController,
                TextInputType.visiblePassword),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 1.0)),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 126, 107, 107)),
                  ),
                  onPressed: () async {
                    String username = nomeController.text;
                    String email = emailController.text;
                    String senha = senhaController.text;
                    String telefone = telefoneController.text;
                    UsuarioModel? usuarioCadastro = await cadastrarUsuario(
                        username, email, senha, telefone, context);
                    setState(() {
                      usuario = usuarioCadastro;
                    });
                  },
                  child: const Text(
                    "Cadastrar",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  /*
  Widget exibirMensagemResposta(int status, String mensagem){
    if(status == 1){
      return Text(mensagem, style: TextStyle(color: Color.fromARGB(255, 126, 107, 107),fontSize: 20));
    }else{
      return SizedBox.shrink();
    }  

  }
  */
  /*
  void _cadastrarUsuario() {
    if (nomeController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        telefoneController.text.isNotEmpty &&
        senhaController.text.isNotEmpty &&
        repetirsenhaController.text.isNotEmpty &&
        senhaController.text == repetirsenhaController.text) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UsuarioCadastradoSucesso(
                  title: 'Usuário Cadastrado com sucesso')));
    }
  }
  */
/*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(title: 'Busca Patas - Login')),
    );
    */

  Widget campoInput(
      String label, TextEditingController controller, TextInputType tipoCampo) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
        child: TextFormField(
          keyboardType: tipoCampo,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          controller: controller,
        ));
  }

  Widget campoInputObscuro(
      String label, TextEditingController controller, TextInputType tipoCampo) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
        child: TextFormField(
          keyboardType: tipoCampo,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          controller: controller,
          obscureText: true,
        ));
  }
}

class MyAlertDialog extends StatelessWidget {
  final String titulo;
  final String conteudo;

  final List<Widget> acoes;

  MyAlertDialog({
    this.titulo = '',
    this.conteudo = '',
    this.acoes = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.titulo,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: this.acoes,
      content: Text(
        this.conteudo,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
