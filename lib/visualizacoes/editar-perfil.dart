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

class EditarPerfil extends StatefulWidget {
  EditarPerfil({super.key, required title, required usuario}){
    this.usuario= usuario;
    this.title = title;
  }

  String title = "";
  UsuarioModel usuario = new UsuarioModel();

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  UsuarioModel usuarioLogado = UsuarioModel();
  var _passwordVisible = false;

  @override
  void initState() {
    usuarioLogado = widget.usuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title: const Text("Editar Perfil",style: TextStyle(color: Colors.white),),
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
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('imagens/homem.jpg'),
                    ),
                    Positioned(bottom: 0, right: 4,child: construirBotaoEdicao()),
                  ],
                ),
              ),
              // const SizedBox(height: 20),
              CampoTexto(label: 'Nome', 
              text: usuarioLogado.nome!, 
              tipoCampo: TextInputType.name,
              enableEdit: true,
              onChanged: (nome) => usuarioLogado = usuarioLogado.copy(nome: nome)),
              CampoTexto(label: 'Email', 
              text: usuarioLogado.email!, 
              tipoCampo: TextInputType.emailAddress,
              enableEdit: true,
              onChanged: (email) => usuarioLogado = usuarioLogado.copy(email: email)),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: usuarioLogado.telefone,
                decoration: InputDecoration(
                  labelText: "Telefone",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  suffixIcon: IconButton(icon: const Icon(Icons.edit),
                  color: estilo.corprimaria,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditarNumero(
                                title: 'Mudar número')),
                      );
                  })
                ),
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
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        estilo.corprimaria),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EsqueceuSenha(
                              title: 'Mudar senha', usuario:usuarioLogado)),
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
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        estilo.corprimaria),
                  ),
                  onPressed: () {
                    usuarioSessao.setUsuarioLogado(usuarioLogado);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VisualizarPerfil(
                              title: 'Perfil')),
                    );
                  },
                  child: const Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget construirBotaoEdicao() => construirCirculo(
        color: Colors.white,
        all: 3,
        child: construirCirculo(
          color: estilo.corprimaria,
          all: 8,
          child: const Icon(
            Icons.add_a_photo,
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