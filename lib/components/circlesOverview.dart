import 'package:biodiversity/models/garden.dart';
import 'package:flutter/material.dart';

/// Displays four circles with a number in each as overview
class CirclesOverview extends StatelessWidget {
  ///passed buildcontext
  final BuildContext context;

  ///the garden of which the information needs to be displayed
  final Garden garden;

  ///constructor
  CirclesOverview(this.context, this.garden, {Key key}) : super(key: key);

  //TODO: adapt text for better understanding
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createCircle('${garden.totalAreaObjects}', 'Flächen (m2)'),
            ],
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            _createCircle('${garden.totalLengthObjects}', ' Längen (m)')
          ]),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createCircle(
                  '${garden.totalPointObjects}', 'Punktobjekt (Anzahl)'),
            ],
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            _createCircle(
                '${garden.totalSupportedSpecies}', 'Geförderte Arten (Anzahl)')
          ]),
        ],
      )
    ]);
  }

  Widget _createCircle(String number, String text) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              shape: BoxShape.circle,
              // You can use like this way or like the below line
              //borderRadius: new BorderRadius.circular(30.0),
              color: Colors.white,
            ),
            child: Center(child: Text(number, style: const TextStyle(fontSize: 20.0))),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(text, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center,),
          )
        ],
      ),
    );
  }
}
