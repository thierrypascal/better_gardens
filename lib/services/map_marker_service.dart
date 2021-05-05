import 'dart:async';

import 'package:biodiversity/models/address_object.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// a service which loads and stores all map markers
class MapMarkerService extends ChangeNotifier {
  final Map<String, BitmapDescriptor> _icons = <String, BitmapDescriptor>{};
  final List<AddressObject> _markers = [];
  bool _initialized = false;
  final StorageProvider _storage;
  StreamSubscription _streamSubscription;

  ///init of the service, should only be used once
  MapMarkerService({StorageProvider storageProvider})
      : _storage = storageProvider ?? StorageProvider.instance {
    _streamSubscription = _storage.database
        .collection('locations')
        .snapshots()
        .listen(_updateElements);
    _loadIcons();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
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
    //TODO: add images for linking project
    final gardenIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'res/gardenIcon.png');

    _icons.putIfAbsent('garden', () => gardenIcon);
  }

  /// returns a list of all [AddressObjects] stored
  List<AddressObject> get addressObjectList => _markers;

  /// returns a set of all markers
  Future<Set<Marker>> getMarkerSet({Function(String element) onTapCallback}) async {
    while (!_initialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final list = <Marker>{};
    for (final object in _markers) {
      for (final element in object.elements.keys) {
        //TODO: adapt for garden/linking project
        final type = await ServiceProvider.instance.biodiversityService
            .getTypeOfObject(element);
        list.add(Marker(
          markerId: MarkerId(
              object.getLatLng().toString() + object.creationDate.toString()),
          position: object.getLatLng(),
          icon: _icons.containsKey(type) ? _icons[type] : _icons['garden'],
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
          GeoPoint(coordinate.latitude, coordinate.longitude));
      _markers.add(addressObject);
    }
    notifyListeners();
    addressObject.saveAddressObject();
  }
}
