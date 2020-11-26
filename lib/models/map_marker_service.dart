import 'dart:developer' as logging;

import 'package:biodiversity/models/address_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerService extends ChangeNotifier {
  final Map<String, BitmapDescriptor> _icons = <String, BitmapDescriptor>{};
  final List<AddressObject> _markers = [];

  MapMarkerService() {
    FirebaseFirestore.instance
        .collection('locations')
        .snapshots()
        .listen((snapshots) => _updateElements(snapshots));
    _loadList();
    _loadIcons();
  }

  Future<List<AddressObject>> _loadList() async {
    final QuerySnapshot query =
    await FirebaseFirestore.instance.collection('locations').get();

    for (final DocumentSnapshot snapshot in query.docs) {
      _markers.add(AddressObject.fromSnapshot(snapshot));
    }
    return _markers;
  }

  void _updateElements(QuerySnapshot snapshots) {
    _markers.clear();
    for (final DocumentSnapshot snapshot in snapshots.docs) {
      _markers.add(AddressObject.fromSnapshot(snapshot));
    }
    notifyListeners();
  }

  Future<void> _loadIcons() async {
    final BitmapDescriptor structureIcon =
    await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/structureIcon.png');
    final BitmapDescriptor plantIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/plantIcon.png');
    final BitmapDescriptor methodIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/methodIcon.png');
    final BitmapDescriptor wishIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/wishIcon.png');

    _icons.putIfAbsent('element', () => structureIcon);
    _icons.putIfAbsent('plant', () => plantIcon);
    _icons.putIfAbsent('method', () => methodIcon);
    _icons.putIfAbsent('wish', () => wishIcon);
  }

  List<AddressObject> getAddressObjectList() {
    return _markers;
  }

  Set<Marker> getMarkerSet() {
    final Set<Marker> list = <Marker>{};
    for (final AddressObject object in _markers) {
      for (final String element in object.elements.keys) {
        logging.log(
            "add marker of type $element to ${object.coordinates.latitude}");
        list.add(Marker(
          markerId: MarkerId(
              object.getLatLng().toString() + object.creationDate.toString()),
          position: object.getLatLng(),
          icon: _icons.containsKey(element) ? _icons[element] : _icons['wish'],
        ));
      }
    }
    return list;
  }

  void addMarker(String element, int amount, LatLng coordinate) {
    AddressObject addressObject;
    for (final AddressObject object in _markers) {
      if (object.isSameLocation(coordinate)) {
        object.addElement(element, amount);
        addressObject = object;
      }

      if (addressObject == null) {
        addressObject = AddressObject(DateTime.now(), {element: amount},
            GeoPoint(coordinate.latitude, coordinate.longitude));
        _markers.add(addressObject);
      }
      notifyListeners();
      addressObject.saveAddressObject();
    }
  }
}
