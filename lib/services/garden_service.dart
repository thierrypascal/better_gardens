import 'dart:async';

import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/services/service_provider.dart';
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
    return _gardens.where((garden) => garden.owner == user.userUUID).toList();
  }

  /// Returns a list of all registred Gardens
  List<Garden> getAllGardens() {
    return _gardens;
  }

  ///Returns all elements inside the users active garden
  List<BiodiversityMeasure> getAllBiodiversityMeasuresFromGarden(
      Garden garden) {
    final result = <BiodiversityMeasure>[];
    for (final item in garden.ownedObjects.keys) {
      result.add(ServiceProvider.instance.biodiversityService
          .getBiodiversityMeasureByName(item));
    }
    return result;
  }

  /// returns a single Garden referenced by the provided reference
  Garden getGardenByReference(DocumentReference reference) {
    return _gardens
        .where((element) => element.reference == reference)
        .first;
  }

  /// returns the nickname of the garden owner if showGardenOnMap is set to true for this user
  Future<String> getNicknameOfOwner(Garden garden) async {
    final doc = await _storage.database.doc('users/${garden.owner}').get();
    if (doc != null && doc.exists) {
      final data = doc.data();
      if (data.containsKey('showNameOnMap') && data.containsKey('nickname')) {
        final showName = data['showNameOnMap'] as bool;
        return showName ? doc.data()['nickname'] : 'Anonym';
      }
    }
    return 'Anonym';
  }
}