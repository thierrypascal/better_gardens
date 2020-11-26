import 'package:biodiversity/screens/map_page/maps_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SubMap extends StatefulWidget {

  @override
  _SubMapState createState() => _SubMapState();
}

class _SubMapState extends State<SubMap> {
  GoogleMapController mapController;
  List<Marker> tempMarkerList = <Marker>[];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    tempMarkerList.add(Marker(
      markerId: MarkerId('temp'),
      position: LatLng(MapsPage.tappedPoint.latitude, MapsPage.tappedPoint.longitude),
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
      MapsPage.tappedPoint = tapPos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder<String>(
            future: getAddressByLocation(MapsPage.tappedPoint.latitude, MapsPage.tappedPoint.longitude),
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
                target: LatLng(MapsPage.tappedPoint.latitude, MapsPage.tappedPoint.longitude),
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
