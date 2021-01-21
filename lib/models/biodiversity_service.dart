import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// a service which loads all [BiodiversityMeasure] at once and stores them
class BiodiversityService extends ChangeNotifier {
  final List<BiodiversityMeasure> _measures = [];
  bool _initialized = false;

  /// initializer for the service
  BiodiversityService() {
    FirebaseFirestore.instance
        .collection('biodiversityMeasures')
        .snapshots()
        .listen(_updateElements);
  }

  void _updateElements(QuerySnapshot snapshots) {
    _measures.clear();
    for (final DocumentSnapshot snapshot in snapshots.docs) {
      _measures.add(BiodiversityMeasure.fromSnapshot(snapshot));
    }
    notifyListeners();
    _initialized = true;
  }

  /// returns a list of [BiodiversityMeasure] which have the given type
  List<BiodiversityMeasure> getBiodiversityObjectList(String type) {
    return _measures
        .where((element) => element.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  /// returns the type of a [BiodiversityMeasure] identified by the given name
  Future<String> getTypeOfObject(String name) async {
    while (!_initialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    final element = _measures.firstWhere((element) => element.name == name,
        orElse: () => null);
    if (element != null) {
      return element.type;
    } else {
      return "unknown";
    }
  }

  /// returns the [BiodiversityMeasure] identified by the provided reference
  BiodiversityMeasure getBiodiversityMeasureByReference(
      DocumentReference reference) {
    return _measures.where((element) => element.reference == reference).first;
  }
}
