import 'package:biodiversity/models/address_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MapMarkerService extends ChangeNotifier {
  List<AddressObject> _markers;

  MapMarkerService() {
    FirebaseFirestore.instance
        .collection('locations')
        .snapshots()
        .listen((snapshots) => _updateElements(snapshots));
    _loadList();
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

  List<AddressObject> getMarkerList() {
    return _markers;
  }
}
