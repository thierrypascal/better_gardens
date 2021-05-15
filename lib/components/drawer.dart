import 'package:biodiversity/components/white_redirect_page.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/account_page/account_page.dart';
import 'package:biodiversity/screens/favored_list_page/favored_list_page.dart';
import 'package:biodiversity/screens/information_list_page/biodiversity_elements_list_page.dart';
import 'package:biodiversity/screens/login_page/login_page.dart';
import 'package:biodiversity/screens/map_page/maps_page.dart';
import 'package:biodiversity/screens/my_garden_page/my_garden_page.dart';
import 'package:biodiversity/screens/species_list_page/species_list_page.dart';
import 'package:biodiversity/screens/take_home_message_page/take_home_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

/// The Drawer which is located at the right side of the screen
class MyDrawer extends StatelessWidget {
  /// The Drawer which is located at the right side of the screen,
  /// default constructor
  MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: Theme(
        data: ThemeData(
            accentColor: Colors.white30,
            appBarTheme: AppBarTheme(color: Theme.of(context).primaryColorDark),
            scaffoldBackgroundColor: Theme.of(context).colorScheme.primary,
            textTheme: TextTheme(
              bodyText1: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),
            )),
        child: Scaffold(
          appBar: AppBar(),
          body: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: [
                                  const Image(
                                      width: 100,
                                      height: 100,
                                      image: AssetImage('res/Logo_basic.png')),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Better Gardens',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              title: const Text('Mein Garten'),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyGarden()),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('Karte'),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapsPage()),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('Arten'),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SpeciesListPage()),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('Lebensräume'),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BiodiversityElementListPage()),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('Merkliste'),
                              onTap: () {
                                if (Provider.of<User>(context, listen: false)
                                    .isLoggedIn) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FavoredListPage()),
                                  );
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WhiteRedirectPage(
                                              'Bitte melde dich zuerst noch an.',
                                              LoginPage())));
                                }
                              },
                            ),
                            ListTile(
                              title: const Text('Take-Home Messages'),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TakeHomeMessagePage()),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('Account'),
                              onTap: () {
                                if (Provider.of<User>(context, listen: false)
                                    .isLoggedIn) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AccountPage()));
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WhiteRedirectPage(
                                            'Bitte melde Dich zuerst an',
                                            LoginPage())),
                                  );
                                }
                              },
                            ),
                            // ignore: prefer_if_elements_to_conditional_expressions
                            _loginLogoutButton(context),
                            ListTile(
                              title: const Text(
                                'Impressum',
                                style: TextStyle(fontSize: 12),
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        'res/gardenDrawer_color.svg',
                        width: constraints.maxWidth,
                        fit: BoxFit.fitWidth,
                      ),
                    ]),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _loginLogoutButton(BuildContext context) {
    if (Provider.of<User>(context).isLoggedIn) {
      return ListTile(
        title: const Text('Logout'),
        onTap: () => _signOut(context),
      );
    } else {
      return ListTile(
        title: const Text('Login'),
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        ),
      );
    }
  }

  void _signOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ausloggen ?'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: const Text('Ausloggen'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: const Text('Abbrechen'),
                  ),
                ],
              ),
            )).then((value) {
      if (value != null) {
        Provider.of<User>(context, listen: false).signOut();
      }
    });
  }
}
