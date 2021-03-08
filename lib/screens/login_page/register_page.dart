import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/screens/login_page/register_email_page.dart';
import 'package:biodiversity/screens/login_page/register_facebook_page.dart';
import 'package:biodiversity/screens/login_page/register_google_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// On this page you can choose which provider you want to use to register
class RegisterPage extends StatelessWidget {
  /// On this page you can choose which provider you want to use to register
  RegisterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO use screen_with_logo_and_waves.dart
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrieren'),
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
                    padding: const EdgeInsets.all(30.0),
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 40,
                      buttonColor: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Image(
                              image: AssetImage('res/logo.png'),
                              width: 180,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Registrieren mit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          RaisedButton(
                            elevation: 5,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterEmailPage())),
                            child: const Text('E-Mail'),
                          ),
                          RaisedButton(
                            elevation: 5,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterGooglePage())),
                            child: const Text('Google'),
                          ),
                          RaisedButton(
                            elevation: 5,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterFacebookPage())),
                            child: const Text('Facebook'),
                          ),
                          RaisedButton(
                            elevation: 5,
                            onPressed: () {
                              //TODO add Twitter login
                            },
                            child: const Text('Twitter'),
                          ),
                        ],
                      ),
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
