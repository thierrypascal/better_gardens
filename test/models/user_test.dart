import 'package:biodiversity/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../facebook_mock/mock_storage_provider.dart';

const name = 'Gabriel';
const pw = '123456';
const email = 'gabriel@tester.com';

void main() {
  final testUser = User.empty(MockStorageProvider());

  test('User test', () async {
    testUser.updateUserData(
        newName: 'Manu', newSurname: 'surname', newNickname: 'theTester');
    expect(testUser.name, 'Manu', reason: 'name was set wrong');
    expect(testUser.surname, 'surname', reason: 'Surname was set wrong');
    expect(testUser.nickname, 'theTester', reason: 'Nickname was set wrong');
    testUser.updateUserData(newName: '');
    expect(testUser.name, '', reason: 'Should be an empty string');
  });

  test('User like element', () async {
    expect(testUser.doesLikeElement('plant'), false,
        reason: 'Should not like element before it is liked');
    testUser.likeUnlikeElement('plant');
    expect(testUser.doesLikeElement('plant'), true,
        reason: 'Should like element after like action');
    testUser.likeUnlikeElement('plant');
    expect(testUser.doesLikeElement('plant'), false,
        reason: 'Should not like element anymore after unlike action');
  });
}
