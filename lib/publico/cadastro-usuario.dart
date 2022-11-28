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
  bool _emailUnico = false;

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
              CampoTextoCurto(
                rotulo: "Nome",
                controlador: nomeController,
                tipoCampo: TextInputType.name,
                obrigatorio: true,
              ),
              CampoTextoCurto(
                  rotulo: "Email",
                  controlador: emailController,
                  tipoCampo: TextInputType.emailAddress,
                  obrigatorio: true,
                  validador: (_) => validarEmail(context)),
              CampoTextoCurto(
                  rotulo: "Telefone(com DDD)",
                  controlador: telefoneController,
                  tipoCampo: TextInputType.phone,
                  obrigatorio: true,
                  validador: (_) => validarTelefone(context)),
              CampoTextoCurto(
                  rotulo: "Senha",
                  controlador: senhaController,
                  tipoCampo: TextInputType.visiblePassword,
                  obrigatorio: true,
                  mascarado: true,
                  validador: (_) => validarSenha(context)),
              CampoTextoCurto(
                  rotulo: "Confirmar senha",
                  controlador: repetirSenhaController,
                  tipoCampo: TextInputType.visiblePassword,
                  obrigatorio: true,
                  mascarado: true,
                  validador: (_) => validarSenha(context)),
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
      List<UsuarioModel> listaTemp =
          await UsuarioModel.getUsuariosByEmail(emailController.text);
      if (listaTemp.isEmpty) {
        _emailUnico = true;
      } else {
        _emailUnico = false;
      }
    }
    if (_formKey.currentState!.validate()) {
      String nome = nomeController.text;
      String email = emailController.text;
      String senha = senhaController.text;
      String telefone = telefoneController.text;

      _salvarUsuario(nome, email, senha, telefone, context);
    }
  }

  void _salvarUsuario(String nome, String email, String senha, String telefone,
      BuildContext context) async {
    UsuarioModel usuario = UsuarioModel(
        nome: nome, email: email, senha: senha, telefone: telefone);
    var response = await usuario.salvar();

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

  void _redirecionarPaginaAposSalvar() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login(title: 'Busca Patas - Login')));
  }

  String? validarTelefone(BuildContext context) {
    if (telefoneController.text.length != 11) {
      return "O campo Telefone deve ser preenchido com um número válido de 11 dígitos";
    }
  }

  String? validarEmail(BuildContext context) {
    if (!_emailUnico) {
      return "Já existe usuário cadastrado com esse e-mail";
    }
    String padraoEmail =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(padraoEmail);
    if (!regExp.hasMatch(emailController.text)) {
      return "O campo E-mail deve ser preenchido com um e-mail válido";
    }
    return null;
  }

  String? validarSenha(BuildContext context) {
    if (senhaController.text != repetirSenhaController.text) {
      return "Os valores dos campos Senha e Confirmação de senha estão diferentes";
    } else {
      return null;
    }
  }
}
