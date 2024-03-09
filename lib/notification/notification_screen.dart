import 'package:flutter/material.dart';
import 'package:facultyreservation/notification/calender.dart';
class NotificationScreen extends StatefulWidget {
  final ScrollController controller;

  NotificationScreen({required this.controller});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 245, 62, 78),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        controller: widget.controller,
        child: Container(
          color: const Color(0xFFFFFFFF),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Text('Calenders', style: TextStyle(color: Color.fromARGB(255, 8, 8, 8), fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      child: Text('Calender', style: TextStyle(color: Color.fromARGB(255, 3, 3, 3))),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TableBasicsExample()),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  ],
                ),
              ),             
              // Add more widgets if needed
            ],
          ),
        ),
      ),
    );
  }
}
