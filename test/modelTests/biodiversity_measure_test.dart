import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../environment/mock_storage_provider.dart';

/// This test class makes sure no invalid data
/// can be retrieved from the database
void main() {
  final storage = MockStorageProvider();
  test('Valid biodiversity measures', () async {
    final measureAttributes = {
      'name': 'testname',
      'shortDescription': 'Some description...',
      'unit': 'unit...',
      'type': 'dummy',
      'beneficialFor': ['vogel'],
      'goodTogetherWith': ['birds'],
      'dimension': 'dimension..',
      'unusedField': 'xyz'
    };
    final measure = BiodiversityMeasure.fromMap(measureAttributes,
        storageProvider: storage);
    expect(
        measure.beneficialFor, containsAll(measureAttributes['beneficialFor']),
        reason: 'beneficialFor was not set correctly');
    expect(measure.goodTogetherWith,
        containsAll(measureAttributes['goodTogetherWith'] as List),
        reason: 'goodTogetherWith was not set correctly');
    expect(measure.name, measureAttributes['name'],
        reason: 'name was not set correctly');
    expect(measure.shortDescription, measureAttributes['shortDescription'],
        reason: 'shortDescription was not set correctly');
  });

  test('empty fields', () {
    var measure = BiodiversityMeasure.fromMap({}, storageProvider: storage);
    expect(measure, isA<BiodiversityMeasure>());
    expect(measure.name, '', reason: "can't handle empty name");
    expect(measure.shortDescription, '',
        reason: "can't handle empty shortDescription");
    expect(measure.type, '', reason: "can't handle empty type");
    expect(measure.beneficialFor, [],
        reason: "can't handle empty beneficialFor");
    expect(measure.goodTogetherWith, [],
        reason: "can't handle empty goodTogetherWith");
    expect(measure.dimension, '', reason: "can't handle empty dimension");
    expect(measure.imageSource, 'res/logo.png',
        reason: "can't handle empty imageSource");
  });
}
