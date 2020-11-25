import 'dart:async';
import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/screens/map_page/maps_add_map_icon_widget.dart';
import 'package:biodiversity/screens/map_page/maps_show_selection_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddBiodiversityMeasure extends StatefulWidget{
  AddBiodiversityMeasure (this.location, this.bioMeasure, {Key key}) : super(key: key);
  AddBiodiversityMeasure.latLngGiven (this.location, {Key key,}) : super(key: key);
  AddBiodiversityMeasure.bioMeasureGiven (this.bioMeasure, {Key key,}) : super(key: key);

  LatLng location;
  BiodiversityMeasure bioMeasure;

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
          icon: Icon(Icons.arrow_back),
          onPressed: (){
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

                    //showSelectionList if not set, return as SingleElementCard
                    if (widget.bioMeasure == null){
                      //return SingleElementCard from SelectionList
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShowSelectionList())).then(onGoBack());


                    }else{
                      //return SingleElementCard from widget.bioMeasure
                    }
                    //show a edit icon to go back to selection

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

                    //showSubMap, if not set, display it larger
                    if (widget.location == null){
                      //show large SubMap and use camera as first location, button to save location and return
                    }else{
                      //show SubMap()
                    }
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
                      //check if location and bioElement are set, if yes, save to database and redirect to previous page
                      if (AddMapIcon.chosenElementType != null && AddMapIcon.chosenElementType != '' && MapsPage.tappedPoint != null){
                        //Add marker to map, save to db

                        //redirect to previous page
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
}
