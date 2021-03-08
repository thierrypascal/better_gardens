import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';

class FacebookMockUser {
  String name;
  String password;
  String email;
  final String uuid;
  bool signedIn;

  FacebookMockUser(this.name, this.password, this.email)
      : uuid = Uuid().v1(),
        signedIn = false;
}

/// Mocks a FacebookAuth instance with a single User provided at construction
class FacebookAuthMock extends Mock implements FacebookAuth {
  /// mock User
  FacebookMockUser mockUser =
      FacebookMockUser('tester', '123456', 'tester@test.com');

  /// provide the mocked User which will be used to perform all actions
  FacebookAuthMock({mockUser});

  AccessToken _getAccessToken({
    List<String> permissions = const ['email', 'public_profile'],
  }) {
    return AccessToken(grantedPermissions: permissions, userId: mockUser.uuid);
  }

  @override
  Future<AccessToken> login(
      {List<String> permissions = const ['email', 'public_profile'],
      String loginBehavior = LoginBehavior.DIALOG_ONLY,
      bool failLogin}) {
    if (failLogin) {
      throw FacebookAuthException('Login-Abort', 'login aborted by user');
    }
    mockUser.signedIn = true;
    return Future.value(_getAccessToken(permissions: permissions));
  }

  @override
  Future<Function> logOut() {
    mockUser.signedIn = false;
    return null;
  }

  @override
  Future<AccessToken> get isLogged {
    return Future.value(_getAccessToken());
  }

  @override
  Future<Map<String, dynamic>> getUserData(
      {String fields = 'name,email,picture.width(200)'}) {
    return Future.value({});
  }

  @override
  Future<AccessToken> expressLogin() {
    return Future.value(_getAccessToken());
  }
}
