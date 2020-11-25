import 'dart:async';

import 'package:biodiversity/screens/map_page/maps_show_selection_list.dart';
import 'package:biodiversity/screens/map_page/maps_submap_widget.dart';
import 'package:biodiversity/components/simple_element_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:biodiversity/screens/map_page/maps_page.dart';
import 'package:biodiversity/models/biodiversity_measure.dart';

class AddMapIcon extends StatefulWidget {
  AddMapIcon(
    {
    Key key,
  }) : super(key: key);

  @override
  _AddMapIconState createState() => _AddMapIconState();

  static String chosenElement = 'wähle ein Element';
  static String chosenElementType = '';
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
            AddMapIcon.chosenElement = 'wähle ein Element';    //reset statics if popup closed
            AddMapIcon.chosenElementType = '';
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlineButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ShowSelectionList()),
                            ).then(onGoBack);                                         //updates chosenElement
                          },
                          child: Text('Auswahl: ${AddMapIcon.chosenElement}', textAlign: TextAlign.left, textScaleFactor: 1.1,),
                        ),
                      ),
                    ),
                    getSelectedElementAsCard(),
                    SubMap(),
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
                      AddMapIcon.chosenElement = 'wähle ein Element';
                      AddMapIcon.chosenElementType = '';
                      Navigator.pop(context);
                    },
                    child: Text('Abbrechen'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //save to database, show on map
                      AddMapIcon.chosenElement = 'wähle ein Element';
                      AddMapIcon.chosenElementType = '';
                      Marker marker = Marker(
                          markerId: MarkerId(MapsPage.tappedPoint.toString()),
                          position: MapsPage.tappedPoint,
                          icon: MapsPage.icons["plant"]);
                      MapsPage.markerList.add(marker);
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


  Widget getSelectedElementAsCard(){        //return a structuralElementCard with the selected card
    if (AddMapIcon.chosenElementType != ''){
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('biodiversityMeasures')
              .where('type', isEqualTo: AddMapIcon.chosenElementType.toLowerCase())
              .where('name', isEqualTo: AddMapIcon.chosenElement)
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
          }
      );
    }else{
      return Text('');
    }
  }

  FutureOr onGoBack(dynamic value){
    setState((){});
  }
}
