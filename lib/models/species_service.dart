import 'package:biodiversity/models/species.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// A service which loads all species and stores them
class SpeciesService extends ChangeNotifier {
  final List<Species> _species = [];
  final List<String> _classes = [];
  bool _initialized = false;

  /// init the service, should only be used once
  SpeciesService() {
    FirebaseFirestore.instance
        .collection('species')
        .snapshots()
        .listen(_updateElements);
  }

  void _updateElements(QuerySnapshot snapshots) {
    _species.clear();
    for (final DocumentSnapshot snapshot in snapshots.docs) {
      _species.add(Species.fromSnapshot(snapshot));
    }
    notifyListeners();
    _initialized = true;
  }

  ///returns all Species associated with the given type
  List<Species> getSpeciesObjectList(String type) {
    return _species
        .where((element) => element.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  ///returns all Species
  List<Species> getFullSpeciesObjectList() {
    return _species
        .toList();
  }

  /// returns the type of a given Species
  Future<String> getTypeOfObject(String name) async {
    while (!_initialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    final element = _species.firstWhere((element) => element.name == name,
        orElse: () => null);
    if (element != null) {
      return element.type;
    } else {
      return "unknown";
    }
  }

  /// returns a single Species referenced by the provided reference
  Species getSpeciesByReference(DocumentReference reference) {
    return _species.where((element) => element.reference == reference).first;
  }

  /// returns a list of all distinct classes all species are in
  List<String> getAllClasses() {
    if (_classes.isNotEmpty) {
      return _classes.toList();
    }
    for (final s in _species) {
      if (!_classes.contains(s.name)) {
        _classes.add(s.name);
      }
    }
    return _classes.toList();
  }
}
