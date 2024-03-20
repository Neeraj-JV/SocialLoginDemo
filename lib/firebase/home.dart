import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Home extends StatefulWidget {
  String? message;
  String? uid;
  Home({super.key, this.message, this.uid});

  @override
  State<Home> createState() => _MyAppState();
}

class _MyAppState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createUser();
  }

  // @override
  // Future<void> initState() async {
  //   createUser();
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(child: Text(widget.uid.toString())),
          ],
        ),
      ),
    );
  }

  void createUser() {
    FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        firstName: ' _firstName',
        id: widget.uid!,
        // imageUrl: 'https://i.pravatar.cc/300?u=$_email',
        lastName: '_lastName',
      ),
    );
  }
}
