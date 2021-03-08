import 'package:biodiversity/components/list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionList extends StatelessWidget {
  SelectionList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lebensraum hinzufügen'),
        ),
        body: ListWidget(
          useSimpleCard: true,
          isSpeciesList: false,
        ));
  }
}
