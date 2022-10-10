import 'package:flutter/material.dart';

class CadastroPost extends StatefulWidget {
  const CadastroPost({super.key, required this.title});

  final String title;

  @override
  State<CadastroPost> createState() => _CadastroPostState();
}

class _CadastroPostState extends State<CadastroPost> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController racaController = TextEditingController();


  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
            title: const Text("Cadastro de Animal"),
            centerTitle: true,
            backgroundColor:Color.fromARGB(255, 126, 107, 107)),
    
      body:SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.0, 50 , 30.0, 10.0),

          child: Column(
            children: [
              campoInput("Nome do pet",nomeController,TextInputType.name),
              campoInput("Raça",racaController,TextInputType.emailAddress),
              
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
                      _cadastrarAnimal();                  
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

  
  void _cadastrarAnimal(){

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

