import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/species_item_list_widget.dart';
import 'package:flutter/material.dart';

class SpeciesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Arten")),
        drawer: MyDrawer(),
        body: SpeciesItemListWidget(useSimpleCard: false));
  }
}
