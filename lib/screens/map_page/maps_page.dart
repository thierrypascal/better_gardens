import 'dart:async';

import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/map_marker_service.dart';
import 'package:biodiversity/screens/map_page/maps_add_biodiversity_measure_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
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
        markers: Provider.of<MapMarkerService>(context).getMarkerSet(),
        onTap: (pos) {
          Provider.of<MapInteractionContainer>(context, listen: false)
              .selectedLocation = pos;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                AddBiodiversityMeasure()),).then(onGoBack);
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
