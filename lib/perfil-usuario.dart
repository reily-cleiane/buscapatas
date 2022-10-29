import 'package:flutter/material.dart';
import 'package:buscapatas/navbar.dart';

class VisualizarPerfil extends StatefulWidget {
  const VisualizarPerfil({super.key, required this.title});

  final String title;

  @override
  State<VisualizarPerfil> createState() => _VisualizarPerfilState();
}

class _VisualizarPerfilState extends State<VisualizarPerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BuscapatasNavBar(selectedIndex: 2),
      body: Column(
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
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10.0),
              child: Row(
                children: const [
                  Expanded(
                    flex: 7,
                    child: Text(
                      "Luan Gustavo Cláudio dos Santos",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('imagens/homem.jpg'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text("data"),
            ],
          )
        ],
      ),
    );
  }
}
