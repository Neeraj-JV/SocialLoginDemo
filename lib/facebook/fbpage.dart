import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:social_login_demo/res/custom_colors.dart';

class FbPage extends StatefulWidget {
  const FbPage({super.key});

  @override
  FbPageState createState() => FbPageState();
}

class FbPageState extends State<FbPage> {
  bool _isLoggedIn = false;
  Map _userObj = {};
  AccessToken? accessToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        backgroundColor: CustomColors.firebaseNavy,
      ),
      body: Container(
        child: _isLoggedIn
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Image.network(
                          _userObj["picture"]["data"]["url"],
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),

                    //  Image.network(_userObj["picture"]["data"]["url"]),
                    Text(
                      _userObj["name"],
                      style: TextStyle(
                        color: CustomColors.firebaseGrey,
                        fontSize: 26,
                      ),
                    ),
                    Text(
                      _userObj["email"],
                      style: TextStyle(
                        color: CustomColors.firebaseGrey,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blueAccent,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        FacebookAuth.instance.logOut().then((value) {
                          setState(() {
                            _isLoggedIn = false;
                            _userObj = {};
                          });
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: ElevatedButton(
                  child: const Text("Login with Facebook"),
                  onPressed: () async {
                    FacebookAuth.instance.login(
                        permissions: ["public_profile", "email"]).then((value) {
                      String accessToken = value.accessToken!.token;
                      print(accessToken);
                      FacebookAuth.instance.getUserData().then((userData) {
                        setState(() {
                          _isLoggedIn = true;
                          _userObj = userData;
                        });
                      });
                    });
                  },
                ),
              ),
      ),
    );
  }
}
