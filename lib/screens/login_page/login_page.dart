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
        SignInButton(
            name: "Google",
            signInFunction:
                Provider.of<User>(context, listen: false).signInWithGoogle),
        SignInButton(
            name: "Facebook",
            signInFunction:
                Provider.of<User>(context, listen: false).signInWithFacebook),
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

/// Button which handles the google sign in process
class SignInButton extends StatelessWidget {
  /// Displayed text on the button
  final String name;

  /// Function of User to sign-in with the appropriate provider
  final Function() signInFunction;

  /// creates a button with some simple text on it (bsp. Google)
  /// which handles the sign in process for the given provider
  SignInButton({@required this.name, @required this.signInFunction});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleSignIn(context, signInFunction: signInFunction),
      style: _buttonStyle,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Text(name),
      ),
    );
  }

  Future<void> _handleSignIn(BuildContext context,
      {@required Function() signInFunction}) async {
    final result = await signInFunction();
    if (result == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Anmeldung erfolgreich"),
      ));
      return;
    }
    if (!result.isRegistered) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Du bist noch nicht registriert mit deinem account.\n"
              "Bitte registriere dich zuerst, bevor du dich anmeldest.")));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(result.message),
      ));
    }
  }
}
