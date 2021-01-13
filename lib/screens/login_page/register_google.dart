import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/register_page.dart';
import 'package:biodiversity/screens/login_page/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterGooglePage extends StatelessWidget {
  Future<void> _handleRegistration(BuildContext context) async {
    if (Provider.of<User>(context, listen: false).isLoggedIn) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => WelcomePage()));
    } else {
      final signedIn = await Provider.of<User>(context, listen: false)
          .registerWithGoogle(context);
      if (signedIn) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => WelcomePage()));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RegisterPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _handleRegistration(context));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrieren mit Google'),
      ),
      drawer: MyDrawer(),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
