import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectElementCard extends StatelessWidget {
  //same as structural_element_card_widget.dart, but with less infos, not expandable and selectable
  final String name;
  final String beneficialFor;
  final AssetImage image;
  final String type;

  const SelectElementCard(this.name, this.beneficialFor, this.image, this.type);

  @override
  Widget build(BuildContext context) {
    return const Text("DEPRICATED");
/*
    return InkWell(
      onTap: () {
        Provider.of<MapInteractionContainer>(context, listen: false).name =
            name;
        Provider.of<MapInteractionContainer>(context, listen: false).type =
            type;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddBiodiversityMeasure()));
      },
      child: Container(
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
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Gut für: $beneficialFor'),
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
        ),
      ),
    );
*/
  }
}
