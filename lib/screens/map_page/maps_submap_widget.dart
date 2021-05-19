import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

/// Small Map widget which displays the selection
/// stored in [MapInteractionContainer]
class SubMap extends StatefulWidget {
  /// Small Map widget which displays the selection
  /// stored in [MapInteractionContainer]
  SubMap({this.garden, Key key}) : super(key: key);

  /// the garden the submap should be displaying
  final Garden garden;

  @override
  _SubMapState createState() => _SubMapState();
}

class _SubMapState extends State<SubMap> {
  GoogleMapController mapController;
  Set<Marker> markers = {};

  void loadUserLocation() async {
    final mapInteraction =
        Provider.of<MapInteractionContainer>(context, listen: false);
    if (widget.garden == null && mapInteraction.selectedLocation == null) {
      await mapInteraction
          .getLocation()
          .then((loc) => mapInteraction.selectedLocation = loc);
      mapController.moveCamera(CameraUpdate.newLatLng(mapInteraction.selectedLocation));
    }
  }

  void loadMarkers() {
    final mapInteraction = Provider.of<MapInteractionContainer>(context);
    markers = <Marker>{
      Marker(
        position: mapInteraction.selectedLocation,
        markerId: const MarkerId('subMapMarker'),
      )
    };
    print("+++++++++++++++++ marker");
  }

  @override
  Widget build(BuildContext context) {
    final mapInteraction = Provider.of<MapInteractionContainer>(context);
    loadUserLocation();
    loadMarkers();

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Row(
              children: [
                const Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 40, 0),
                    child: Icon(Icons.location_on),
                  ),
                ),
                Flexible(
                  child: FutureBuilder(
                    future: mapInteraction.getAddressOfSelectedLocation(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('');
                      }
                      mapInteraction.getCameraPosition() ??
                          mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                  mapInteraction.getCameraPosition()));
                      return Text(
                        snapshot.data,
                        textScaleFactor: 1.3,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: (widget.garden != null)
                  ? CameraPosition(
                      target: widget.garden.getLatLng(), zoom: 18.0)
                  : mapInteraction.getCameraPosition(),
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              mapType: MapType.hybrid,
              markers: markers,
              onTap: (pos) {
                mapInteraction.selectedLocation = pos;
                mapController.animateCamera(CameraUpdate.newLatLng(pos));
              },
              gestureRecognizers: Set()
                ..add(Factory<PanGestureRecognizer>(
                    () => PanGestureRecognizer())),
            ),
          ),
        ],
      ),
    );
  }
}
