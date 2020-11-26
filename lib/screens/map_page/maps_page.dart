import 'dart:async';
import 'package:provider/provider.dart';
import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/address_object.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/screens/map_page/maps_add_biodiversity_measure_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();

//  static LatLng tappedPoint = const LatLng(46.948915, 7.445423);
//  static List<Marker> markerList = new List<Marker>();
  static Map<String, BitmapDescriptor> icons = <String, BitmapDescriptor>{};
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    initCustomIconMap();

    AddressObject o = AddressObject(
        DateTime.now(), <String, int>{"Steinwand": 7}, const GeoPoint(72, 38));
    o.addElement("Blumenbeet", 5);
    o.saveAddressObject();
  }

  Future<void> initCustomIconMap() async {
    final BitmapDescriptor structureIcon =
        await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'res/structureIcon.png');
    final BitmapDescriptor plantIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/plantIcon.png');
    final BitmapDescriptor methodIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/methodIcon.png');
    final BitmapDescriptor wishIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/wishIcon.png');

    MapsPage.icons.putIfAbsent('element', () => structureIcon);
    MapsPage.icons.putIfAbsent('plant', () => plantIcon);
    MapsPage.icons.putIfAbsent('method', () => methodIcon);
    MapsPage.icons.putIfAbsent('wish', () => wishIcon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      drawer: MyDrawer(),
      body: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: const CameraPosition(
          target: LatLng(46.948915, 7.445423),
          zoom: 14.0,
        ),
        zoomControlsEnabled: false,
        rotateGesturesEnabled: false,
        mapType: MapType.hybrid,
        markers: Set.from(//Provider MarkerList),
        onTap: (pos) {
          Provider
            .of<MapInteractionContainer>(context, listen: false)
            .selectedLocation = pos;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                AddBiodiversityMeasure()), //change to .fromMap
          ).then(onGoBack);
        },
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        child: const Icon(Icons.
        add
        )
        ,
      )
      ,
    );
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}
