import 'package:biodiversity/components/biodiversity_item_list_widget.dart';
import 'package:biodiversity/components/drawer.dart';
import 'package:flutter/material.dart';

class InformationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Biodiversität Massnahmen")),
        drawer: MyDrawer(),
        body: BiodiversityItemListWidget(
          useSimpleCard: false,
        ));
  }
}
