import 'package:biodiversity/components/screen_with_logo_and_waves.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/email_login_page.dart';
import 'package:biodiversity/screens/login_page/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final ButtonStyle _buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.white),
    foregroundColor: MaterialStateProperty.all(Colors.black),
    textStyle: MaterialStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w500, fontSize: 22)));

/// The screen where you can select which method you want to use to sign in
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LogoAndWavesScreen(
      title: "Login",
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Login mit",
          textScaleFactor: 1.5,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmailLoginPage())),
          style: _buttonStyle,
          child: const Text('E-mail'),
        ),
        const SizedBox(
          height: 10,
        ),
        GoogleSignInButton(),
        FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            child: const Text('Sign-Up')),
      ],
    );
  }
}

/// Button which handls the google sign in process
class GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleGoogleSignIn(context),
      style: _buttonStyle,
      child: const Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Text('Google'),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final result =
        await Provider.of<User>(context, listen: false).signInWithGoogle();
    if (result == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Anmeldung erfolgreich"),
      ));
      return;
    }
    if (!result.isRegistered) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Du bist noch nicht registriert mit deinem Google "
              "account.\nBitte registriere dich zuerst, "
              "bevor du dich einloggen kannst.")));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(result.message),
      ));
    }
  }
}
