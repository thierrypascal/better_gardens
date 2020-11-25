import 'dart:async';

import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/screens/map_page/maps_add_map_icon_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  static LatLng tappedPoint = LatLng(46.948915, 7.445423);
  static List<Marker> markerList = new List<Marker>();
  static Map<String, BitmapDescriptor> icons = new Map<String, BitmapDescriptor>();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;

  void addToMarkerList(Marker marker){
    MapsPage.markerList.add(marker);
  }
  
  @override
  void initState() {
    super.initState();
    initCustomIconMap();
  }
  
  void initCustomIconMap() async{
    final BitmapDescriptor structureIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'res/structureIcon.png');
    final BitmapDescriptor plantIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'res/plantIcon.png');
    final BitmapDescriptor methodIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'res/methodIcon.png');
    final BitmapDescriptor wishIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'res/wishIcon.png');

    MapsPage.icons.putIfAbsent('element', () => structureIcon);
    MapsPage.icons.putIfAbsent('plant', () => plantIcon);
    MapsPage.icons.putIfAbsent('method', () => methodIcon);
    MapsPage.icons.putIfAbsent('wish', () => wishIcon);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
        zoomControlsEnabled: false,
        mapType: MapType.hybrid,
        markers: Set.from(MapsPage.markerList),
        onTap: (pos) {MapsPage.tappedPoint = pos;},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMapIcon()),
          ).then(onGoBack);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  FutureOr onGoBack(dynamic value){
    setState((){});
  }
}
