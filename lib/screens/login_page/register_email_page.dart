import 'dart:developer' as logging;

import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/privacy_agreement.dart';
import 'package:biodiversity/models/user.dart' as biodiversity_user;
import 'package:biodiversity/screens/login_page/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterEmailPage extends StatefulWidget {
  @override
  _RegisterEmailPageState createState() => _RegisterEmailPageState();
}

class _RegisterEmailPageState extends State<RegisterEmailPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _surname;
  String _nickname;
  String _email;
  String _password;
  bool _readPrivacyAgreement = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrieren mit Email"),
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
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Nickname"),
                                onSaved: (value) => _nickname = value,
                                validator: (value) => value.isEmpty
                                    ? "Bitte ein Nickname eingeben"
                                    : null,
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: "Name"),
                                onSaved: (value) => _name = value,
                                validator: (value) => value.isEmpty
                                    ? "Bitte ein Name eingeben"
                                    : null,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Nachname"),
                                onSaved: (value) => _surname = value,
                                validator: (value) => value.isEmpty
                                    ? "Bitte ein Nachname eingeben"
                                    : null,
                              ),
                              TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: "Email"),
                                  onSaved: (value) => _email = value,
                                  keyboardType: TextInputType.emailAddress,
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
                                  }),
                              TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: "Passwort"),
                                  obscureText: true,
                                  onSaved: (value) => _password = value,
                                  onChanged: (value) => _password = value,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Gib bitte ein Passwort ein";
                                    } else if (value.length < 6) {
                                      return "Dein Passwort muss mindestens 6 Zeichen lang sein";
                                    } else {
                                      return null;
                                    }
                                  }),
                              TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: "Passwort wiederholen"),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Gib bitte ein Passwort ein";
                                    } else if (value != _password) {
                                      return "Die Passwörter stimmen nicht überein";
                                    } else {
                                      return null;
                                    }
                                  }),
                              FormField<bool>(
                                  key: Key(_readPrivacyAgreement.toString()),
                                  initialValue: _readPrivacyAgreement,
                                  onSaved: (value) =>
                                      _readPrivacyAgreement = value,
                                  builder: (FormFieldState<bool> field) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            FlatButton(
                                              onPressed: () async {
                                                final _read =
                                                    await showPrivacyAgreement(
                                                        context);
                                                setState(() {
                                                  _readPrivacyAgreement = _read;
                                                });
                                              },
                                              child: const Text(
                                                  "Ich habe das Privacy-Agreement gelesen."),
                                            ),
                                            Checkbox(
                                              value: field.value,
                                              onChanged: (bool value) {
                                                field.didChange(value);
                                              },
                                            )
                                          ],
                                        ),
                                        if (field.hasError)
                                          Text(
                                            field.errorText,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor,
                                                fontSize: 12),
                                          )
                                      ],
                                    );
                                  },
                                  validator: (value) => value
                                      ? null
                                      : "Bitte lies das Privacy, agreement"),
                              const SizedBox(
                                height: 40,
                              ),
                              ElevatedButton(
                                onPressed: () => _registerWithEmail(context)
                                    .then((value) => null),
                                child: const Text("Registrieren"),
                              ),
                            ],
                          ),
                        )
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

  Future<void> _registerWithEmail(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Provider.of<biodiversity_user.User>(context, listen: false)
            .registerWithEmail(_email, _password,
                name: _name, surname: _surname, nickname: _nickname);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomePage()));
      } on FirebaseAuthException catch (error) {
        logging.log("failed to register user", error: error);
      }
    }
  }
}
