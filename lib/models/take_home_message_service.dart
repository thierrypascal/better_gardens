import 'package:biodiversity/models/take_home_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// a service which loads all [TakeHomeMessage] at once and stores them
class TakeHomeMessageService extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final List<TakeHomeMessage> _measures = [];
  bool _initialized = false;

  /// initializer for the service
  TakeHomeMessageService(this._firestore) {
    _firestore
        .collection('takeHomeMessage')
        .snapshots()
        .listen(_updateElements);
  }

  void _updateElements(QuerySnapshot snapshots) {
    _measures.clear();
    for (final DocumentSnapshot snapshot in snapshots.docs) {
      _measures.add(TakeHomeMessage.fromSnapshot(snapshot));
    }
    notifyListeners();
    _initialized = true;
  }

  /// returns the complete list of [TakeHomeMessage]
  List<TakeHomeMessage> getFullTakeHomeMessageObjectList() {
    return _measures.toList();
  }

}
