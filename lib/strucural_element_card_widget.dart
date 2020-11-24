import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StructuralElementCard extends StatelessWidget {
  final String name;
  final String beneficialFor;
  final AssetImage image;
  final String description;

  const StructuralElementCard(
      this.name, this.beneficialFor, this.image, this.description);

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
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Gut für: $beneficialFor"),
              ],
            ),
            Image(
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              image: image,
            ),
          ],
        ),
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                ),
              ))
        ],
      ),
    );
  }
}
