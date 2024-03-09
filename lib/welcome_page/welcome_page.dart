import 'package:facultyreservation/main.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class WelcomeScreen extends StatelessWidget {
  final Duration duration = const Duration(milliseconds: 800);

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
   Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 211, 21, 21),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 241, 82, 50).withOpacity(0.8),
              Color.fromARGB(255, 241, 82, 50),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                "assets/blood_drop.png",
                color: Color.fromARGB(255, 245, 242, 242),
                scale: 0.5,
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              duration: duration,
              delay: const Duration(milliseconds: 1600),
              child: const Text(
                "Welcome!",
                style: TextStyle(
                  color: Color.fromARGB(255, 250, 247, 247),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FadeInUp(
              duration: duration,
              delay: const Duration(milliseconds: 1000),
              child: const Text(
                "Where Every Drop Contents! – Ready To Save Lives?.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.2,
                  color: Color.fromARGB(255, 4, 4, 4),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Container()),
            FadeInUp(
              duration: duration,
              delay: const Duration(milliseconds: 600),
              child: SButton(
                size: size,
                borderColor: const Color.fromARGB(255, 8, 3, 3),
                color: Color.fromARGB(255, 250, 139, 184),
                icon: Icons.play_arrow,
                text: "Start Now",
                textStyle: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 6, 6, 6),
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppPages()),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 70,
            ),
           
         //
          ],
        ),
      ),
  
    );
  }
}

class SButton extends StatelessWidget {
  const SButton({
    Key? key,
    required this.size,
    required this.color,
    required this.borderColor,
    required this.icon,
    required this.text,
    required this.textStyle,
    required this.onTap, // New parameter
  }) : super(key: key);

  final Size size;
  final Color color;
  final Color borderColor;
  final IconData icon;
  final String text;
  final TextStyle? textStyle;
  final VoidCallback onTap; // New parameter

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Use the onTap callback
      child: Container(
        width: size.width / 1.2,
        height: size.height / 15,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
