import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../facebook_mock/mock_storage_provider.dart';

void main() {
  test('test fetch all data', () async {
    final firestore = MockFirestoreInstance();
    await firestore.doc('biodiversityMeasures/testObject').set({
      'name': 'testObject',
      'type': 'test',
    });
    final service = BiodiversityService(MockStorageProvider());
    expect(await service.getBiodiversityObjectList('None'), isA<List>());
    expect(await service.getTypeOfObject('testObject'), equals('test'));
    expect(await service.getTypeOfObject('anotherThing'), equals('unknown'));
  });
}
