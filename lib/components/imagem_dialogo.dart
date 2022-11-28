
import 'package:flutter/material.dart';

class ImagemDialogo extends StatelessWidget {

  final ImageProvider foto;

  const ImagemDialogo({
    Key? key,
    required this.foto
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: foto,
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }
}