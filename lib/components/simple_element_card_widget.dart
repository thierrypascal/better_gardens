import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleElementCard extends StatefulWidget {  //same as structural_element_card_widget.dart, but with less infos, not expandable
  final String name;
  final String beneficialFor;
  final AssetImage image;
  final String type;

  const SimpleElementCard(
      this.name, this.beneficialFor, this.image, this.type);

  @override
  _SimpleElementCardState createState() => _SimpleElementCardState();
}

class _SimpleElementCardState extends State<SimpleElementCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(
          color: const Color.fromRGBO(200, 200, 200, 1),
        ),
      ),
      child: ListTile(
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
                Text('Gut für: ${widget.beneficialFor}'),
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
      ),
    );
  }
}
