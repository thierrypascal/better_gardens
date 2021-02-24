import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/species_item_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SpeciesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Arten")),
      drawer: MyDrawer(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: new EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.search, size: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Suchen'),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: SpeciesItemListWidget(useSimpleCard: false)),
        ],
      ),
    );
  }
}
