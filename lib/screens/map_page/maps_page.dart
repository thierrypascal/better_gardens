import 'dart:async';
import 'dart:developer' as logging;
import 'file:///C:/Users/gabri/ip34/mobile-front-end/lib/components/drawer.dart';
import 'file:///C:/Users/gabri/ip34/mobile-front-end/lib/screens/map_page/maps_add_map_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';

class MapsPage extends StatefulWidget {
  const MapsPage(
    this.latitude,
    this.longitude, {
    Key key,
  }) : super(key: key);
  final double latitude;
  final double longitude;

  @override
  _MapsPageState createState() => _MapsPageState();

}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;
  List<Marker> markerList = <Marker>[];
  LatLng tappedPoint = LatLng(46.9472, 7.4512);

  void addToMarkerList(Marker marker){
    markerList.add(marker);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      drawer: MyDrawer(),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14.0,
        ),
        compassEnabled: true,
        zoomControlsEnabled: false,
        mapType: MapType.hybrid,
        markers: Set.from(markerList),
        onTap: _setPosition,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAddMapIcon(context)    //opens selection page
          .then(onGoBack);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  _navigateAddMapIcon(BuildContext context) async{
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMapIcon(tappedPoint)),
    ) as Marker;

    markerList.add(result);
  }

  void _setPosition(LatLng tapPos) {
    tappedPoint = tapPos;
  }

  FutureOr onGoBack(dynamic value){
    markerList = markerList;
    setState((){});
  }
}
