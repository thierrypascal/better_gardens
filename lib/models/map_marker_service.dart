import 'package:biodiversity/models/address_object.dart';
import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapMarkerService extends ChangeNotifier {
  final Map<String, BitmapDescriptor> _icons = <String, BitmapDescriptor>{};
  final List<AddressObject> _markers = [];
  final BuildContext _context;
  bool _initialized = false;

  MapMarkerService(this._context) {
    FirebaseFirestore.instance
        .collection('locations')
        .snapshots()
        .listen((snapshots) => _updateElements(snapshots));
    _loadIcons();
  }

  void _updateElements(QuerySnapshot snapshots) {
    _markers.clear();
    for (final DocumentSnapshot snapshot in snapshots.docs) {
      _markers.add(AddressObject.fromSnapshot(snapshot));
    }
    _initialized = true;
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

  Future<Set<Marker>> getMarkerSet(
      {Function(String element) onTapCallback}) async {
    while (!_initialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final Set<Marker> list = <Marker>{};
    for (final AddressObject object in _markers) {
      for (final String element in object.elements.keys) {
        final String type =
            await Provider.of<BiodiversityService>(_context, listen: false)
                .getTypeOfObject(element);
        list.add(Marker(
          markerId: MarkerId(
              object.getLatLng().toString() + object.creationDate.toString()),
          position: object.getLatLng(),
          icon: _icons.containsKey(type) ? _icons[type] : _icons['wish'],
          onTap: () {
            onTapCallback(element);
          },
        ));
      }
    }
    return list;
  }

  void addMarker(String element, int amount, LatLng coordinate) {
    AddressObject addressObject;
    for (final AddressObject object in _markers.toList()) {
      if (object.isSameLocation(coordinate)) {
        addressObject = object;
        addressObject.addElement(element, amount);
        _markers.remove(object);
      }
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
