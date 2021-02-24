import 'package:biodiversity/components/biodiversity_item_list_widget.dart';
import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/fonts/icons_biodiversity_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//TODO rename to habitatelements
class InformationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lebensräume")),
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
                      decoration: const InputDecoration(
                          labelText: 'Suchen'),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Expanded(
            child: BiodiversityItemListWidget(
              useSimpleCard: false,
            ),
          )
        ],
      ),
    );
  }
}
