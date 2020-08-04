import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/provider/image_upload_provider.dart';
import 'package:vulpix/provider/userprovider.dart';
import 'package:vulpix/resources/auth_methods.dart';
import 'package:vulpix/screens/login_screen.dart';
import 'package:vulpix/screens/home_screen.dart';
import 'package:vulpix/screens/searchscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>ImageUploadProvider()),
          ChangeNotifierProvider(create: (context)=>UserProvider()),
          
        ],
          child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
          title: "vulpix",
          debugShowCheckedModeBanner: false,
          initialRoute: "/",
          routes: {
            '/search_screen':(context)=>SearchScreen(),
            '/home_screen':(context)=>HomeScreen(),
          },
          home: FutureBuilder(
            future: _authMethods.getCurrentUser(),
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.hasData) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            },
          )),
    );
  }
}
