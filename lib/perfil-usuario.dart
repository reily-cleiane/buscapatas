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
    return const Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BuscapatasNavBar(selectedIndex: 2));
  }
}
