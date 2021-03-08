import 'package:biodiversity/models/species.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// same as structural_element_card_widget.dart, but with less infos,
/// not expandable
class SimpleSpeciesElementCard extends StatelessWidget {
  //TODO: edit to be used by species
  final Species element;
  final bool goToSelectionList;

  const SimpleSpeciesElementCard(this.element,
      {this.goToSelectionList = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
/*      onTap: () {
        Provider.of<MapInteractionContainer>(context, listen: false).element =
            element;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => goToSelectionList
                    ? SelectionList()
                    : AddBiodiversityMeasure()));
      },  */ //TODO: edit to use MapInteractionContainer with Species
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          border: Border.all(
            color: const Color.fromRGBO(200, 200, 200, 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(element.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Gut für: ${element.supportedBy()}'),
                ],
              ),
            ),
            Image(
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              image: AssetImage(element.imageSource),
            ),
          ],
        ),
      ),
    );
  }
}
