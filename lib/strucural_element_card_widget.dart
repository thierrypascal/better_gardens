import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StructuralElementCard extends StatefulWidget {
  final String name;
  final String beneficialFor;
  final AssetImage image;
  final String description;

  const StructuralElementCard(
      this.name, this.beneficialFor, this.image, this.description);

  @override
  _StructuralElementCardState createState() => _StructuralElementCardState();
}

class _StructuralElementCardState extends State<StructuralElementCard> {
  bool extended = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(
          color: const Color.fromRGBO(200, 200, 200, 1),
        ),
      ),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Gut für: ${widget.beneficialFor}"),
              ],
            ),
            Image(
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              image: widget.image,
            ),
          ],
        ),
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.description,
                  textAlign: TextAlign.left,
                ),
              ))
        ],
      ),
    );
  }
}
