import 'dart:developer' as logging;

import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/user.dart' as BiodiversityUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'res/logo.png',
                    width: 180,
                  ),
                  TextFormField(
                    onSaved: (value) => _email = value,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'john.doe@mail.com',
                    ),
                  ),
                  TextFormField(
                    onSaved: (value) => _password = value,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Password', hintText: 'Enter password'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        // save the fields..
                        final form = _formKey.currentState;
                        form.save();
                        logging.log("User: $_email:  $_password");

                        // Validate will return true if is valid, or false if invalid.
                        if (form.validate()) {
                          try {
                            final UserCredential _user =
                            await _auth.signInWithEmailAndPassword(
                                email: _email, password: _password);
                            Provider.of<BiodiversityUser.User>(
                                context, listen: false)
                        .;
                        logging.log(_user);
                        } on FirebaseAuthException catch (error) {
                        return logging.log("auth failed", error: error);
                        } on Exception catch (error) {
                        return logging.log("general Exception",
                        error: error);
                        }
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Sign-Up'), Text('Forgot Password?')],
            )
          ],
        ),
      ),
    );
  }
}
