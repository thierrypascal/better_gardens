import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/text_field_with_descriptor.dart';
import 'package:biodiversity/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays the page with account information
class AccountPage extends StatefulWidget {
  /// Displays the page with account information
  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            color: Theme.of(context).colorScheme.primaryVariant,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Image.network(user.imageURL,
                        errorBuilder: (context, error, trace) {
                      return const Icon(
                        Icons.person,
                        size: 60,
                      );
                    }),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        user.name == '' ? user.nickname : user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      Text(
                        user.mail,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (bc) => [
              PopupMenuItem(
                value: 'EditProfilePage',
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Text('Profil bearbeiten')
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'ChangePasswordPage',
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.lock_open,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Text('Passwort ändern')
                  ],
                ),
              ),
            ],
            onSelected: _handleTopMenu,
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(0, 32, 0, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFieldWithDescriptor(
                      'Name',
                      Text('${user.name}'
                          ' ${user.surname}')),
                  TextFieldWithDescriptor('Email', Text(user.mail)),
                  TextFieldWithDescriptor('Benutzername', Text(user.nickname))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays a popup dialogue that allows
  /// to change the fields of the User Object
  _handleTopMenu(String value) {
    final _formKey = GlobalKey<FormState>();
    String _name;
    String _surname;
    String _nickname;
    String _email;
    String _url;

    final user = Provider.of<User>(context, listen: false);
    bool _showNameOnMap = user.showNameOnMap;
    bool _showGardenImageOnMap = user.showGardenImageOnMap;
    switch (value) {
      case 'EditProfilePage':
        {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              insetPadding: const EdgeInsets.all(5),
              scrollable: true,
              title: const Center(child: Text('Profil bearbeiten')),
              content: StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Image.network(user.imageURL,
                                errorBuilder: (context, error, trace) {
                              return const Icon(
                                Icons.person,
                                size: 80,
                              );
                            }),
                          ),
                          TextButton(
                            onPressed: () => {},
                            child: const Text(
                                'Profilbild ändern'), //TODO let user choose from gallery
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              initialValue: user.name,
                              decoration: const InputDecoration(
                                  labelText: 'Vorname',
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 4)),
                              onSaved: (value) => _name = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextFormField(
                              initialValue: user.surname,
                              decoration: const InputDecoration(
                                  labelText: 'Nachname',
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 4)),
                              onSaved: (value) => _surname = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextFormField(
                              initialValue: user.mail,
                              decoration: const InputDecoration(
                                  labelText: 'Email',
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 4)),
                              onSaved: (value) => _email = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextFormField(
                              initialValue: user.nickname,
                              decoration: const InputDecoration(
                                  labelText: 'Benutzername',
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 4)),
                              onSaved: (value) => _nickname = value,
                            ),
                          ),
                          SwitchListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: const Text(
                                  'Benutzername auf Karte anzeigen'),
                              value: _showNameOnMap,
                              onChanged: (value) => {
                                    setState(() => {_showNameOnMap = value})
                                  }),
                          SwitchListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: const Text(
                                  'Bild des Gartens auf de Karte anzeigen'),
                              value: _showGardenImageOnMap,
                              onChanged: (value) => {
                                    setState(
                                        () => {_showGardenImageOnMap = value})
                                  }),
                        ],
                      ),
                    ),
                  );
                },
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.cancel_outlined),
                    ),
                    const Text('Abbrechen')
                  ]),
                ),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState.save();
                    user.updateUserData(
                      newName: _name,
                      newSurname: _surname,
                      newMail: _email,
                      newNickname: _nickname,
                      doesShowNameOnMap: _showNameOnMap,
                      doesShowGardenImageOnMap: _showGardenImageOnMap,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Row(children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.save),
                    ),
                    const Text('Speichern')
                  ]),
                ),
              ],
            ),
          );
          break;
        }
      case 'ChangePasswordPage':
        {
          //TODO Changepassword page

          break;
        }
    }

    ;
  }
}
