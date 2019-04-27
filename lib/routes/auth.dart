import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:votacao_app/core/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:votacao_app/routes/home_screen.dart';
import 'package:votacao_app/widgets/google_sign_in_btn.dart';
import 'package:votacao_app/widgets/reactive_refresh_indicator.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AuthState();
  }
}

class _AuthState extends State<AuthScreen> {
  static const String TAG = "AUTH";

  bool _isRefreshing = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount _googleUser;

  Future<Null> _updateRefreshing(bool isRefreshing) async {
    Logger.log(TAG,
        message: "Setting _isRefreshing ($_isRefreshing) to $isRefreshing");
    if (_isRefreshing) {
      setState(() {
        this._isRefreshing = false;
      });
    }
    setState(() {
      this._isRefreshing = isRefreshing;
    });
  }

  _showErrorSnackbar(String message) {
    _updateRefreshing(false);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  _finishSignIn() async {
    Navigator.of(context).pushReplacement(CupertinoPageRoute(
      builder: (context) => HomeScreen(
            googleUser: _googleUser,
          ),
    ));
  }

  Future<Null> _signIn() async {
    GoogleSignInAccount user = _googleSignIn.currentUser;
    Logger.log(TAG, message: "Just got user as: $user");

    final onError = (exception, stacktrace) {
      Logger.log(TAG, message: "Error from _signIn: $exception");
      _showErrorSnackbar(
          "Couldn't log in with your Google account, please try again!");
      user = null;
    };

    if (user == null) {
      user = await _googleSignIn.signIn().catchError(onError);
      Logger.log(TAG, message: "Received $user");
      final GoogleSignInAuthentication googleAuth = await user.authentication;
      Logger.log(TAG, message: "Added googleAuth: $googleAuth");
      await _auth
          .signInWithCredential(GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ))
          .catchError(onError);
    }

    if (user != null) {
      _updateRefreshing(false);
      this._googleUser = user;
      _finishSignIn();
      return null;
    }
    return null;
  }

  Widget _buildSocialLoginBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 24.0),
          GoogleSignInButton(
            onPressed: () => _updateRefreshing(true),
          ),
        ],
      ),
    );
  }

  Future<Null> _onRefresh() async {
    return await _signIn();
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _updateRefreshing(true));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(elevation: 0.0),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: ReactiveRefreshIndicator(
          onRefresh: _onRefresh,
          isRefreshing: _isRefreshing,
          child: Container(child: _buildSocialLoginBody()),
        ),
      ),
    );
  }
}
