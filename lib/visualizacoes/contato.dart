
import 'package:buscapatas/components/animal_card.dart';
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
              backgroundColor: const Color.fromARGB(255, 126, 107, 107)),
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
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Informações de contato',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: estilo.corprimaria)),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Número de celular: ', style: TextStyle(fontSize: 16),),
                              Row(
                                children: [
                                  const Image(
                                    image: AssetImage('imagens/br.jpg'),
                                    height: 20,
                                    width: 20,
                                  ),
                                  Row(
                                    children: const [
                                      SizedBox(width: 5),
                                      Text('+55 (84) 98998-9236',style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              const Text('Email: ',style: TextStyle(fontSize: 16)),
                              const Text.rich(TextSpan(
                                text: "salsicha@gmail.com",
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                ),
                              ))
                            ],
                      ),
                  const SizedBox(height: 25),
                    ],
                  ),
                  Column(
                    children: const [
                      Text(
                        "Atividade recente",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: estilo.corprimaria),
                      ),
                      SizedBox(height: 10),
                      AnimalCard(),
                      SizedBox(height: 10),
                      AnimalCard(
                        title: "Animal encontrado",
                        details:
                            "Gente, encontrei esse cachorrinho perto da ponte, tava virando uma lata de lixo.",
                        backgroundColor: Color(0xFFD7FFE2),
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
}