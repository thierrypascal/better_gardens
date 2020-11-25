import 'dart:async';

import 'package:biodiversity/maps_show_selection_list.dart';
import 'package:biodiversity/maps_submap_widget.dart';
import 'package:biodiversity/strucural_element_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddMapIcon extends StatefulWidget {
  final LatLng tappedPosition;

  AddMapIcon(
    this.tappedPosition, {
    Key key,
  }) : super(key: key);

  @override
  _AddMapIconState createState() => _AddMapIconState();
}

class _AddMapIconState extends State<AddMapIcon>{
  String chosenElement = 'wähle ein Element';
  String chosenElementType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Element hinzufügen'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            chosenElement = 'wähle ein Element';    //reset globals if popup closed
            chosenElementType = null;
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
                  children: <Widget> [
                    ElevatedButton(
                      onPressed: () {
                        _navigateShowSelectionList(context)
                        .then(onGoBack);                                         //updates chosenElement
                      },
                      child: Text('Auswahl: ${chosenElement}'),
                    ),
                    getSelectedElementAsCard(),
                    FutureBuilder<String>(          //catch geocode
                      future: getAddressByLocation(widget.tappedPosition),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Text('Standort: ${snapshot.data}');
                      },
                    ),
                    SubMap(widget.tappedPosition.latitude, widget.tappedPosition.longitude),
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
                      chosenElement = 'wähle ein Element';
                      chosenElementType = null;
                      Navigator.pop(context);
                    },
                    child: Text('Abbrechen'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //save to database, show on map
                      chosenElement = 'wähle ein Element';
                      chosenElementType = null;
                      Marker marker = Marker(markerId: MarkerId(widget.tappedPosition.toString()), position: widget.tappedPosition);
                      Navigator.pop(context, marker);
                    },
                    child: Text('Speichern'),
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }

  _navigateShowSelectionList(BuildContext context) async{
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowSelectionList()),
    ) as List<String>;

    chosenElement = result.first;
    chosenElementType = result.last;
  }

  Future<String> getAddressByLocation(LatLng location) async{
    final List<Placemark> placemark = await placemarkFromCoordinates(location.latitude, location.longitude);

    return Future.value("${placemark[0].street}, ${placemark[0].postalCode} ${placemark[0].locality}");
  }

  Widget getSelectedElementAsCard(){        //return a structuralElementCard with the selected card
    if (chosenElementType != null){
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('biodiversityMeasures')
              .where('type', isEqualTo: chosenElementType.toLowerCase())
              .where('name', isEqualTo: chosenElement)
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

            return StructuralElementCard(
                chElement.name,
                beneficialFor.toString().trim(),
                AssetImage(chElement.imageSource),
                chElement.description);
          }
      );
    }else{
      return Text('');
    }
  }

  FutureOr onGoBack(dynamic value){
    chosenElement = chosenElement;
    chosenElementType = chosenElementType;
    setState((){});
  }
}
