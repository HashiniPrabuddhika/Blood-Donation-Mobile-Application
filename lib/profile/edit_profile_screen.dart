import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPasswordScreen extends StatefulWidget {
  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your new password:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextFormField(
              obscureText: true,
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  String newPassword = newPasswordController.text;
                  // Update the user's password
                  await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);

                  // Close the password editing screen
                  Navigator.of(context).pop();
                } catch (e) {
                  print("Error updating password: $e");
                  // Handle error accordingly, e.g., show a message to the user
                }
              },
              child: Text('Save Password'),
            ),
          ],
        ),
      ),
    );
  }
}
