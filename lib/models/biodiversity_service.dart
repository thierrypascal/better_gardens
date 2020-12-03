import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class BiodiversityService extends ChangeNotifier {
  final List<BiodiversityMeasure> _measures = [];
  bool _initialized = false;

  BiodiversityService() {
    FirebaseFirestore.instance
        .collection('biodiversityMeasures')
        .snapshots()
        .listen((snapshots) => _updateElements(snapshots));
  }

  void _updateElements(QuerySnapshot snapshots) {
    _measures.clear();
    for (final DocumentSnapshot snapshot in snapshots.docs) {
      _measures.add(BiodiversityMeasure.fromSnapshot(snapshot));
    }
    notifyListeners();
    _initialized = true;
  }

  List<BiodiversityMeasure> getBiodiversityObjectList(String type) {
    return _measures
        .where((element) => element.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  Future<String> getTypeOfObject(String name) async {
    while (!_initialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    final BiodiversityMeasure element = _measures
        .firstWhere((element) => element.name == name, orElse: () => null);
    if (element != null) {
      return element.type;
    } else {
      return "unknown";
    }
  }

  BiodiversityMeasure getBiodiversityMeasureByReference(
      DocumentReference reference) {
    return _measures.where((element) => element.reference == reference).first;
  }
}
