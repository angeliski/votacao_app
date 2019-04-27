import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  final GoogleSignInAccount googleUser;

  const HomeScreen(
      {Key key, @required this.googleUser})
      : assert(googleUser != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
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
          ],
        ),
      ),
    );
  }
}
