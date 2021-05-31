import 'dart:developer' as logging;
import 'dart:math' as math;

import 'package:biodiversity/components/circlesOverview.dart';
import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/text_field_with_descriptor.dart';
import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/screens/information_list_page/biodiversity_elements_list_page.dart';
import 'package:biodiversity/services/image_service.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

/// Display the map with the markers
class MapsPage extends StatefulWidget {
  ///garden which should be displayed on map
  final Garden garden;

  /// Display the map with the markers
  MapsPage({Key key, this.garden}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> with TickerProviderStateMixin {
  GoogleMapController mapController;
  LatLng _focusedLocation;
  AnimationController _fabController;
  Garden _tappedGarden = Garden.empty();
  static const List<IconData> icons = [
    Icons.playlist_add,
    Icons.house,
  ];
  LatLng _currentLocation;
  final double _zoom = 14.0;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    ServiceProvider.instance.mapMarkerService.getMarkerSet(
        onTapCallback: (element) {
      setState(() {
        _tappedGarden = element;
      });
      displayModalBottomSheet(context);
    }).then((markers) {
      setState(() {
        _markers = markers;
      });
    });
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void loadUserLocation() async {
    if (widget.garden == null &&
        Provider.of<MapInteractionContainer>(context, listen: false)
                .selectedLocation ==
            null) {
      await Provider.of<MapInteractionContainer>(context, listen: false)
          .getLocation()
          .then((loc) =>
              mapController.animateCamera(CameraUpdate.newLatLng(loc)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapInteraction =
        Provider.of<MapInteractionContainer>(context, listen: false);
    loadUserLocation();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karte'),
      ),
      drawer: MyDrawer(),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: (widget.garden != null)
                ? CameraPosition(target: widget.garden.getLatLng(), zoom: _zoom)
                : (mapInteraction.selectedLocation != null)
                    ? CameraPosition(
                        target: mapInteraction.selectedLocation, zoom: _zoom)
                    : CameraPosition(
                        target: mapInteraction.defaultLocation,
                        zoom: _zoom,
                      ),
            zoomControlsEnabled: false,
            rotateGesturesEnabled: false,
            mapToolbarEnabled: false,
            mapType: MapType.hybrid,
            markers: _markers,
            onCameraIdle: () {
              mapController.getVisibleRegion().then((bounds) {
                final lat =
                    (bounds.southwest.latitude + bounds.northeast.latitude) / 2;
                final long =
                    (bounds.southwest.longitude + bounds.northeast.longitude) /
                        2;
                _focusedLocation = LatLng(lat, long);
              });
            },
            onTap: (pos) {
              Provider.of<MapInteractionContainer>(context, listen: false)
                  .selectedLocation = pos;
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: getWidgetListForAdvFab()
          ..add(
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (_fabController.isDismissed) {
                  _fabController.forward();
                } else {
                  _fabController.reverse();
                }
              },
              child: AnimatedBuilder(
                animation: _fabController,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.rotationZ(
                        _fabController.value * 0.75 * math.pi),
                    alignment: FractionalOffset.center,
                    child: Icon(
                      _fabController.isDismissed ? Icons.add : Icons.add,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),
      ),
    );
  }

  Future<Widget> displayModalBottomSheet(BuildContext context) async {
    return await showModalBottomSheet(
        barrierColor: Colors.transparent,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        )),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.1,
            expand: false,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    TextFieldWithDescriptor(
                        'Spitzname Garten', Text(_tappedGarden.name ?? '')),
                    TextFieldWithDescriptor(
                        'Gartentyp', Text(_tappedGarden.gardenType ?? '')),
                    TextFieldWithDescriptor(
                        'Garten Adresse', Text(_tappedGarden.street ?? '')),
                    TextFieldWithDescriptor(
                      'Besitzer',
                      FutureBuilder(
                        future: ServiceProvider.instance.gardenService
                            .getNicknameOfOwner(_tappedGarden),
                        builder: (context, owner) {
                          if (owner.hasData) {
                            return Text(owner.data);
                          } else {
                            return const Text('');
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    CirclesOverview(context, _tappedGarden),
                    const SizedBox(height: 25.0),
                    FutureBuilder(
                      future: _tappedGarden.isShowImageOnGarden(),
                      builder: (context, showGardenImageOnMap) {
                        if (showGardenImageOnMap.hasData) {
                          return (_tappedGarden.imageURL.isNotEmpty)
                              ? ImageService().getImageByUrl(
                                  _tappedGarden.imageURL,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fitWidth)
                              : Image(
                                  image: const AssetImage('res/myGarden.jpg'),
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fitWidth,
                                  semanticLabel: _tappedGarden.name,
                                );
                        } else {
                          return const Text('');
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  List<Widget> getWidgetListForAdvFab() {
    return [
      Container(
        height: 56.0,
        width: 75.0,
        alignment: FractionalOffset.centerLeft,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _fabController,
            curve: Interval(0.0, 1.0 - 0 / icons.length / 2.0,
                curve: Curves.easeOut),
          ),
          child: FloatingActionButton(
            //TODO should be "Vernetzungsprojekte", not "Lebensräume" (Tooltip, Icon and Redirect)
            heroTag: null,
            tooltip: 'Lebensraum hinzufügen',
            backgroundColor: Theme.of(context).cardColor,
            onPressed: () {
              Provider.of<MapInteractionContainer>(context, listen: false)
                  .selectedLocation = _focusedLocation;
              logging.log(_focusedLocation.toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BiodiversityElementListPage()),
              );
            },
            child: Icon(icons[0], color: Theme.of(context).accentColor),
          ),
        ),
      ),
      Container(
        height: 56.0,
        width: 75.0,
        alignment: FractionalOffset.centerLeft,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _fabController,
            curve: Interval(0.0, 1.0 - 1 / icons.length / 2.0,
                curve: Curves.easeOut),
          ),
          child: FloatingActionButton(
            //TODO make the creation of the Garden use the selected location (and make apparent which location this is), if we dont use the location, giving this option makes no sense here
            heroTag: null,
            tooltip: 'Garten erstellen',
            backgroundColor: Theme.of(context).cardColor,
            onPressed: () {
              ServiceProvider.instance.gardenService
                  .handle_create_garden(context); //TODO maybe replace by Snackbar
            },
            child: Icon(icons[1], color: Theme.of(context).accentColor),
          ),
        ),
      ),
    ];
  }
}
