import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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

    tempMarkerList.add(Marker(
      markerId: MarkerId('temp'),
      position: LatLng(46, 7),          //TODO: location api, show Mitte des Screens
      onTap: (){},
    ));
    setState(() {});
  }

  void _setPosition(LatLng tapPos) {
    setState(() {
      tempMarkerList=[];
      tempMarkerList.add(Marker(
        markerId: MarkerId('temp'),
        position: tapPos,
        onTap: (){},
        draggable: true,
      ));
      Provider.of<MapInteractionContainer>(context).selectedLocation = tapPos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder<String>(
            future: getAddressByLocation(Provider.of<MapInteractionContainer>(context).selectedLocation.latitude, Provider.of<MapInteractionContainer>(context).selectedLocation.longitude),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Row(
                  children: <Widget> [
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/3,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(Provider.of<MapInteractionContainer>(context).selectedLocation.latitude, Provider.of<MapInteractionContainer>(context).selectedLocation.longitude),
                zoom: 18.0,
              ),
              zoomControlsEnabled: false,
              mapType: MapType.hybrid,
              markers: Set.from(tempMarkerList),
              onTap: _setPosition,
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getAddressByLocation(double lat, double lng) async{
    final List<Placemark> placemark = await placemarkFromCoordinates(lat, lng);

    return Future.value("${placemark[0].street}, ${placemark[0].locality}");
  }
}
