import 'package:flutter/material.dart';
import 'package:biodiversity/Drawer.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        drawer: MyDrawer(),
        body: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          'res/logo.png',
                          width: 180,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'john.doe@mail.com',
                        ),
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter password'),
                      ),
                      RaisedButton(child: Text('Login'), onPressed: null),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sign-Up'),
                          Text('Forgot Password?')
                        ],
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
