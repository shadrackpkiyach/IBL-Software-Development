import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guiding_light/providers/user_provider.dart';
import 'package:guiding_light/router.dart';
import 'package:guiding_light/screens/authentication_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyDms3y693cboQTyyQt8YYS7_qZsNJcmhT0",
    projectId: "guidinglight-5bd9d",
    storageBucket: "guidinglight-5bd9d.appspot.com",
    messagingSenderId: "381309746274",
    appId: "1:381309746274:web:b4a2c8c2c3c41fe275e53b",
  ));

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'guiding light',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      scaffoldMessengerKey:
          scaffoldMessengerKey, // Set the ScaffoldMessenger key
      home: const Scaffold(
        body: AuthenticationScreen(),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
