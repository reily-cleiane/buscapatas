import 'dart:convert';

import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/publico/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key, required this.title});

  final String title;

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController repetirSenhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _usuarioExistente = true;

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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              campoInput("Nome", nomeController, TextInputType.name),
              campoInput("Email", emailController, TextInputType.emailAddress),
              campoInput(
                  "Telefone(com DDD)", telefoneController, TextInputType.phone),
              campoInputObscuro(
                  "Senha", senhaController, TextInputType.visiblePassword),
              campoInputObscuro("Confirmar senha", repetirSenhaController,
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
                    onPressed: () {
                      _cadastrarUsuario();
                    },
                    child: const Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _cadastrarUsuario() async {
/*
    if (emailController.text.isNotEmpty) {
      _usuarioExistente = await _emailJaCadastrado();
    }
*/
      print("CHEGOU AQUI NO CADASTRAR");
      if (_formKey.currentState!.validate() &&
          senhaController.text == repetirSenhaController.text) {
        String nome = nomeController.text;
        String email = emailController.text;
        String senha = senhaController.text;
        String telefone = telefoneController.text;

        _addUsuario(nome, email, senha, telefone, context);
      }
  }

  Future<bool> _emailJaCadastrado() async {
    var url = "http://localhost:8080/findbyemail?email=${emailController.text}";
    //http.Response response = await http.get(Uri.parse(url));

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    UsuarioModel usuario;
    if (response.statusCode == 200) {
      //print(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }

    var resposta = json.decode(response.body);

    List<UsuarioModel> usuarios = [];
    bool _jaExisteUsuario = false;

   // print("resposta ${resposta}");
    for (var singleUser in resposta) {
      //print("for ${singleUser}");
      if(singleUser['email'].isNotEmpty){
        _jaExisteUsuario = true;
      }

      //UsuarioModel user =
      //    UsuarioModel.emailSenha(singleUser['email'], singleUser['senha']);
      //Adding user to the list.
      //usuarios.add(user);
    }

    //print(usuarios[0].id);

    if (_jaExisteUsuario) {
      setState(() {
        _usuarioExistente = true;
      });
      //print("CHEGOU AQUI");
      return true;
    } else {
      setState(() {
        _usuarioExistente = false;
      });
      //print("CHEGOU NO ELSE");
      return false;
    }
  }

  void _addUsuario(String nome, String email, String senha, String telefone,
      BuildContext context) async {
    var url = "http://localhost:8080/addusuario";

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "nome": nome,
        "email": email,
        "senha": senha,
        "telefone": telefone,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
              titulo: "Mensagem do servidor", conteudo: response.body);
        },
      );
    }
  }

  Widget campoInput(
      String label, TextEditingController controller, TextInputType tipoCampo) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
        child: TextFormField(
            keyboardType: tipoCampo,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              //errorText: validarCamposObrigatorios(controller.text),
            ),
            controller: controller,
            validator: (texto) {
              if (controller.text.isEmpty) {
                return "O campo deve ser preenchido";
              } else if (controller == telefoneController &&
                  telefoneController.text.length != 11) {
                return "O campo Telefone deve ser preenchido com um número válido de 11 dígitos";
                } else if (controller == emailController &&
                  (!(emailController.text.contains('@')) ||
                      !(emailController.text.contains('.')))) {
                return "O campo E-mail deve ser preenchido com um e-mail válido";
                
              } else if (controller == emailController) {
                _emailJaCadastrado();
                if (_usuarioExistente == true) {
                  return "Já existe usuário cadastrado com esse e-mail";
                }
              } else {
                return null;
              }
            }));
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
          validator: (texto) {
            if (controller.text.isEmpty) {
              return "O campo deve ser preenchido";
            } else if (senhaController.text != repetirSenhaController.text) {
              return "Os valores dos campos Senha e Confirmação de senha estão diferentes";
            } else {
              return null;
            }
          },
          obscureText: true,
        ));
  }
}

class MyAlertDialog extends StatelessWidget {
  final String titulo;
  final String conteudo;

  MyAlertDialog({
    this.titulo = '',
    this.conteudo = '',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.titulo,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: <Widget>[
        ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(255, 126, 107, 107)),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Login(title: 'Busca Patas - Login')));

              //Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 10.0),
            ))
      ],
      content: Text(
        conteudo,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
