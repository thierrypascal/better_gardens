import 'package:biodiversity/components/screen_with_logo_and_waves.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The page where you can register with your facebook account
class RegisterFacebookPage extends StatefulWidget {
  @override
  _RegisterFacebookPageState createState() => _RegisterFacebookPageState();
}

class _RegisterFacebookPageState extends State<RegisterFacebookPage> {
  String _errorText;

  @override
  void initState() {
    super.initState();
    _handleRegistration(context);
  }

  @override
  Widget build(BuildContext context) {
    return LogoAndWavesScreen(
      title: "Registrieren mit Facebook",
      children: [
        SizedBox(height: 20),
        if (_errorText != null)
          Text(
            _errorText,
            textScaleFactor: 1.2,
            style: TextStyle(color: Colors.red),
          ),
        if (_errorText != null) SizedBox(height: 10),
        ElevatedButton(
          child: Text("Registrieren"),
          onPressed: () => _handleRegistration(context),
        ),
      ],
    );
  }

  Future<void> _handleRegistration(BuildContext context) async {
    final result = await Provider.of<User>(context, listen: false)
        .registerWithFacebook(context);
    if (result == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WelcomePage()));
    } else {
      setState(() {
        _errorText = result;
      });
    }
  }
}
