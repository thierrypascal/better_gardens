import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

/// Small Map widget which displays the selection
/// stored in [MapInteractionContainer]
class SubMap extends StatefulWidget {
  /// Small Map widget which displays the selection
  /// stored in [MapInteractionContainer]
  SubMap({Key key}) : super(key: key);

  @override
  _SubMapState createState() => _SubMapState();
}

class _SubMapState extends State<SubMap> {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
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
                    future: Provider.of<MapInteractionContainer>(context)
                        .getAddressOfSelectedLocation(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('');
                      }
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
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition:
                  Provider.of<MapInteractionContainer>(context)
                      .getCameraPosition(),
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              mapType: MapType.hybrid,
              markers: Provider.of<MapInteractionContainer>(context)
                          .selectedLocation !=
                      null
                  ? <Marker>{
                      Marker(
                        position: Provider.of<MapInteractionContainer>(context)
                            .selectedLocation,
                        markerId: MarkerId('subMapMarker'),
                      )
                    }
                  : <Marker>{},
              onTap: (pos) {
                setState(() {
                  Provider.of<MapInteractionContainer>(context, listen: false)
                      .selectedLocation = pos;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
