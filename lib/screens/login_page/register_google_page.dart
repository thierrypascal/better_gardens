import 'package:biodiversity/components/screen_with_logo_and_waves.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Page that handles the registration with google.
/// The page itself doesn't contain any content
class RegisterGooglePage extends StatefulWidget {
  /// Page that handles the registration with google.
  /// The page itself doesn't contain any content
  RegisterGooglePage({Key key}) : super(key: key);

  @override
  _RegisterGooglePageState createState() => _RegisterGooglePageState();
}

class _RegisterGooglePageState extends State<RegisterGooglePage> {
  String _errorText;

  @override
  void initState() {
    super.initState();
    _handleRegistration(context);
  }

  @override
  Widget build(BuildContext context) {
    return LogoAndWavesScreen(
      title: 'Registrieren mit Google',
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
          child: Text('Registrieren'),
          onPressed: () => _handleRegistration(context),
        ),
      ],
    );
  }

  Future<void> _handleRegistration(BuildContext context) async {
    final registerMessage = await Provider.of<User>(context, listen: false)
        .registerWithGoogle(context);
    if (registerMessage == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WelcomePage()));
    } else {
      setState(() {
        _errorText = registerMessage;
      });
    }
  }
}
