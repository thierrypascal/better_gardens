import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LargeSubMap extends StatefulWidget {
  @override
  _LargeSubMapState createState() => _LargeSubMapState();
}

class _LargeSubMapState extends State<LargeSubMap> {
  GoogleMapController mapController;
  List<Marker> tempMarkerList = <Marker>[];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    Provider.of<MapInteractionContainer>(context).selectedLocation =
        const LatLng(46, 7); //set middle of screen as selectedLocation

    tempMarkerList.add(Marker(
      markerId: MarkerId('temp'),
      position: Provider.of<MapInteractionContainer>(context).selectedLocation,
      onTap: () {},
    ));
    setState(() {});
  }

  void _setPosition(LatLng tapPos) {
    setState(() {
      tempMarkerList = [];
      tempMarkerList.add(Marker(
        markerId: MarkerId('temp'),
        position: tapPos,
        onTap: () {},
        draggable: true,
      ));
      Provider
          .of<MapInteractionContainer>(context)
          .selectedLocation = tapPos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Position auswählen')),
      body: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FutureBuilder<String>(
              future: Provider.of<MapInteractionContainer>(context)
                  .getAddressOfSelectedLocation(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    children: <Widget>[
                      const Flexible(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 40, 0),
                          child: Icon(Icons.location_on),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          snapshot.data.toString(),
                          //so it's not empty while loading
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: Provider
                      .of<MapInteractionContainer>(context)
                      .selectedLocation,
                  zoom: 18.0,
                ),
                zoomControlsEnabled: false,
                mapType: MapType.hybrid,
                markers: Set.from(tempMarkerList),
                onTap: _setPosition,
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
                      Navigator.pop(context);
                    },
                    child: const Text('Speichern'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
