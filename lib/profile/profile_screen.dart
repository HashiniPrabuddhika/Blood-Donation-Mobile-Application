
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ScrollController controller;

  ProfileScreen({required this.controller});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 248, 86, 86),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              FutureBuilder<User?>(
                future: FirebaseAuth.instance.authStateChanges().first,
                builder: (context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.data != null
                        ? displayUserInformation(context, snapshot.data!)
                        : Text("User not found");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayUserInformation(BuildContext context, User user) {
    TextEditingController emailController =
        TextEditingController(text: user.email ?? 'Anonymous');

    return Center(
      child: Column(
        children: <Widget>[
          imageProfile(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Color.fromARGB(255, 248, 86, 86), // Set the border color here
                ),
                color: Colors.blue[50], // Set the background color here
              ),
              child: TextFormField(
                controller: emailController,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color(0xFF003580)), // Set the label color here
                  border: InputBorder.none,
                ),
                readOnly: true,
              ),
            ),
          ),
          showSignOut(context, user.isAnonymous),
        ],
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: CircleAvatar(
              radius: 80.0,
              backgroundImage: _imageFile == null
                  ? AssetImage('assets/vector-1.jpg')
                  : FileImage(File(_imageFile!.path)) as ImageProvider<Object>?,
            ),
          ),
          Positioned(
            bottom: 40.0,
            left: 130.0,
            child: Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () {
                    showBottomSheet(
                      context: context,
                      builder: (builder) => bottomSheet(context),
                    );
                  },
                  child: Icon(
                    Icons.camera_alt,
                    color: Color.fromARGB(255, 248, 86, 86),
                    size: 40.0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: <Widget>[
          Text("Choose Profile Photo", style: TextStyle(fontSize: 20.0)),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton.extended(
                icon: Icon(Icons.camera_alt, color: Color.fromARGB(255, 250, 68, 68)), // Set the icon color here
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              SizedBox(width: 20.0),
              FloatingActionButton.extended(
                icon: Icon(Icons.image, color: Color.fromARGB(255, 248, 86, 86)), // Set the icon color here
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery"),
              ),
            ],
          ),
        ],
      ),
    );
  }


  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Widget showSignOut(BuildContext context, bool isAnonymous) {
    if (isAnonymous == true) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: Text(
          "Sign In To Save Your Data",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/convertUser');
        },
      );
    } else {
      return SizedBox.shrink(); // This will create an empty space and won't render anything
    }
  }
}
