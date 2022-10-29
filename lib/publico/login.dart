import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/publico/esqueceu-senha.dart';
import 'package:buscapatas/publico/nao-implementado.dart';
import 'package:buscapatas/publico/cadastro-usuario.dart';
import 'package:buscapatas/home.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _usuarioAutorizado = false;

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
      padding: const EdgeInsets.fromLTRB(30.0, 10, 30.0, 10.0),
      child: Column(
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(children: <Widget>[
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
                  child: campoInput("E-mail", emailController,
                      TextInputType.emailAddress, false),
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
                            estilo.corprimaria),
                      ),
                      onPressed: () {
                        _entrar();
                      },
                      child: const Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    )),
              ])),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20.0, 0, 15.0),
            child: Text("OU",
                style: TextStyle(
                    color: estilo.corprimaria, fontSize: 20)),
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
                  "imagens/entrar-com-google.png",
                  fit: BoxFit.contain,
                  width: 180,
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
                            color: estilo.corprimaria,
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
                  color: estilo.corprimaria,
                  fontSize: 16.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Cadastre-se',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: estilo.corprimaria,
                        fontSize: 16.0,
                      )),
                  // can add more TextSpans here...
                ],
              ))),
            ),
          )
        ],
      ),
    ));
  }

  void _entrar() async {
    UsuarioModel? usuarioLogado;
    if (emailController.text.isNotEmpty && senhaController.text.isNotEmpty) {
      usuarioLogado = await _verificarUsuarioAutorizado();
    }

    if (_formKey.currentState!.validate()) {
      if(_usuarioAutorizado){
        await FlutterSession().set("sessao_usuarioLogado", usuarioLogado);
      }
      
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Home(_usuarioAutorizado, title: "Página inicial")),
      );
    }
    
  }

  Future<UsuarioModel?> _verificarUsuarioAutorizado() async {
    var url =
        "http://localhost:8080/usuarioautorizado?email=${emailController.text}&senha=${senhaController.text}";

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    UsuarioModel? usuarioLogado;

    if (response.statusCode == 200) {
      var resposta = json.decode(response.body);
      
      for (var usuario in resposta) {
        if (usuario['email'].isNotEmpty) {
          usuarioLogado = UsuarioModel(
              id: usuario['id'],
              nome: usuario['nome'],
              email: usuario['email'],
              senha: usuario['senha'],
              telefone: usuario['telefone']);
          setState(() {
            _usuarioAutorizado = true;
          });
          break;
        }
      }
      //print(jsonDecode(response.body));
    } else {
      throw Exception('Falha no servidor ao carregar usuários');
    }
    return usuarioLogado;
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
      validator: (texto) {
        if (controller.text.isEmpty) {
          return "O campo deve ser preenchido";
        } else if (!_usuarioAutorizado) {
          return "Não foi possível encontrar um usuário cadastrado com esse email/senha";
        } else {
          return null;
        }
      },
      obscureText: oculto,
    );
  }
}
