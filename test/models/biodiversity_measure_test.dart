import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../environment/mock_storage_provider.dart';

/// This test class makes sure no invalid data
/// can be retrieved from the database
void main() {
  // DocumentReference does not have to be passed as an argument if it is null
  // DocumentReference dummy = null; // does not really connect to a database

  Map<String, dynamic> measureAttributes;
  BiodiversityMeasure validMeasure;
  final storage = MockStorageProvider();

  test('Valid biodiversity measures', () {
    measureAttributes = {
      'name': 'Some name...',
      'description': 'Some description...',
      'unit': 'unit...',
      'type': 'dummy',
      'beneficialFor': ['vogel'],
      'goodTogetherWith': ['birds'],
      'dimension': 'dimension..',
      'unusedField': 'xyz'
    };
    validMeasure = BiodiversityMeasure.fromMap(measureAttributes, storage);
    expect(validMeasure, isA<BiodiversityMeasure>());
    expect(validMeasure.beneficialFor.contains('vogel'), true);
    expect(validMeasure.goodTogetherWith.contains('birds'), true);

    measureAttributes = {
      'name': null,
      'description': null,
      'buildInstructions': null,
      'type': null,
      '_beneficialFor': null,
      '_badFor': null,
      'imageSource': null
    };
    validMeasure = BiodiversityMeasure.fromMap(measureAttributes, storage);
    expect(validMeasure, isA<BiodiversityMeasure>());

    measureAttributes = {
      'name': 'Some name...',
      'description': 'Some description...',
      'unit': 'unit...',
      'type': 'dummy',
      'beneficialFor': {'vogel': true},
      'goodTogetherWith': {'birds': true},
      'dimension': 'dimension..',
      'unusedField': 'xyz'
    };
    validMeasure = BiodiversityMeasure.fromMap(measureAttributes, storage);
    expect(validMeasure, isA<BiodiversityMeasure>());
    expect(validMeasure.beneficialFor.contains('vogel'), false);
    expect(validMeasure.goodTogetherWith.contains('birds'), false);
  });
}
