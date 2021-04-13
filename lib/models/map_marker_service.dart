import 'package:biodiversity/models/address_object.dart';
import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

/// a service which loads and stores all map markers
class MapMarkerService extends ChangeNotifier {
  final Map<String, BitmapDescriptor> _icons = <String, BitmapDescriptor>{};
  final List<AddressObject> _markers = [];
  final BuildContext _context;
  bool _initialized = false;
  final StorageProvider _storage;

  ///init of the service, should only be used once
  MapMarkerService(this._context, this._storage) {
    _storage.database
        .collection('locations')
        .snapshots()
        .listen(_updateElements);
    _loadIcons();
  }

  void _updateElements(QuerySnapshot snapshots) {
    _markers.clear();
    for (final DocumentSnapshot snapshot in snapshots.docs) {
      _markers.add(AddressObject.fromSnapshot(snapshot, _storage));
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadIcons() async {
    final structureIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/structureIcon.png');
    final plantIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/plantIcon.png');
    final methodIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/methodIcon.png');
    final wishIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/wishIcon.png');

    _icons.putIfAbsent('element', () => structureIcon);
    _icons.putIfAbsent('plant', () => plantIcon);
    _icons.putIfAbsent('method', () => methodIcon);
    _icons.putIfAbsent('wish', () => wishIcon);
  }

  /// returns a list of all [AddressObjects] stored
  List<AddressObject> get addressObjectList => _markers;

  /// returns a set of all markers
  Future<Set<Marker>> getMarkerSet(
      {Function(String element) onTapCallback}) async {
    while (!_initialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final list = <Marker>{};
    for (final object in _markers) {
      for (final element in object.elements.keys) {
        final type =
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

  /// add a marker to the collection, the marker will then saved to the database
  void addMarker(String element, int amount, LatLng coordinate) {
    AddressObject addressObject;
    for (final object in _markers.toList()) {
      if (object.isSameLocation(coordinate)) {
        addressObject = object;
        addressObject.addElement(element, amount);
        _markers.remove(object);
      }
    }
    if (addressObject == null) {
      addressObject = AddressObject({element: amount},
          GeoPoint(coordinate.latitude, coordinate.longitude), _storage);
      _markers.add(addressObject);
    }
    notifyListeners();
    addressObject.saveAddressObject();
  }
}
