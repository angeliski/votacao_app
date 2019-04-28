import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:votacao_app/model/project.dart';
import 'package:votacao_app/widgets/project_card.dart';
import 'package:votacao_app/widgets/project_list.dart';

class HomeScreen extends StatefulWidget {
  final GoogleSignInAccount googleUser;

  const HomeScreen({Key key, @required this.googleUser})
      : assert(googleUser != null),
        super(key: key);

  _HomeState createState() => _HomeState(this.googleUser);
}

class _HomeState extends State<HomeScreen> {
  final GoogleSignInAccount googleUser;
  List<Project> _projects = [];

  _HomeState(this.googleUser);

  @override
  void initState() {
    _projects.add(Project("Alfred 1", "Projeto pra facilitar"));
    _projects.add(Project("Alfred 2", "Projeto pra facilitar"));
    _projects.add(Project("Alfred 3", "Projeto pra facilitar"));
    _projects.add(Project("Alfred 4", "Projeto pra facilitar"));
    _projects.add(Project("Alfred 5", "Projeto pra facilitar"));
    _projects.add(Project("Alfred 6", "Projeto pra facilitar"));
    _projects.add(Project("Alfred 7", "Projeto pra facilitar"));
  }

  // A simple Raised Button that as of now doesn't do anything yet.
  Widget get submitButton {
    return RaisedButton(
      onPressed: () => print('pressed!'),
      child: Text('Confirmar votos', style: TextStyle(color: Colors.white)),
      color: Colors.blueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Offstage(
                offstage: googleUser.photoUrl == null,
                child: CircleAvatar(
                    backgroundImage: NetworkImage(googleUser.photoUrl)),
              ),
              SizedBox(height: 8.0),
              Text(googleUser.displayName, style: theme.textTheme.title),
              Text(googleUser.email),
              ProjectList(_projects),
              submitButton
            ],
          ),
        ),
      ),
    );
  }
}
