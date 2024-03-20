import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:social_login_demo/main.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final webview = FlutterWebviewPlugin();

      return WebviewScaffold(
        url: 'http://instagram.com/accounts/logout/',
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: const Icon(Icons.arrow_back),
            title: GestureDetector(
                onTap: () {
                  webview.close();
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => MyApp(),
                    ),
                  );
                },
                child: const Text('Go Back'))),
      );
    });
  }
}
