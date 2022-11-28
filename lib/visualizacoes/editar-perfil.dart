import 'dart:io';
import 'dart:convert';
import 'package:buscapatas/components/caixa_dialogo_alerta.dart';
import 'package:buscapatas/components/campo-texto.dart';
import 'package:buscapatas/model/test-user.dart';
import 'package:buscapatas/model/UsuarioModel.dart';
import 'package:buscapatas/perfil_usuario.dart';
import 'package:buscapatas/publico/esqueceu-senha.dart';
import 'package:buscapatas/visualizacoes/editar-numero.dart';
import 'package:buscapatas/utils/mock_usuario.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;
import 'package:flutter/services.dart';
import 'package:buscapatas/utils/usuario_logado.dart' as usuarioSessao;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class EditarPerfil extends StatefulWidget {
  EditarPerfil({super.key, required title, required usuario}) {
    this.usuario = usuario;
    this.title = title;
  }

  String title = "";
  UsuarioModel usuario = new UsuarioModel();

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  File? imageTest;

  UsuarioModel usuarioLogado = UsuarioModel();

  var _passwordVisible = false;

  @override
  void initState() {
    carregarUsuarioLogado();
  }

  void carregarUsuarioLogado() async {
    await usuarioSessao
        .getUsuarioLogado()
        .then((value) => usuarioLogado = value);
    //Necessário para recarregar a página após ter pegado o valor de usuarioLogado
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Editar Perfil",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: estilo.corprimaria),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: Ink.image(
                          image: (imageTest != null)
                              ? FileImage(imageTest!) as ImageProvider
                              : NetworkImage(
                                  'https://buscapatas.s3.sa-east-1.amazonaws.com/usuario-foto-padrao.png'),
                          fit: BoxFit.cover,
                          width: 128,
                          height: 128,
                          child: InkWell(onTap: () {
                            mostrarDialogo(context);
                          }),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0, right: 4, child: construirBotaoEdicao()),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CampoTexto(
                  label: 'Nome',
                  text: usuarioLogado.nome!,
                  tipoCampo: TextInputType.name,
                  enableEdit: true,
                  onChanged: (nome) =>
                      usuarioLogado = usuarioLogado.copy(nome: nome)),
              CampoTexto(
                  label: 'Email',
                  text: usuarioLogado.email!,
                  tipoCampo: TextInputType.emailAddress,
                  enableEdit: true,
                  onChanged: (email) =>
                      usuarioLogado = usuarioLogado.copy(email: email)),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: usuarioLogado.telefone,
                decoration: InputDecoration(
                    labelText: "Telefone",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.edit),
                        color: estilo.corprimaria,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditarNumero(title: 'Mudar número')),
                          );
                        })),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: usuarioLogado.senha,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: estilo.corprimaria,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_passwordVisible,
                readOnly: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(estilo.corprimaria),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EsqueceuSenha(
                                title: 'Mudar senha', usuario: usuarioLogado)),
                      );
                    },
                    child: const Text(
                      "Mudar Senha",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  )),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(estilo.corprimaria),
                    ),
                    onPressed: () {
                      usuarioSessao.setUsuarioLogado(usuarioLogado);
                      _atualizarUsuario(context);
                    },
                    child: const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _atualizarUsuario(BuildContext context) async {
    var url =
        'http://buscapatasbackend-env-1.eba-buvmp5kg.sa-east-1.elasticbeanstalk.com/users';

    http.MultipartRequest request =
        http.MultipartRequest('PUT', Uri.parse(url));

    request.fields['jsondata'] = jsonEncode(usuarioLogado);
    var length = 1;
    var fileType;
    if (imageTest != null) {
      length = await imageTest!.length();

      var stream = new http.ByteStream(imageTest!.openRead());
      stream.cast();

      String? mimeStr = lookupMimeType(imageTest!.path);
      fileType = mimeStr!.split('/');

      var multipart = await http.MultipartFile.fromPath('file', imageTest!.path,
          contentType: new MediaType('image', fileType[0]));
      request.files.add(multipart);
    }

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return CaixaDialogoAlerta(
              titulo: "Mensagem do servidor",
              conteudo: responsed.body,
              funcao: _redirecionarPaginaAposSalvar);
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return CaixaDialogoAlerta(
              titulo: "Mensagem do servidor problema",
              conteudo: responsed.body,
              funcao: _redirecionarPaginaAposSalvar);
        },
      );
    }
  }

  void _redirecionarPaginaAposSalvar() {
    Navigator.push(
      context as BuildContext,
      MaterialPageRoute(
          builder: (context) => VisualizarPerfil(title: 'Perfil')),
    );
  }

  void mostrarDialogo(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Selecione uma das opções"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                pegarImagem(ImageSource.camera);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.add_a_photo,
                    size: 18,
                    color: estilo.corprimaria,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0.0),
                    child: InkWell(
                        child: Ink(
                      child: RichText(
                        text: const TextSpan(
                          text: "Tirar Foto",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                pegarImagem(ImageSource.gallery);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.add_photo_alternate,
                    size: 18,
                    color: estilo.corprimaria,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0.0),
                    child: InkWell(
                        child: Ink(
                      child: RichText(
                        text: const TextSpan(
                          text: "Selecionar da galeria",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ],
        );
      });

  Future pegarImagem(ImageSource source) async {
    try {
      final imagem = await ImagePicker.pickImage(source: source);
      if (imagem == null) return;

      final imagemTemporaria = File(imagem.path);
      setState(() => imageTest = imagemTemporaria);
    } on PlatformException catch (e) {
      print('Não conseguiu pegar a imagem: $e');
    }
  }

  Widget construirBotaoEdicao() => construirCirculo(
        color: Colors.white,
        all: 3,
        child: construirCirculo(
          color: estilo.corprimaria,
          all: 8,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 15,
          ),
        ),
      );

  Widget construirCirculo({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
