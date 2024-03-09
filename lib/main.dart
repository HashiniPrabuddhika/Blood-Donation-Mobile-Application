import 'package:facultyreservation/firebase_options.dart';
import 'package:facultyreservation/welcome_page/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:facultyreservation/home_page/home_page.dart';
import 'package:facultyreservation/login_page/login_page.dart';
import 'package:facultyreservation/signup_page/signup_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 249, 71, 77),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class AppPages extends StatefulWidget {
  const AppPages({Key? key}) : super(key: key);

  @override
  _AppPagesState createState() => _AppPagesState();
}

class _AppPagesState extends State<AppPages> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: 3, // Number of pages
        itemBuilder: (context, index) {
          // Return the corresponding page based on the index
          switch (index) {
            case 0:
              return LoginPage(controller: _pageController);
            case 1:
              return SignupPage(controller: _pageController);
            case 2:
              return HomePage(controller: _pageController);
            default:
              throw Exception("Invalid page index");
          }
        },
      ),
    );
  }
}
