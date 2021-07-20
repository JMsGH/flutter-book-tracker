import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_tracker_app/screens/get_started_page.dart';
import 'package:flutter_book_tracker_app/screens/page_not_found.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_book_tracker_app/screens/login_screen.dart';
import 'package:flutter_book_tracker_app/screens/main_screen_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // User? firebaseUser = FirebaseAuth.instance.currentUser;
    // Widget widget;
    // if (firebaseUser != null) {
    //   print(firebaseUser.email);
    //   widget = MainScreenPage();
    // } else {
    //   widget = LoginPage();
    // }

    return MultiProvider(
      providers: [
        StreamProvider<User?>(
          initialData: null,
          create: (context) => FirebaseAuth.instance.authStateChanges(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BookTracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.notoSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => GetStartedPage(),
        //   '/main': (context) => MainScreenPage(),
        //   '/login': (context) => LoginPage(),
        // },
        // home: widget,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          print(settings.name);
          return MaterialPageRoute(
            builder: (context) {
              return RouteController(settingName: settings.name!);
            },
          );
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return PageNotFound();
            },
          );
        },
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  final String settingName;

  const RouteController({Key? key, required this.settingName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User?>(context) != null;
    final notSignedInGotoMain = !userSignedIn &&
        settingName == '/main'; // not signed in and tris to go to main page
    final signedInGotoMain = userSignedIn && settingName == '/main';

    if (settingName == '/') {
      return GetStartedPage();
    } else if (settingName == '/login' || notSignedInGotoMain) {
      return LoginPage();
    } else if (signedInGotoMain) {
      return MainScreenPage();
    } else {
      return PageNotFound();
    }
  }
}
