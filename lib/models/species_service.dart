import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/species.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class SpeciesService extends ChangeNotifier {
  final List<Species> _species = [];
  bool _initialized = false;

  SpeciesService() {
    FirebaseFirestore.instance
        .collection('species')
        .snapshots()
        .listen((snapshots) => _updateElements(snapshots));
  }

  void _updateElements(QuerySnapshot snapshots) {
    _species.clear();
    for (final DocumentSnapshot snapshot in snapshots.docs) {
      _species.add(Species.fromSnapshot(snapshot));
    }
    notifyListeners();
    _initialized = true;
  }

  List<Species> getSpeciesObjectList(String type) {
    return _species
        .where((element) => element.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  Future<String> getTypeOfObject(String name) async {
    while (!_initialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    final Species element = _species
        .firstWhere((element) => element.name == name, orElse: () => null);
    if (element != null) {
      return element.type;
    } else {
      return "unknown";
    }
  }

  Species getSpeciesByReference(
      DocumentReference reference) {
    return _species.where((element) => element.reference == reference).first;
  }
}
