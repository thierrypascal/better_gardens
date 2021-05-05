import 'package:biodiversity/models/garden.dart';
import 'package:flutter_test/flutter_test.dart';

import '../environment/mock_storage_provider.dart';

void main() {
  final storage = MockStorageProvider();

  test('empty garden', () {
    final garden = Garden.empty(storageProvider: storage);
    expect(garden.name, '', reason: 'name was not empty');
    expect(garden.owner, '', reason: 'owner was not empty');
    expect(garden.street, '', reason: 'street was not empty');
    expect(garden.city, '', reason: 'city was not empty');
    expect(garden.longitude, isNull, reason: 'longitude was not null');
    expect(garden.latitude, isNull, reason: 'latitude was not null');
  });

  test('Valid garden creation', () {
    final gardenAttributes = {
      'name': "Mr. Lewis' Garden",
      'city': 'Locarno',
      'street': 'via G.G. Nessi 4B',
      'owner': 'Lisa',
      'latitude': 1.2345,
      'longitude': 4.2314,
      'ownedObjects': {'dummy': 9, 'second dummy': 1},
      'ownedLinkingProjects': ['grasfroschteam']
    };
    final garden = Garden.fromMap(gardenAttributes, storageProvider: storage);
    expect(garden.name, gardenAttributes['name'],
        reason: 'name was not set correctly');
    expect(garden.city, gardenAttributes['city'],
        reason: 'city was not set correctly');
    expect(garden.street, gardenAttributes['street'],
        reason: 'street was not set correctly');
    expect(garden.owner, gardenAttributes['owner'],
        reason: 'owner was not set correctly');
    expect(garden.latitude, gardenAttributes['latitude'],
        reason: 'latitude was not set correctly');
    expect(garden.longitude, gardenAttributes['longitude'],
        reason: 'longitude was not set correctly');
    for (final item in (gardenAttributes['ownedObjects'] as Map).entries) {
      expect(garden.ownedObjects, containsPair(item.key, item.value),
          reason: 'ownedObjects was not set correctly');
    }
    expect(garden.ownedLinkingProjects,
        containsAll(gardenAttributes['ownedLinkingProjects']),
        reason: 'ownedLinkingProjects was not set correctly');
  });

  test('save garden', () async {
    final gardenAttributes = {
      'name': "Mr. Lewis' Garden",
      'city': 'Locarno',
      'street': 'via G.G. Nessi 4B',
      'owner': 'Tom',
      'ownedObjects': {'dummy': 9, 'second dummy': 1},
      'ownedLinkingProjects': ['grasfroschteam']
    };
    final garden = Garden.fromMap(gardenAttributes, storageProvider: storage);
    await garden.saveGarden();
    final snapshots = await storage.database.collection('gardens').get();
    final map = snapshots.docs.first.data();
    expect(map, containsPair('name', "Mr. Lewis' Garden"),
        reason: 'garden was not saved');
    expect(map['city'], gardenAttributes['city'], reason: 'city was not saved');
    expect(map['street'], gardenAttributes['street'],
        reason: 'street was not saved');
    expect(map['owner'], gardenAttributes['owner'],
        reason: 'owner was not saved');
    for (final obj in (gardenAttributes['ownedObjects'] as Map).entries) {
      expect(map['ownedObjects'], containsPair(obj.key, obj.value),
          reason: 'ownedObjects was not saved correctly');
    }
    expect(map['ownedLinkingProjects'],
        containsAll(gardenAttributes['ownedLinkingProjects'] as List),
        reason: 'ownedLinkingProjects was not saved correctly');
  });

  test('garden management', () {
    final garden = Garden.empty(storageProvider: storage);
    garden.addOwnedObject('test', 2);
    expect(garden.ownedObjects, containsPair('test', 2),
        reason: 'addOwnedObject does not add an object');
    garden.addOwnedObject('another', 6);
    expect(garden.ownedObjects, containsPair('another', 6),
        reason: 'addOwnedObject does not add an object');
    garden.addLinkingProject('linkingProject');
    expect(garden.ownedLinkingProjects, contains('linkingProject'),
        reason: 'addLinkingProject does not add a LinkingProject');

    garden.removeFromLinkingProjects('linkingProject');
    expect(garden.ownedLinkingProjects, isNot(contains('linkingProject')),
        reason: 'addLinkingProject does not remove a LinkingProject');
    garden.removeFromOwnedObjects('another');
    expect(garden.ownedObjects, isNot(containsPair('another', 6)),
        reason: 'addOwnedObject does not remove an object');
    garden.removeFromOwnedObjects('test');
    expect(garden.ownedObjects, isNot(containsPair('test', 6)),
        reason: 'addOwnedObject does not remove an object');
  });
}
