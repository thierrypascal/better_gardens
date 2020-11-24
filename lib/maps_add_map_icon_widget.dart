import 'dart:async';
import 'dart:developer' as logging;
import 'package:biodiversity/globals.dart' as globals;
import 'package:biodiversity/maps_submap_widget.dart';
import 'package:biodiversity/strucural_element_card_widget.dart';
import 'package:biodiversity/maps_show_selection_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';



class AddMapIcon extends StatefulWidget {
  AddMapIcon({Key key,}) : super(key: key);

  @override
  _AddMapIconState createState() => _AddMapIconState();
}


class _AddMapIconState extends State<AddMapIcon>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Element hinzufügen'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            globals.chosenElement = 'wähle ein Element';    //reset globals if popup closed
            globals.chosenElementType = null;
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShowSelectionList()),    //opens selectionList
                        ).then(onGoBack);                                         //updates globals.chosenElement
                      },
                      child: Text('Auswahl: ${globals.chosenElement}'),
                    ),
                    getSelectedElementAsCard(),
                    FutureBuilder<String>(          //catch geocode
                      future: getAddressByLocation(globals.tappedPoint),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Text('Standort: ${snapshot.data}');
                      },
                    ),
                    SubMap(globals.tappedPoint.latitude, globals.tappedPoint.longitude),
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
                      globals.chosenElement = 'wähle ein Element';
                      globals.chosenElementType = null;
                      Navigator.pop(context);
                    },
                    child: Text('Abbrechen'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //save to database, show on map
                      setState(() {
                        globals.markerList.add(Marker(
                          markerId: MarkerId(globals.tappedPoint.toString()), //if tappedPoint is null, use current camera location
                          position: globals.tappedPoint,
                        ));
                      });
                      globals.chosenElement = 'wähle ein Element';
                      globals.chosenElementType = null;
                      Navigator.pop(context);
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

  Future<String> getAddressByLocation(LatLng location) async{
    final List<Placemark> placemark = await placemarkFromCoordinates(location.latitude, location.longitude);

    return Future.value("${placemark[0].street}, ${placemark[0].postalCode} ${placemark[0].locality}");
  }

  Widget getSelectedElementAsCard(){        //return a structuralElementCard with the selected card
    if (globals.chosenElementType != null){
      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('biodiversityMeasures')
              .where('type', isEqualTo: globals.chosenElementType.toLowerCase())
              .where('name', isEqualTo: globals.chosenElement)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<BiodiversityMeasure> list = [];
            for (final DocumentSnapshot in snapshot.data.documents) {
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
    globals.chosenElement = globals.chosenElement;
    globals.chosenElementType = globals.chosenElementType;
    setState((){});
  }
}
