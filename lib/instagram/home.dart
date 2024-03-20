import 'package:flutter/material.dart';
import 'package:social_login_demo/instagram/logout.dart';
import 'package:social_login_demo/res/custom_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key, required this.token, required this.name})
      : super(key: key);
  final String token;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'UserName: $name',
              style: TextStyle(
                color: CustomColors.firebaseGrey,
                fontSize: 26,
              ),
            ),
            Text(
              'Token: $token',
              style: TextStyle(
                color: CustomColors.firebaseGrey,
                fontSize: 12,
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
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const Logout(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  'Log Out',
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
      ),
    );
  }
}
