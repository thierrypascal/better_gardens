import 'package:biodiversity/models/address_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerService extends ChangeNotifier {
  final Map<String, BitmapDescriptor> _icons = <String, BitmapDescriptor>{};
  List<AddressObject> _markers;

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

  List<Marker> getMarkerList() {
    List<Marker> list;
    for (final AddressObject object in _markers) {
      for (final String element in object.elements.keys) {
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

  void addMarker(Marker marker) {
    final AddressObject addressObject = AddressObject(DateTime.now(), {},
        GeoPoint(marker.position.latitude, marker.position.longitude));
    _markers.add(addressObject);
    notifyListeners();
    addressObject.saveAddressObject();
  }
}
