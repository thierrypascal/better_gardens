import 'dart:developer' as logging;
import 'dart:math' as math;

import 'package:biodiversity/components/bottom_sheet_widget.dart';
import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/fonts/icons_biodiversity_icons.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/map_marker_service.dart';
import 'package:biodiversity/screens/map_page/maps_selection_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> with TickerProviderStateMixin {
  GoogleMapController mapController;
  LatLng _lastLocation;
  AnimationController _controller;
  static const List<IconData> icons = [
    IconsBiodiversity.wish,
    Icons.playlist_add,
  ];

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    Provider.of<MapMarkerService>(context, listen: false).getMarkerSet(
        onTap: () {
          AnimatedBottomSheet.of(context).expand();
    }).then((markers) {
      setState(() {
        _markers = markers;
      });
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
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
                final double lat =
                    (bounds.southwest.latitude + bounds.northeast.latitude) / 2;
                final double long =
                    (bounds.southwest.longitude + bounds.northeast.longitude) /
                        2;
                _lastLocation = LatLng(lat, long);
              });
            },
            onTap: (pos) {
              Provider.of<MapInteractionContainer>(context, listen: false)
                  .selectedLocation = pos;
              setState(() {
                AnimatedBottomSheet.of(context).collapse();
              });
            },
          ),
          AnimatedBottomSheet(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
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
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    transform:
                        Matrix4.rotationZ(_controller.value * 0.75 * math.pi),
                    alignment: FractionalOffset.center,
                    child: Icon(
                      _controller.isDismissed ? Icons.add : Icons.add,
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

  List<Widget> getWidgetListForAdvFab() {
    return [
      Container(
        height: 56.0,
        width: 75.0,
        alignment: FractionalOffset.centerLeft,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1.0 - 0 / icons.length / 2.0,
                curve: Curves.easeOut),
          ),
          child: FloatingActionButton(
            heroTag: null,
            tooltip: 'Wunsch hinzufügen',
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
            parent: _controller,
            curve: Interval(0.0, 1.0 - 1 / icons.length / 2.0,
                curve: Curves.easeOut),
          ),
          child: FloatingActionButton(
            heroTag: null,
            tooltip: 'Element hinzufügen',
            backgroundColor: Theme.of(context).cardColor,
            onPressed: () {
              Provider.of<MapInteractionContainer>(context, listen: false)
                  .selectedLocation ??= _lastLocation;
              logging.log(_lastLocation.toString());
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
