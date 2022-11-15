
import 'package:buscapatas/components/animal_card.dart';
import 'package:buscapatas/visualizacoes/info-post-avistado.dart';
import 'package:buscapatas/visualizacoes/info-post-perdido-avistar.dart';
import 'package:flutter/material.dart';
import 'package:buscapatas/componentes-interface/estilo.dart' as estilo;

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key, required this.title});

  final String title;
  
  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title: const Text("Visualizar Perfil",style: TextStyle(color: Colors.white),),
              centerTitle: true,
              foregroundColor: Colors.white,
              backgroundColor: estilo.corprimaria),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 7,
                      child: Text(
                        "Norville Rogers",
                        style: TextStyle(fontSize: 24, color: estilo.corprimaria),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('imagens/salsicha.jpg'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Informações de contato',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: estilo.corprimaria)),
                      SizedBox(height: 5),
                      Text('Número de celular: ', style: TextStyle(fontSize: 16),),
                      SizedBox(width: 5),
                      Text('(84)989989236',style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10,),
                      Text('Email: ',style: TextStyle(fontSize: 16)),
                      Text.rich(TextSpan(
                        text: "salsicha@gmail.com",
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      )),
                      SizedBox(height: 25),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Atividade recente",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: estilo.corprimaria),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                          child: Column(
                            children: [
                              creatCard ("Cachorrinho desaparecido",
                              "Preciso de ajuda para achar meu cachorrinho!", 
                              estilo.corperdido,
                              const InfoPostPerdidoAvistar(title: "Animal Avistado")),
                              creatCard ("Cachorro avistado",
                              "Gente, encontrei esse cachorrinho perto da ponte, tava virando uma lata de lixo.",
                              estilo.coravistado,
                              const InfoPostAvistado(title: "Animal Perdido"))
                            ],
                          ) 
                      ),
                    ],
                  )
                  
                ],
              ),
              
            ),
          ],
        ),
      ),
    );
  }
  Widget creatCard (String texto, String mensagem, Color cor, infoPost) {
    return Card(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide.none,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => infoPost),
          );
        },
        child: AnimalCard.avistado(
          title: texto,
          details: mensagem,
          backgroundColor: cor,
        ),
      ));
  }
}