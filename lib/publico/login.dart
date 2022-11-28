import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:buscapatas/publico/esqueceu-senha.dart';
import 'package:buscapatas/publico/nao_implementado.dart';
import 'package:buscapatas/publico/cadastro-usuario.dart';
import 'package:buscapatas/home.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:buscapatas/components/campo_texto_curto.dart';

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
  bool _existeUsuario = false;

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
                ),
                CampoTextoCurto(
                    rotulo: "E-mail",
                    controlador: emailController,
                    tipoCampo: TextInputType.emailAddress,
                    obrigatorio: true,
                    validador: (_) => validarEmailSenha(context)),
                CampoTextoCurto(
                    rotulo: "Senha",
                    controlador: senhaController,
                    tipoCampo: TextInputType.visiblePassword,
                    obrigatorio: true,
                    mascarado: true,
                    validador: (_) => validarEmailSenha(context)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(estilo.corprimaria),
                      ),
                      onPressed: () {
                        _verificarCredenciais();
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
                style: TextStyle(color: estilo.corprimaria, fontSize: 20)),
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

  void _verificarCredenciais() async {
    UsuarioModel? usuarioLogado;

    List<UsuarioModel> listaUsuarioTemp = [];

    if (emailController.text.isNotEmpty && senhaController.text.isNotEmpty) {
      listaUsuarioTemp = await UsuarioModel.getUsuariosByEmailSenha(
          emailController.text, senhaController.text);
    }

    if (listaUsuarioTemp.isNotEmpty) {
      usuarioLogado = listaUsuarioTemp[0];
      _existeUsuario = true;
    } else {
      _existeUsuario = false;
    }

    if (_formKey.currentState!.validate()) {
      if (_existeUsuario) {
        await FlutterSession().set("sessao_usuarioLogado", usuarioLogado);
        _redirecionarPaginaAposLogar();
      }
    }
  }

  void _redirecionarPaginaAposLogar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Home(_existeUsuario, title: "Página inicial")),
    );
  }

  String? validarEmailSenha(BuildContext context) {
    if (senhaController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        !_existeUsuario) {
      return "Não foi possível encontrar um usuário cadastrado com esse email/senha";
    } else {
      return null;
    }
  }
}
