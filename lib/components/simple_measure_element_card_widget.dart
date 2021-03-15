import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/screens/map_page/maps_add_biodiversity_measure_page.dart';
import 'package:biodiversity/screens/map_page/maps_selection_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// same as structural_element_card_widget.dart, but with less infos,
/// not expandable
class SimpleMeasureElementCard extends StatelessWidget {
  /// the [BiodiversityMeasure] element to display
  final BiodiversityMeasure element;

  /// if on tap onto the element the page should be redirected to SelectionList
  final bool goToSelectionList;

  /// Non expandable ListTile, displaying a [BiodiversityMeasure]
  const SimpleMeasureElementCard(this.element,
      {this.goToSelectionList = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<MapInteractionContainer>(context, listen: false).element =
            element;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => goToSelectionList
                    ? SelectionList()
                    : AddBiodiversityMeasure()));
      },
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
                  Text('Gut für: ${element.beneficialFor}'),
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
