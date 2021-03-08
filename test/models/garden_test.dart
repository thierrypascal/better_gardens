import 'package:biodiversity/models/garden.dart';
import 'package:flutter_test/flutter_test.dart';

/// This test class makes sure no invalid data
/// can be retrieved from the database
void main() {

  // DocumentReference does not have to be passed as an argument if it is null
  // DocumentReference dummy = null; // does not really connect to a database

  Map<String, dynamic> gardenAttributes;
  Garden validGarden;

  test('Valid gardens', () {

    gardenAttributes = {
      "name": "Mr. Lewis' Garden",
      "city": "Locarno",
      "street": "via G.G. Nessi 4B",
      "numberOfStructureElements": 2,
      "numberOfPlants": 4,
      "numberOfMethods": 1,
      "ownedObjects": {"dummy" : 9}
    };
    validGarden = Garden.fromMap(gardenAttributes);
    expect(validGarden, isA<Garden>());

    /* TODO unfortunately, this test passes. It should not.
         See same example below.
     */
/*    gardenAttributes = {
      "name": "",
      "city": "",
      "street": "",
      "numberOfStructureElements": 0,
      "numberOfPlants": 0,
      "numberOfMethods": 0,
      "ownedObjects": {}
    };
*/


  });

  test('Invalid gardens', () {

    /* TODO this should not be valid: a garden should have a name and an address
         linked to it. A "" just makes no sense.
     */
    gardenAttributes = {
      "name": "",
      "city": "",
      "street": "",
      "numberOfStructureElements": 0,
      "numberOfPlants": 0,
      "numberOfMethods": 0,
      "ownedObjects": {}
    };
    // expect(() => Garden.fromMap(gardenAttributes), .....);

    gardenAttributes = {
      "name": null,
      "city": "Locarno",
      "street": "via G.G. Nessi 4B",
      "numberOfStructureElements": 2,
      "numberOfPlants": 4,
      "numberOfMethods": 1,
      "ownedObjects": {}
    };
    expect(() => Garden.fromMap(gardenAttributes), throwsAssertionError);

    gardenAttributes = {
      "name": "Mr. Lewis' Garden",
      "city": null,
      "street": "via G.G. Nessi 4B",
      "numberOfStructureElements": 2,
      "numberOfPlants": 4,
      "numberOfMethods": 1,
      "ownedObjects": {}
    };
    expect(() => Garden.fromMap(gardenAttributes), throwsAssertionError);

    gardenAttributes = {
      "name": "Mr. Lewis' Garden",
      "city": "Locarno",
      "street": null,
      "numberOfStructureElements": 2,
      "numberOfPlants": 4,
      "numberOfMethods": 1,
      "ownedObjects": {}
    };
    expect(() => Garden.fromMap(gardenAttributes), throwsAssertionError);

    gardenAttributes = {
      "name": "Mr. Lewis' Garden",
      "city": "Locarno",
      "street": "via G.G. Nessi 4B",
      "numberOfStructureElements": "2", // this should be a int, not String
      "numberOfPlants": 4,
      "numberOfMethods": 1,
      "ownedObjects": {}
    };
    expect(() => Garden.fromMap(gardenAttributes), throwsA(isA<TypeError>()));

    gardenAttributes = {
      "name": "Mr. Lewis' Garden",
      "city": "Locarno",
      "street": "via G.G. Nessi 4B",
      "numberOfStructureElements": 2,
      "numberOfPlants": null, // should be a int
      "numberOfMethods": 1,
      "ownedObjects": {}
    };
    expect(() => Garden.fromMap(gardenAttributes), throwsAssertionError);

    gardenAttributes = {
      "name": "Mr. Lewis' Garden",
      "city": "Locarno",
      "street": "via G.G. Nessi 4B",
      "numberOfStructureElements": 2,
      "numberOfPlants": 4,
      "numberOfMethods": null,
      "ownedObjects": {}
    };
    expect(() => Garden.fromMap(gardenAttributes), throwsAssertionError);

    gardenAttributes = {
      "name": "Mr. Lewis' Garden",
      "city": "Locarno",
      "street": "via G.G. Nessi 4B",
      "numberOfStructureElements": 2,
      "numberOfPlants": 4,
      "numberOfMethods": 1,
      "ownedObjects": null
    };
    expect(() => Garden.fromMap(gardenAttributes), throwsAssertionError);

  });

}