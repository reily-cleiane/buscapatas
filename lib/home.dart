import 'package:flutter/material.dart';
import 'package:buscapatas/publico/login.dart';
import 'package:buscapatas/cadastros/cadastro-post.dart';

//OBS: Essa página é temporária e está simulando a página inicial
class Home extends StatefulWidget {
  bool autorizado;
  Home(bool usuario,{super.key, required this.title}):  this.autorizado = usuario;
   
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState(){
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    if(!widget.autorizado){
      return Login(title: 'Busca Patas - Login');
    } else{
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text("Busca Patas"),
            centerTitle: true,
            backgroundColor:const Color.fromARGB(255, 126, 107, 107)),
    
        body:SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30.0, 50 , 30.0, 10.0),
          child: Column(
            children: <Widget>[
              const Text("Página inicial ainda não implementada", style: TextStyle(color: Color.fromARGB(255, 126, 107, 107),fontSize: 20)),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 126, 107, 107)),
                  ),
                  onPressed: () {
                    _cadastrarAnimal();
                  },
                  child: const Text(
                    "Cadastrar Animal",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )
                ),
            ],
          ),
        )

      );
    }
  }

  void _cadastrarAnimal() {

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CadastroPost(title: "Cadastrar Animal")),
    );
  }

}
