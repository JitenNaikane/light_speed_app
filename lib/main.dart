import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _loginWithFB() async{


    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false );
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false );
        break;
    }

  }

  _logout(){
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  _loginWithGoogle() async
  {
    try{
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err){
      print(err);
    }
  }
  _logoutGoogle(){
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        title: Text('Social Login',),


      ),
        body: Center(
            child: _isLoggedIn
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               /* Image.network(userProfile["picture"]["data"]["url"], height: 50.0, width: 50.0,),
                Text(userProfile["name"]),
                Text(userProfile["email"]),
                Text(userProfile["id"]),
                OutlineButton(
                  child: Text("Logout From FB") ,
                  onPressed: ()
                  {
                    _logout();
                   },),*/
                Image.network(_googleSignIn.currentUser.photoUrl, height: 50.0, width: 50.0,),
                Text(_googleSignIn.currentUser.displayName),
                Text(_googleSignIn.currentUser.id),

                  OutlineButton( child: Text("Logout From Google"), onPressed: (){
                    _logoutGoogle();
          }
          ) ],
            )
                : Center(
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                 OutlineButton(
                child: Text("Login with Facebook"),
                onPressed: () {
                  _loginWithFB();
                },
              ),OutlineButton(
                      child: Text("Sign in with Google"),
                      onPressed: () {
                        _loginWithGoogle();
                      },
                    )],
            )),
      ),
    ));
  }
}
