import 'dart:async';

import 'package:biodiversity/components/simple_element_card_widget.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/map_marker_service.dart';
import 'package:biodiversity/screens/map_page/maps_page.dart';
import 'package:biodiversity/screens/map_page/maps_selection_list_page.dart';
import 'package:biodiversity/screens/map_page/maps_submap_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBiodiversityMeasure extends StatefulWidget {
  AddBiodiversityMeasure({
    Key key,
  }) : super(key: key);

  @override
  _AddBiodiversityMeasureState createState() => _AddBiodiversityMeasureState();
}

class _AddBiodiversityMeasureState extends State<AddBiodiversityMeasure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Element hinzufügen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<MapInteractionContainer>(context, listen: false)
                .reset();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<MapInteractionContainer>(
                    builder: (context, selection, child) {
                      if (selection.element == null) {
                        return ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectionList())),
                          child: const Text("Element auswählen"),
                        );
                      } else {
                        return SimpleElementCard(selection.element);
                      }
                    },
                  ),
                  SubMap(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<MapInteractionContainer>(context,
                              listen: false)
                          .reset();
                      Navigator.pop(context);
                    },
                    child: const Text('Abbrechen'),
                  ),
                  ElevatedButton(
                    onPressed: _onSaveButton,
                    child: const Text('Speichern'),
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  Future<void> _showAlertNotSet() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Achtung'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Der Standort oder das Element wurde noch nicht erfasst.'),
                Text(
                    'Beides muss erfasst sein, um einen neuen Karteneintrag zu machen.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Verstanden'),
            ),
          ],
        );
      },
    );
  }

  void _onSaveButton() {
    if (Provider
        .of<MapInteractionContainer>(context, listen: false)
        .element !=
        null) {
      Provider.of<MapMarkerService>(context, listen: false).addMarker(
          Provider
              .of<MapInteractionContainer>(context, listen: false)
              .element
              .name,
          1,
          Provider
              .of<MapInteractionContainer>(context, listen: false)
              .selectedLocation);

      //reset statics
      Provider.of<MapInteractionContainer>(context, listen: false).reset();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapsPage()),
      );
    } else {
      _showAlertNotSet();
    }
  }
}