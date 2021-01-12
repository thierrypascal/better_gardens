import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterGooglePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<User>(context, listen: false).googleSignIn();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrieren mit Google'),
      ),
      drawer: MyDrawer(),
      body: !Provider.of<User>(context).isLoggedIn
          ? const Center(child: CircularProgressIndicator())
          : const Center(child: Text("Willkommen!")),
    );
  }
}
