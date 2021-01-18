import 'package:biodiversity/components/screen_with_logo_and_waves.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/email_login_page.dart';
import 'package:biodiversity/screens/login_page/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The screen where you can select which method you want to use to sign in
class LoginPage extends StatelessWidget {
  final ButtonStyle _buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.white),
      foregroundColor: MaterialStateProperty.all(Colors.black),
      textStyle: MaterialStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w500, fontSize: 22)));

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
        ElevatedButton(
          onPressed: () =>
              Provider.of<User>(context, listen: false).signInWithGoogle(),
          style: _buttonStyle,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Text('Google'),
          ),
        ),
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
