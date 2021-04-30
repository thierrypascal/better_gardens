import 'dart:async';

import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:biodiversity/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// A service which loads all gardens and stores them
class GardenService extends ChangeNotifier {
  final List<Garden> _gardens = [];
  StreamSubscription _streamSubscription;
  StorageProvider _storage;

  /// init the service, should only be used once
  GardenService({StorageProvider storageProvider}) {
    _storage = storageProvider ?? StorageProvider.instance;
    _streamSubscription = _storage.database
        .collection('gardens')
        .snapshots()
        .listen(_updateElements);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void _updateElements(QuerySnapshot snapshots) {
    _gardens.clear();
    for (final DocumentSnapshot snapshot in snapshots.docs) {
      _gardens.add(Garden.fromSnapshot(snapshot));
    }
    notifyListeners();
  }

  /// Returns a list of Gardens which the provided User has
  List<Garden> getAllGardensFromUser(User user) {
    // TODO: implement this method
    return [];
  }

  ///Returns all elements inside the users active garden
  //TODO: implement these methods
  List<BiodiversityMeasure> getAllBiodiversityMeasuresFromUsersActiveGarden() {
    List<BiodiversityMeasure> result = [];

    return result;
  }

  /// returns a single Garden referenced by the provided reference
  Garden getGardenByReference(DocumentReference reference) {
    return _gardens.where((element) => element.reference == reference).first;
  }
}
