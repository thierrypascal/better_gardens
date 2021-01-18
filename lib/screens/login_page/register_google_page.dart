import 'package:biodiversity/components/screen_with_logo_and_waves.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Page that handles the registration with google.
/// The page itself doesn't contain any content
class RegisterGooglePage extends StatelessWidget {
  Future<void> _handleRegistration(BuildContext context) async {
    if (Provider.of<User>(context, listen: false).isLoggedIn) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WelcomePage()));
    } else {
      final registerSuccessful = await Provider.of<User>(context, listen: false)
          .registerWithGoogle(context);
      if (registerSuccessful) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => WelcomePage()));
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _handleRegistration(context));
    return LogoAndWavesScreen(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
      title: 'Registrieren mit Google',
    );
  }
}
