import 'package:crm_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userIdController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final UserRepository userRepository = new UserRepository();
  bool _loading = false;
  final mainKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  set loggedIn(bool logIn) {
    setState(() {
      _loggedIn = logIn;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  set loading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  void doLogin() {
    var form = formKey.currentState;

    final userName = userIdController.text;
    final password = passwordController.text;
    if (form.validate()) {
      loading = true;
      userRepository.validateUser(userName, password).then((user) {
        loading = false;
        UserRepository.currentUser = user;
        Navigator.pushReplacementNamed(context, '/home');
      }, onError: (error) {
        final snackBar = SnackBar(content: Text(error.toString()));
        this.mainKey.currentState.showSnackBar(snackBar);
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _loading
        ? new Container(
            color: Colors.grey[300],
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();

    return new Scaffold(
        key: mainKey,
        appBar: AppBar(title: Text("Login")),
        body: new Form(
          key: formKey,
          child: new Center(
              child:
                  new ListView(padding: EdgeInsets.all(5), children: <Widget>[
            Image.asset(
              "assets/login.png",
              height: 200,
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                  child: Text(
                "Employee Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
            ),
            TextFormField(
                decoration: new InputDecoration(
                    labelText: "User Id",
                    icon: Icon(
                      Icons.face,
                      color: Theme.of(context).accentColor,
                    )),
                controller: userIdController,
                validator: (val) {
                  if (val.length == 0) {
                    return "user id cannot be empty";
                  }
                  return null;
                },
                keyboardType: TextInputType.text),
            TextFormField(
                controller: passwordController,
                decoration: new InputDecoration(
                    labelText: "Password",
                    icon: Icon(
                      FontAwesomeIcons.key,
                      color: Theme.of(context).accentColor,
                    )),
                obscureText: true,
                validator: (val) {
                  if (val.length == 0) {
                    return "Password cannot be empty.";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.text),
            RaisedButton(
              onPressed: doLogin,
              child: Text("Login"),
              color: Theme.of(context).primaryColor,
            ),
            new Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            )
          ])),
        ));
  }
}