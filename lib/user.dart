import 'dart:core';
import 'dart:developer' as logging;

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final DocumentReference reference;
  String nickname;
  String name;
  String surname;
  String passwordHash;
  DocumentReference addressID;
  String email;
  bool hasConfirmedEmail;
  String phone;
  Set<DocumentReference> gardens;
  Set<String> favoredObjects;

  User(this.reference);

  User.create(
      this.reference,
      this.nickname,
      this.name,
      this.surname,
      this.passwordHash,
      this.addressID,
      this.email,
      this.phone,
      this.gardens,
      this.favoredObjects,
      {this.hasConfirmedEmail = false});

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : nickname = map.containsKey('nickname') ? map['nickname'] as String : "",
        name = map.containsKey('name') ? map['name'] as String : "",
        surname = map.containsKey('surname') ? map['surname'] as String : "",
        passwordHash = map.containsKey('passwordHash')
            ? map['passwordHash'] as String
            : "",
        addressID = map.containsKey('addressID')
            ? map['addressID'] as DocumentReference
            : null,
        email = map.containsKey('email') ? map['email'] as String : "",
        phone = map.containsKey('phone') ? map['phone'] as String : "",
        gardens = map.containsKey('gardens')
            ? Set<DocumentReference>.from((map['gardens'] as Map).keys)
            : <DocumentReference>{},
        favoredObjects = map.containsKey('favoredObjects')
            ? Set.from((map['favoredObjects'] as Map).keys)
            : <String>{},
        hasConfirmedEmail = map.containsKey('hasConfirmedEmail') &&
            map['hasConfirmedEmail'] as bool {
    if (map.containsKey('favoredObjects')) {
      logging.log(map[favoredObjects].toString());
    }
  }

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Future<void> saveUser() {
    logging.log("save user");
    return Firestore.instance.document(reference.path).setData({
      'nickname': nickname,
      'name': name,
      'surname': surname,
      'passwordHash': passwordHash,
      'addressID': addressID,
      'email': email,
      'phone': phone,
      'gardens': {for (DocumentReference garden in gardens) garden: true},
      'favoredObjects': {for (String item in favoredObjects) item: true},
      'hasConfirmedEmail': hasConfirmedEmail,
    });
  }

  void likeUnlikeElement(String element) {
    if (favoredObjects.contains(element)) {
      favoredObjects.remove(element);
    } else {
      favoredObjects.add(element);
    }
  }

  bool doesLikeElement(String element) {
    return favoredObjects.contains(element);
  }

  @override
  String toString() {
    return "{Nickname: $nickname, Name: $name, Surname: $surname, Email: $email}";
  }
}
