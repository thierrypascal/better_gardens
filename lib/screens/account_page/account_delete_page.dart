import 'package:biodiversity/components/edit_dialog.dart';
import 'package:biodiversity/components/white_redirect_page.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/login_page.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Delete account
class MyAccountDelete extends StatefulWidget {
  ///Delete account
  MyAccountDelete({Key key}) : super(key: key);

  @override
  _MyAccountDeleteState createState() => _MyAccountDeleteState();
}

class _MyAccountDeleteState extends State<MyAccountDelete> {
  final _formKey = GlobalKey<FormState>();
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return EditDialog(
      isScrollable: false,
      title: 'Account löschen',
      abortCallback: () {
        Navigator.pop(context);
      },
      save: 'Löschen',
      saveIcon: Icons.delete_forever,
      saveCallback: () async {
        String res;

        if (user.isRegisteredWithEmail) {
          _formKey.currentState.save();
          res = await user.reauthenticate_with_email(_password);
        } else {
         res = await user.reauthenticate();
        }
        if (res == null) {
          _confirm_delete(context);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$res')));
        }
      },
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (user.isRegisteredWithEmail)
            Form(
              key: _formKey,
              child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    helperText:
                        'Bitte gib dein Passwort ein um deinen Account zu löschen',
                    labelText: 'Passwort',
                  ),
                  onSaved: (password) async {
                    _password = password;
                  }),
            ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Folgendes wird gelöscht:',
                style: TextStyle(fontSize: 20)),
          ),
          const Padding(
            padding:  EdgeInsets.fromLTRB(8.0, 8, 0, 8),
            child: Text('- Dein Account', style:  TextStyle(fontSize: 16)),
          ),
          const Padding(
            padding:  EdgeInsets.fromLTRB(8.0, 8, 0, 8),
            child: Text('- Folgende Gärten', style:  TextStyle(fontSize: 16)),
          ),
          if (user.gardens.isNotEmpty)
            Expanded(
              child: ListView(
                children: List.generate(user.gardens.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 0),
                    child: Text('- ${user.gardens.elementAt(index)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  void _confirm_delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                  'Willst den Account und all deine Gärten unwiderruflich löschen?'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFC05410)),
                    ),
                    child: const Text('Abbrechen'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFC05410)),
                    ),
                    label: const Text('Löschen'),
                  ),
                ],
              ),
            )).then((value) async {
      if (value != null) {
        String res;
        final user = Provider.of<User>(context, listen: false);
        ServiceProvider.instance.gardenService.deleteAllGardensFromUser(user);
        res = await user.deleteAccount();
        await user.signOut(save: false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WhiteRedirectPage('$res', LoginPage())),
        );
      }
      ;
    });
  }
}
