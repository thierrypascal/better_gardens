import 'package:flutter_test/flutter_test.dart';
import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/my_garden_page/my_garden_page.dart';

void main() {
  test('garden creation', () async {
    FirebaseFirestore.instance.doc('gardens/testgarden').get();

    Map<String, int> ownedObjects = { 'Test tree':1, 'Test tree 2':4 };
    //Garden g = Garden('Tagesschule nach M. Montessori (Hof)', 'Herzogstrasse 11a', 'Brugg', 2, 2, 2, reference, ownedObjects);
  });
  test('remove from map', () async {

  });
}