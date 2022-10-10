import 'package:flutter/material.dart';

class CadastroPost extends StatefulWidget {
  const CadastroPost({super.key, required this.title});

  final String title;

  @override
  State<CadastroPost> createState() => _CadastroPostState();
}

class _CadastroPostState extends State<CadastroPost> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController repetirsenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
            title: const Text("Cadastro de Usuário"),
            centerTitle: true,
            backgroundColor:Color.fromARGB(255, 126, 107, 107)),
    
      body:SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.0, 50 , 30.0, 10.0),

          child: Column(
            children: [
              campoInput("Nome",nomeController,TextInputType.name),
              campoInput("Email",emailController,TextInputType.emailAddress),
              campoInput("Telefone",telefoneController,TextInputType.phone),
              campoInput("Senha",senhaController,TextInputType.visiblePassword),
              campoInput("Confirmar senha",repetirsenhaController,TextInputType.visiblePassword),
              
              const Padding(padding: EdgeInsets.fromLTRB(0, 20 , 0, 1.0)),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child:
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(255, 126, 107, 107)),
                      ),
                    onPressed: () {
                      _cadastrarUsuario();                  
                    },
                    child: const Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  )
              ),
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

  
  void _cadastrarUsuario(){
    if(nomeController.text.isNotEmpty && emailController.text.isNotEmpty
    && telefoneController.text.isNotEmpty && senhaController.text.isNotEmpty
    && repetirsenhaController.text.isNotEmpty
    && senhaController.text == repetirsenhaController.text){
      //Navigator.pushReplacement(context,
      //  MaterialPageRoute(builder: (context) => UsuarioCadastradoSucesso(title: 'Usuário Cadastrado com sucesso')));    
    }

  }
  
  Widget campoInput(String label, TextEditingController controller, TextInputType tipoCampo){
    return
    Padding( 
      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
      child:
      TextFormField(
        keyboardType: tipoCampo,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),       
        ),
        controller: controller,
      )
    ); 
  }

}

