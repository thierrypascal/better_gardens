import 'package:biodiversity/components/expandable_species_element_card_widget.dart';
import 'package:biodiversity/components/simple_species_element_card_widget.dart';
import 'package:biodiversity/models/species.dart';
import 'package:biodiversity/models/species_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpeciesItemListWidget extends StatefulWidget {
  final bool useSimpleCard;

  SpeciesItemListWidget({Key key, this.useSimpleCard}) : super(key: key);

  @override
  _SpeciesItemListWidgetState createState() => _SpeciesItemListWidgetState();
}

class _SpeciesItemListWidgetState extends State<SpeciesItemListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return ItemList(widget.useSimpleCard);
        },
      ),
    );
  }
}

//TODO: create own file ItemList, together with biodiversity_item_list_widget.dart
class ItemList extends StatelessWidget {
  final bool _useSimpleCard;

  const ItemList(this._useSimpleCard, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Species> list =
    Provider.of<SpeciesService>(context).getFullSpeciesObjectList();
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
            return _useSimpleCard
                ? SimpleSpeciesElementCard(element)
                : ExpandableSpeciesElementCard(element);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 5);
          },
        ),
      ),
    );
  }
}
