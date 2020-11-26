import 'dart:async';

import 'package:biodiversity/components/simple_element_card_widget.dart';
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/map_marker_service.dart';
import 'package:biodiversity/screens/map_page/maps_large_submap_widget.dart';
import 'package:biodiversity/screens/map_page/maps_page.dart';
import 'package:biodiversity/screens/map_page/maps_show_selection_list.dart';
import 'package:biodiversity/screens/map_page/maps_submap_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
            Provider.of<MapInteractionContainer>(context).reset();
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    showSelectionOrShowSelected(),
                    showSubMapOrLargeSubMap(),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<MapInteractionContainer>(context).reset();
                      Navigator.pop(context);
                    },
                    child: const Text('Abbrechen'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //check if location and element is set
                      if (Provider.of<MapInteractionContainer>(context).name != '' &&
                          Provider.of<MapInteractionContainer>(context).type != '' &&
                          Provider.of<MapInteractionContainer>(context).selectedLocation != null) {
                        //TODO: save to database
                        Provider.of<MapMarkerService>(context).addMarker(Provider.of<MapInteractionContainer>(context).name, 1, Provider.of<MapInteractionContainer>(context).selectedLocation);

                        //reset statics
                        Provider.of<MapInteractionContainer>(context).reset();
                        Navigator.pop(context);
                      } else {
                        _showAlertNotSet();
                      }
                    },
                    child: Text('Speichern'),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Future<void> _showAlertNotSet() async {
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

  Widget showSelectionOrShowSelected() {
    if (Provider.of<MapInteractionContainer>(context).type == '') {
      //redirect to Selection
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowSelectionList()),
        ).then(onGoBack);
      });
      if (Provider.of<MapInteractionContainer>(context).name == ''){
        Navigator.pop(context);   //TODO: TEST IF WORKING
      }
    }
    return getSelectedElementAsCard();
  }

  Widget showSubMapOrLargeSubMap() {
    if (Provider.of<MapInteractionContainer>(context).selectedLocation == null) {
      //show big SubMap to set location
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LargeSubMap()),
        ).then(onGoBack);
      });
    }
    return SubMap();
  }

  Widget getSelectedElementAsCard() {
    //return a structuralElementCard with the selected card
    if (Provider.of<MapInteractionContainer>(context).type != '') {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('biodiversityMeasures')
              .where('type',
                  isEqualTo:
                    Provider.of<MapInteractionContainer>(context).type.toLowerCase())
              .where('name', isEqualTo: Provider.of<MapInteractionContainer>(context).name)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<BiodiversityMeasure> list = [];
            for (final DocumentSnapshot in snapshot.data.docs) {
              list.add(BiodiversityMeasure.fromSnapshot(DocumentSnapshot));
            }
            final BiodiversityMeasure chElement = list
                .first; //extract first element, because it will only be one element; TODO: make that function use a single element, not a list

            final beneficialFor = StringBuffer();
            beneficialFor.write(chElement.beneficialFor.keys);

            return SimpleElementCard(
                chElement.name,
                beneficialFor.toString().trim(),
                AssetImage(chElement.imageSource),
                chElement.description);
          });
    } else {
      return const Text('');
    }
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}
