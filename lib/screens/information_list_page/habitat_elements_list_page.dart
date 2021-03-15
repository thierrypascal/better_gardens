import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/list_widget.dart';
import 'package:flutter/material.dart';

class HabitatElementListPage extends StatelessWidget {
  HabitatElementListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lebensräume')),
      drawer: MyDrawer(),
      body: ListWidget(
        useSimpleCard: false,
        isSpeciesList: false,
      ),
    );
  }
}
