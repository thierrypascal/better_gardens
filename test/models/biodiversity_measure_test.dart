import 'package:biodiversity/models/biodiversity_measure.dart';

import 'package:flutter_test/flutter_test.dart';

/// This test class makes sure no invalid data
/// can be retrieved from the database
void main() {

  // DocumentReference does not have to be passed as an argument if it is null
  // DocumentReference dummy = null; // does not really connect to a database

  Map<String, dynamic> measureAttributes;
  BiodiversityMeasure validMeasure;

  test('Valid biodiversity measures', () {

    measureAttributes = {
      "name": "Some name...",
      "description": "Some description...",
      "buildInstructions": "Instructions...",
      "type": "dummy",
      "_beneficialFor": {"birds": true},
      "_badFor": {"birds": false},
      "imageSource": "some/path"
    };
    validMeasure = BiodiversityMeasure.fromMap(measureAttributes);
    expect(validMeasure, isA<BiodiversityMeasure>());

    measureAttributes = {
      "name": null,
      "description": null,
      "buildInstructions": null,
      "type": null,
      "_beneficialFor": null,
      "_badFor": null,
      "imageSource": null
    };
    validMeasure = BiodiversityMeasure.fromMap(measureAttributes);
    expect(validMeasure, isA<BiodiversityMeasure>());

  });

  test('Invalid biodiversity measures', () {

    measureAttributes = {
      "name": 1,
      "description": "Some description...",
      "buildInstructions": "Instructions...",
      "type": "dummy",
      "_beneficialFor": {"birds": true},
      "_badFor": {"birds": false},
      "imageSource": "some/path"
    };
    expect(() => BiodiversityMeasure.fromMap(measureAttributes), throwsA(isA<TypeError>()));

    measureAttributes = {
      "name": "Some name...",
      "description": 2.3,
      "buildInstructions": "Instructions...",
      "type": "dummy",
      "_beneficialFor": {"birds": true},
      "_badFor": {"birds": false},
      "imageSource": "some/path"
    };
    expect(() => BiodiversityMeasure.fromMap(measureAttributes), throwsA(isA<TypeError>()));

    measureAttributes = {
      "name": "Some name...",
      "description": "Some description...",
      "buildInstructions": {"instruction inside a set"},
      "type": "dummy",
      "_beneficialFor": {"birds": true},
      "_badFor": {"birds": false},
      "imageSource": "some/path"
    };
    expect(() => BiodiversityMeasure.fromMap(measureAttributes), throwsA(isA<TypeError>()));

    measureAttributes = {
      "name": "Some name...",
      "description": "Some description...",
      "buildInstructions": "Instructions...",
      "type": {"no_type": true},
      "_beneficialFor": {"birds": true},
      "_badFor": {"birds": false},
      "imageSource": "some/path"
    };
    expect(() => BiodiversityMeasure.fromMap(measureAttributes), throwsA(isA<TypeError>()));

/*    measureAttributes = {
      "name": "Some name...",
      "description": "Some description...",
      "buildInstructions": "Instructions...",
      "type": "dummy",
      "_beneficialFor": "not a map",
      "_badFor": {"birds": false},
      "imageSource": "some/path"
    };
    expect(() => BiodiversityMeasure.fromMap(measureAttributes), throwsA(isA<TypeError>()));*/

/*    measureAttributes = {
      "name": "Some name...",
      "description": "Some description...",
      "buildInstructions": "Instructions...",
      "type": "dummy",
      "_beneficialFor": {"birds": true},
      "_badFor": {"birds": "notABoolean"}, // not a boolean
      "imageSource": "some/path"
    };
    expect(() => BiodiversityMeasure.fromMap(measureAttributes), throwsA(isA<TypeError>()));*/

/*    measureAttributes = {
      "name": "Some name...",
      "description": "Some description...",
      "buildInstructions": "Instructions...",
      "type": "dummy",
      "_beneficialForu": {"birds": true},
      "_badFor": {"birds": false},
      "imageSource": 9;
    };
    expect(() => BiodiversityMeasure.fromMap(measureAttributes), throwsA(isA<TypeError>()));*/

  });

}