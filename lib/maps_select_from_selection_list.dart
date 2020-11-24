import 'dart:developer' as logging;
import 'package:biodiversity/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class SelectElementCard extends StatefulWidget {  //same as structural_element_card_widget.dart, but with less infos, not expandable and selectable
  final String name;
  final String beneficialFor;
  final AssetImage image;
  final String type;

  const SelectElementCard(
      this.name, this.beneficialFor, this.image, this.type);

  @override
  _SelectElementCardState createState() => _SelectElementCardState();
}

class _SelectElementCardState extends State<SelectElementCard> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _tappedCard(widget.name, widget.type);
        Navigator.pop(context);
      },
      child:     Container(
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
      ),
    );
  }

  void _tappedCard(String title, String type){
    globals.chosenElement = title;
    globals.chosenElementType = type;
  }
}
