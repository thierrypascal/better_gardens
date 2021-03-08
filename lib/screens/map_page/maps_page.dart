import 'dart:developer' as logging;
import 'dart:math' as math;

import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/fonts/icons_biodiversity_icons.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/map_marker_service.dart';
import 'package:biodiversity/screens/map_page/maps_selection_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

/// Display the map with the markers
class MapsPage extends StatefulWidget {
  /// Display the map with the markers
  MapsPage({Key key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> with TickerProviderStateMixin {
  GoogleMapController mapController;
  LatLng _focusedLocation;
  AnimationController _fabController;
  String _biodiversityMeasure = 'none';
  static const List<IconData> icons = [
    IconsBiodiversity.wish,
    Icons.playlist_add,
  ];

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    Provider.of<MapMarkerService>(context, listen: false).getMarkerSet(
        onTapCallback: (element) {
      setState(() {
        _biodiversityMeasure = element;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karte'),
      ),
      drawer: MyDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: const CameraPosition(
              target: LatLng(46.948915, 7.445423),
              zoom: 14.0,
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

  void displayModalBottomSheet(BuildContext context) {
    showBarModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _TitleDividerCard(
                  title: 'Element',
                  detail: _biodiversityMeasure,
                ),
                _TitleDividerCard(
                  title: 'Garten Spitzname',
                  detail: 'Spitzname',
                ),
                _TitleDividerCard(
                  title: 'Garten Typ',
                  detail: 'Normaler Garten',
                ),
                _TitleDividerCard(
                  title: 'Adresse',
                  detail: 'Adresse',
                ),
                _TitleDividerCard(
                  title: 'Besitzer',
                  detail: 'Greenway',
                ),
              ],
            ),
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
            heroTag: null,
            tooltip: 'Vernetzungsprojekt starten',
            backgroundColor: Theme.of(context).cardColor,
            //TODO add onPressed functionality
            onPressed: () {},
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
            heroTag: null,
            tooltip: 'Lebensraum hinzufügen',
            backgroundColor: Theme.of(context).cardColor,
            onPressed: () {
              Provider.of<MapInteractionContainer>(context, listen: false)
                  .selectedLocation = _focusedLocation;
              logging.log(_focusedLocation.toString());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectionList()),
              );
            },
            child: Icon(icons[1], color: Theme.of(context).accentColor),
          ),
        ),
      ),
    ];
  }
}

class _TitleDividerCard extends StatelessWidget {
  const _TitleDividerCard({
    Key key,
    this.title,
    this.detail,
  }) : super(key: key);

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w200),
        ),
        const Divider(
          height: 2,
        ),
        Text(
          detail,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
