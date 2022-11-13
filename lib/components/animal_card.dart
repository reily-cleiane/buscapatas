import 'package:flutter/material.dart';

class AnimalCard extends StatefulWidget {
  const AnimalCard({
    super.key,
    this.title = "Cachorrinho desaparecido",
    this.details =
        "Gente por favor me ajudem! Meu cachorrinho viu o portão de casa aberto e fugiu",
    this.timestamp = "Postado há 3h",
    this.distance = 10,
    this.backgroundColor = const Color(0xFFFFA7A7),
    this.image = 'imagens/animal.jpg',
  });

  const AnimalCard.avistado({
    super.key,
    this.title = "Cachorrinho desaparecido",
    this.details =
        "Gente por favor me ajudem! Meu cachorrinho viu o portão de casa aberto e fugiu",
    this.timestamp = "Postado há 3h",
    this.distance = 10,
    this.backgroundColor = const Color(0xFFA7FFA7),
    this.image = 'imagens/animal.jpg',
  });

  final String title;
  final String details;
  final String timestamp;
  final String image;
  final int distance;
  final Color backgroundColor;

  @override
  AnimalCardState createState() => AnimalCardState();
}

class AnimalCardState extends State<AnimalCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(widget.image),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.timestamp,
                            style: const TextStyle(fontWeight: FontWeight.w200),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(widget.details),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "A ${widget.distance}m de você",
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.location_on)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
