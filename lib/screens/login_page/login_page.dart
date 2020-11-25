import 'package:biodiversity/components/drawer.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);
  final TextEditingController _controllerPW = TextEditingController();
  final TextEditingController _controllerEM = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      'res/logo.png',
                      width: 180,
                    ),
                    TextField(
                      controller: _controllerEM,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'john.doe@mail.com',
                      ),
                    ),
                    TextField(
                      controller: _controllerPW,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Password', hintText: 'Enter password'),
                    ),
                    const RaisedButton(
                        onPressed: null,
                        child: Text('Login')
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Sign-Up'), Text('Forgot Password?')],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
