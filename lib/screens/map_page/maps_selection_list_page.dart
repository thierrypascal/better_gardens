import 'package:biodiversity/components/biodiversity_item_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Element auswählen'),
        ),
        body: const BiodiversityItemListWidget(
          useSimpleCard: true,
        ));
  }
}
