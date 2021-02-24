import 'package:biodiversity/components/expandable_measure_element_card_widget.dart';
import 'package:biodiversity/components/simple_measure_element_card_widget.dart';
import 'package:biodiversity/fonts/icons_biodiversity_icons.dart';
import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// displays a page with all biodiversity elements
class BiodiversityItemListWidget extends StatefulWidget {
  /// whether to use extendable cards or not
  final bool useSimpleCard;

  /// if [useSimpleCard] is set, the displayed cards will not be extendable
  BiodiversityItemListWidget({Key key, this.useSimpleCard}) : super(key: key);

  @override
  _BiodiversityItemListWidgetState createState() =>
      _BiodiversityItemListWidgetState();
}

class _BiodiversityItemListWidgetState
    extends State<BiodiversityItemListWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return _itemList(context, useSimpleCard: widget.useSimpleCard);
        },
      ),
    );
  }

  Widget _itemList(BuildContext context,
      {bool useSimpleCard = false}) {
    final list = Provider.of<BiodiversityService>(context)
        .getFullBiodiversityObjectList();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: list.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Leider keine Einträge vorhanden",
                      textScaleFactor: 2,
                      textAlign: TextAlign.center,
                    ),
                    Icon(
                      Icons.emoji_nature,
                      size: 80,
                    )
                  ],
                ),
              )
            : ListView.separated(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final element = list.elementAt(index);
                  return useSimpleCard
                      ? SimpleMeasureElementCard(element)
                      : ExpandableMeasureElementCard(element);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 5);
                },
              ),
      ),
    );
  }
}
