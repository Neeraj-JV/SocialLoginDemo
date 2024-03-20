// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:social_login_demo/firebase/home.dart';
import 'package:social_login_demo/google/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LoginScreen());
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _MyAppState();
}

class _MyAppState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String userNumber = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  var otpFieldVisibility = false;
  var receivedID = '';

  void verifyUserPhoneNumber() {
    auth.verifyPhoneNumber(
      phoneNumber: userNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth
            .signInWithCredential(credential)
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                  Authentication.customSnackBar(
                    content: 'Logged In Successfully',
                  ),
                ));
      },
      verificationFailed: (FirebaseAuthException e) {
        showErrorDialog(e.message.toString());
      },
      codeSent: (String verificationId, int? resendToken) {
        receivedID = verificationId;
        otpFieldVisibility = true;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyOTPCode() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: receivedID,
        smsCode: otpController.text,
      );

      await auth.signInWithCredential(credential).then((value) {
        String? uid = value.user!.uid;
        String? phoneNumber = value.user!.phoneNumber;

        print(uid + '\n' + phoneNumber.toString());

        showAlertDialog('Login Success', uid);
      });
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Phone Authentication',
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IntlPhoneField(
                controller: phoneController,
                initialCountryCode: 'IN',
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  userNumber = val.completeNumber;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Visibility(
                visible: otpFieldVisibility,
                child: TextField(
                  controller: otpController,
                  decoration: const InputDecoration(
                    hintText: 'OTP Code',
                    labelText: 'OTP',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (otpFieldVisibility) {
                  verifyOTPCode();
                } else {
                  verifyUserPhoneNumber();
                }
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Text(
                otpFieldVisibility ? 'Login' : 'Verify',
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: Center(child: Text(message)),
          content: const SingleChildScrollView(),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: const Text('Try Again'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showAlertDialog(String message, String uid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: Center(child: Text(message)),
          content: const SingleChildScrollView(),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();

                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          Home(message: 'Login Success', uid: uid),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;

      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: '',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: '',
    androidClientId:
        '',
    iosClientId:
        '',
    iosBundleId: '',
  );
}
