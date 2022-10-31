import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  //final ValueChanged<String> onChanged;

  const CampoTexto({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    //required this.onChanged,
  }) : super(key: key);

  @override
  _CampoTextoState createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: widget.label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            maxLines: widget.maxLines,
          ),
        ],
      );
}