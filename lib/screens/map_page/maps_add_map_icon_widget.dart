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
                      //check if location and element is set
                      if (AddMapIcon.chosenElementType != null && AddMapIcon.chosenElementType != '' && MapsPage.tappedPoint != null){
                        //TODO: save to database
                        Marker marker = Marker(
                            markerId: MarkerId(MapsPage.tappedPoint.toString()),
                            position: MapsPage.tappedPoint,
                            icon: MapsPage.icons[AddMapIcon.chosenElementType.toLowerCase()]);
                        MapsPage.markerList.add(marker);

                        //reset statics
                        AddMapIcon.chosenElement = 'wähle ein Element';
                        AddMapIcon.chosenElementType = '';
                        Navigator.pop(context);
                      }else{
                        _showAlertNotSet();
                      }
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

  Future<void> _showAlertNotSet() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Achtung'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Der Standort oder das Element wurde noch nicht erfasst.'),
                const Text('Beides muss erfasst sein, um einen neuen Karteneintrag zu machen.'),
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
