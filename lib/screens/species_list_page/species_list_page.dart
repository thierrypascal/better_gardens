import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/list_widget.dart';
import 'package:flutter/material.dart';

/// Page where all Species are listed
class SpeciesListPage extends StatelessWidget {
  /// Page where all Species are listed
  SpeciesListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arten')),
      drawer: MyDrawer(),
      body: ListWidget(
        useSimpleCard: false,
        isSpeciesList: true,
        isGardenList: false,
      ),
    );
  }
}
