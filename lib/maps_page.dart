import 'package:biodiversity/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  MapsPage(this.latitude, this.longitude,  {Key key, }) : super(key: key);
  final double latitude;
  final double longitude;

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      drawer: MyDrawer(),
      body: GoogleMap(
        onMapCreated: (controller) => {mapController = controller},
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }
}