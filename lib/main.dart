import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
import 'package:http/http.dart' show BaseRequest, Response;
import 'package:social_login_demo/firebase/login_screen.dart';
import 'package:social_login_demo/google/signinscreen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }  
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '',
    scopes: <String>[GoogleAPI.CalendarApi.calendarScope],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        //getGoogleEventsData();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<List<GoogleAPI.Event>> getGoogleEventsData() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    final GoogleAPIClient httpClient =
        GoogleAPIClient(await googleUser!.authHeaders);

    final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);
    final GoogleAPI.Events calEvents = await calendarApi.events.list(
      "primary",
    );
    final List<GoogleAPI.Event> appointments = <GoogleAPI.Event>[];
    if (calEvents.items != null) {
      for (int i = 0; i < calEvents.items!.length; i++) {
        final GoogleAPI.Event event = calEvents.items![i];
        if (event.start == null) {
          continue;
        }
        appointments.add(event);
      }
    }

    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Calendar'),
      ),
      body: FutureBuilder(
        future: getGoogleEventsData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Stack(
            children: [
              SfCalendar(
                view: CalendarView.month,
                initialDisplayDate: DateTime(2023, 10, 12, 9, 0, 0),
                dataSource: GoogleDataSource(events: snapshot.data),
                monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              ),
              snapshot.data != null
                  ? Container()
                  : const Center(
                      child: CircularProgressIndicator(),
                    )
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_googleSignIn.currentUser != null) {
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
    }

    super.dispose();
  }
}

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource({required List<GoogleAPI.Event>? events}) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.start?.date ?? event.start!.dateTime!.toLocal();
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].start.date != null;
  }

  @override
  DateTime getEndTime(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.endTimeUnspecified != null && event.endTimeUnspecified!
        ? (event.start?.date ?? event.start!.dateTime!.toLocal())
        : (event.end?.date != null
            ? event.end!.date!.add(const Duration(days: -1))
            : event.end!.dateTime!.toLocal());
  }

  @override
  String getLocation(int index) {
    return appointments![index].location ?? '';
  }

  @override
  String getNotes(int index) {
    return appointments![index].description ?? '';
  }

  @override
  String getSubject(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.summary == null || event.summary!.isEmpty
        ? 'No Title'
        : event.summary!;
  }
}

class GoogleAPIClient extends IOClient {
  final Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url,
          headers: (headers != null ? (headers..addAll(_headers)) : headers));
}






// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:social_login_demo/facebook/fbpage.dart';
// import 'package:social_login_demo/firebase/login_screen.dart';
// import 'package:social_login_demo/instagram/instagram_view.dart';
// import 'package:social_login_demo/res/custom_colors.dart';
// import 'package:social_login_demo/google/signinscreen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const Homepage(),
//     );
//   }
// }

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   HomepageState createState() => HomepageState();
// }

// class HomepageState extends State<Homepage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.firebaseNavy,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 16.0,
//             right: 16.0,
//             bottom: 20.0,
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push<void>(
//                       context,
//                       MaterialPageRoute<void>(
//                         builder: (BuildContext context) => const SignInScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     'Login With Google',
//                     style: TextStyle(fontSize: 30, color: Colors.red),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push<void>(
//                       context,
//                       MaterialPageRoute<void>(
//                         builder: (BuildContext context) => const FbPage(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     'Login With Facebook',
//                     style: TextStyle(fontSize: 30, color: Colors.blue),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push<void>(
//                       context,
//                       MaterialPageRoute<void>(
//                         builder: (BuildContext context) =>
//                             const InstagramView(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     'Login With Instagram',
//                     style: TextStyle(fontSize: 30, color: Colors.pink),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push<void>(
//                       context,
//                       MaterialPageRoute<void>(
//                         builder: (BuildContext context) => const LoginScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     'Login With Firebase',
//                     style: TextStyle(fontSize: 30, color: Colors.yellow),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
