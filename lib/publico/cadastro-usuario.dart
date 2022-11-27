import 'dart:convert';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/components/caixa_dialogo_alerta.dart';
import 'package:buscapatas/components/campo_texto_curto.dart';
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
          foregroundColor: Colors.white,
          backgroundColor: estilo.corprimaria),
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
              CampoTextoCurto(
                  rotulo: "Senha",
                  controlador: senhaController,
                  tipoCampo: TextInputType.visiblePassword,
                  obrigatorio: true,
                  mascarado: true,
                  validador: (_) => _validarSenha(context)),
              CampoTextoCurto(
                  rotulo: "Confirmar senha",
                  controlador: repetirSenhaController,
                  tipoCampo: TextInputType.visiblePassword,
                  obrigatorio: true,
                  mascarado: true,
                  validador: (_) => _validarSenha(context)),

              const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 1.0)),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(estilo.corprimaria),
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
    if (emailController.text.isNotEmpty) {
      _usuarioExistente = await _verificarEmailJaCadastrado();
    }
    if (_formKey.currentState!.validate()) {
      String nome = nomeController.text;
      String email = emailController.text;
      String senha = senhaController.text;
      String telefone = telefoneController.text;

      _addUsuario(nome, email, senha, telefone, context);
    }
  }

  Future<bool> _verificarEmailJaCadastrado() async {
    //Refatorar para o método ficar em UsuarioModel e não aqui
    var url = UsuarioModel.getUrlFindByEmail(emailController.text);
    //http.Response response = await http.get(Uri.parse(url));

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    bool _jaExisteUsuario = false;

    if (response.statusCode == 200) {
      var resposta = json.decode(response.body);

      for (var usuario in resposta) {
        if (usuario['email'].isNotEmpty) {
          _jaExisteUsuario = true;
          break;
        }
      }
      //print(jsonDecode(response.body));
    } else {
      throw Exception('Falha no servidor ao carregar usuários');
    }

    if (_jaExisteUsuario) {
      setState(() {
        _usuarioExistente = true;
      });
      return true;
    } else {
      setState(() {
        _usuarioExistente = false;
      });
      return false;
    }
  }

  void _addUsuario(String nome, String email, String senha, String telefone,
      BuildContext context) async {
    //Refatorar para o método ficar em UsuarioModel e não aqui
    var url = UsuarioModel.getUrlSalvarUsuario();

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
          return CaixaDialogoAlerta(
              titulo: "Mensagem do servidor",
              conteudo: response.body,
              funcao: _redirecionarPaginaAposSalvar);
        },
      );
    }
  }

  void _redirecionarPaginaAposSalvar() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login(title: 'Busca Patas - Login')));
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
              } else if (controller == emailController) {
                if (_usuarioExistente == true) {
                  return "Já existe usuário cadastrado com esse e-mail";
                }
                String padraoEmail =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(padraoEmail);
                if (!regExp.hasMatch(emailController.text)) {
                  return "O campo E-mail deve ser preenchido com um e-mail válido";
                }
              } else if (controller == emailController) {
              } else {
                return null;
              }
            }));
  }

  String? _validarSenha(BuildContext context) {
    if (senhaController.text != repetirSenhaController.text) {
      return "Os valores dos campos Senha e Confirmação de senha estão diferentes";
    } else {
      return null;
    }
  }
}
