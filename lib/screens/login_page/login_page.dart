import 'dart:developer' as logging;

import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/user.dart' as biodiversity_user;
import 'package:biodiversity/screens/login_page/register_page.dart';
import 'package:biodiversity/screens/login_page/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      drawer: MyDrawer(),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraint.maxHeight,
                  minWidth: constraint.maxWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'res/logo.png',
                          width: 180,
                        ),
                        _EmailForm(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage()));
                                },
                                child: const Text('Sign-Up')),
                            const Text('Forgot Password?')
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Image(
                    image: AssetImage('res/gardenDrawer.png'),
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmailForm extends StatefulWidget {
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<_EmailForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (value) => _email = value,
            validator: (value) {
              if (value.isEmpty) {
                return "Bitte geben Sie eine Email Adresse ein";
                //match valid email addresses https://stackoverflow.com/a/16888554
              } else if (!RegExp(
                      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$")
                  .hasMatch(value)) {
                return "Bitte geben Sie eine gültige Email Adresse ein";
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'laura.muster@mail.ch',
            ),
          ),
          TextFormField(
            onSaved: (value) => _password = value,
            validator: (value) {
              if (value.isEmpty) {
                return "Bitte geben Sie ein Passwort ein";
              } else {
                return null;
              }
            },
            obscureText: true,
            decoration: const InputDecoration(
                labelText: 'Passwort', hintText: 'Ihr Passwort'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                // save the fields..
                final form = _formKey.currentState;
                if (form.validate()) {
                  form.save();
                  await _loginWithEmail(context);
                }
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Text(
                  'Login',
                  textScaleFactor: 1.6,
                ),
              )),
        ],
      ),
    );
  }

  Future _loginWithEmail(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      Provider.of<biodiversity_user.User>(context, listen: false)
          .loadDetailsFromLoggedInUser();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomePage()));
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          Scaffold.of(context).showSnackBar(const SnackBar(
            content: Text("Die eingegebene Email Adresse ist ungültig."),
          ));
          break;
        case "user-not-found":
          Scaffold.of(context).showSnackBar(const SnackBar(
              content:
                  Text("Die eingegebene Email Adresse ist nicht registriert")));
          break;
        case "wrong-password":
          Scaffold.of(context).showSnackBar(const SnackBar(
              content: Text("Das eingegebene Passwort ist falsch")));
          break;
        default:
          logging.log("error at login", error: error);
      }
    } on Exception catch (error) {
      logging.log("general Exception", error: error);
    }
  }
}
