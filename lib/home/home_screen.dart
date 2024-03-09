import 'package:facultyreservation/Donor/Donor_Adding.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/database.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController controller;

  HomeScreen({required this.controller});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController fulnamecontroller = new TextEditingController();
  TextEditingController agecontroller = new TextEditingController();
  TextEditingController bloodgroupcontroller = new TextEditingController();
  TextEditingController locationcontroller = new TextEditingController();

  Stream? reservationStream;

  // Function to get booking details from the database
  getOnLoad() async {
    //reservationstem=
    reservationStream = await DatbaseMethods().getDonorDetails();
    setState(() {});
  }

  @override
  void initState() {
    getOnLoad();
    super.initState();
  }

//allbookingdetails
  Widget allDonorDetails() {
    return StreamBuilder(
      stream: reservationStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            _buildDataRow("Donor Name", ds["Full Name"]),
                            _buildDataRow("Age", ds["Age"]),
                            _buildDataRow("Blood Group", ds["Blood Group"]),
                            _buildDataRow("Location", ds["Location"]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    fulnamecontroller.text = ds["Full Name"];
                                    agecontroller.text = ds["Age"];
                                    bloodgroupcontroller.text =
                                        ds["Blood Group"];
                                    locationcontroller.text = ds["Location"];
                                    EditDonorDetail(ds["Id"]);
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 245, 62, 78),
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                GestureDetector(
                                  onTap: () async {
                                    await DatbaseMethods()
                                        .deleteDonorDetails(ds["Id"]);

                                    // Add your delete logic here

                                    Fluttertoast.showToast(
                                      msg:
                                          "Donor has been deleted successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 245, 62, 78),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container(); // Return an empty container or a loading indicator when there is no data
      },
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 130.0,
            child: Text(
              "$label",
              style: TextStyle(
                color: Color.fromARGB(255, 5, 5, 5),
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Donor List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 245, 62, 78),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: kToolbarHeight + 10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: allDonorDetails(),
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
          Positioned(
            top: 10.0,
            left: 100,
            right: 100,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => booking()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 248, 119, 139),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text(
                      "Add Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> EditDonorDetail(String id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              width: 300.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Donor Name",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: fulnamecontroller,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Age",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: agecontroller,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Blood Group",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: bloodgroupcontroller,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Location",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: locationcontroller,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color.fromARGB(255, 248, 119, 139),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                      onPressed: () async {
                        Map<String, dynamic> updateInfo = {
                          "Full Name": fulnamecontroller.text,
                          "Age": agecontroller.text,
                          "Blood Group": bloodgroupcontroller.text,
                          "Location": locationcontroller.text,
                          "Id": id,
                        };
                        await DatbaseMethods()
                            .updateDonorDetails(updateInfo, id)
                            .then((value) {
                          Fluttertoast.showToast(
                              msg: "Adding has been updated sucessfuly",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.pop(context);
                        });
                      },
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
