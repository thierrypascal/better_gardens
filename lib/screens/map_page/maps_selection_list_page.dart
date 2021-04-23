import 'package:biodiversity/components/information_object_list_widget.dart';
import 'package:biodiversity/services/service_provider.dart';
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
        body: InformationObjectListWidget(
          objects: ServiceProvider.instance.biodiversityService
              .getFullBiodiversityObjectList(),
          useSimpleCard: true,
        ));
  }
}
