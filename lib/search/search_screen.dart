
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/database.dart';

class SearchScreen extends StatefulWidget {
  final ScrollController controller;

  SearchScreen({required this.controller});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String bloodgroup = "";
  List<Map<String, dynamic>> searchResults = [];

  void updateBloodGroupName(String value) {
    setState(() {
      bloodgroup = value;
    });
  }

  void clearbloodgroup() {
    setState(() {
      bloodgroup = "";
      searchResults.clear(); // Clear the search results when clearing the hall name
    });
  }

  Future<void> fetchReservations(String hallName) async {
    try {
      // Replace this with actual logic to fetch reservations from the database
      List<Map<String, dynamic>> results = await DatbaseMethods().getReservationsByBloodGroupName(bloodgroup);

      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print("Not maching blood group: $e");
      Fluttertoast.showToast(
        msg: "Not maching blood group",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 250, 39, 39),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: ListView(
          controller: widget.controller,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBar(
                onSearch: (value) async {
                  // Handle the search button click here
                  print("Search button clicked with blood group: $value");
                  await fetchReservations(value);
                },
                onClear: clearbloodgroup,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Filtered Blood',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 250, 39, 39),),
                    ),
                  ),
                ],
              ),
            ),
            // Display search results
            ...searchResults.map((result) =>BloodType(result)),
            // Add other widgets/components below the SearchBar
            SizedBox(height: 80,),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final void Function(String) onSearch;
  final VoidCallback onClear;

  SearchBar({required this.onSearch, required this.onClear});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Color.fromARGB(255, 4, 4, 4);
    final Color iconColor = Color.fromARGB(255, 250, 39, 39);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter Blood Group',
                hintStyle: TextStyle(color: iconColor),
                contentPadding: const EdgeInsets.all(10.0),
                prefixIcon: Icon(Icons.search, color: iconColor),
              ),
              onChanged: (value) {
                // Handle the hall name changes here
                widget.onSearch(value);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.check, color: iconColor),
            onPressed: () {
              // Trigger the callback when the arrow button is pressed
              widget.onSearch(_searchController.text);
            },
          ),
          IconButton(
            icon: Icon(Icons.clear, color: iconColor),
            onPressed: () {
              // Clear the hall name and trigger the callback
              _searchController.clear();
              widget.onClear();
            },
          ),
        ],
      ),
    );
  }
}

class BloodType extends StatelessWidget {
  final Map<String, dynamic> details;

 BloodType(this.details);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0,right: 20, left: 20),
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
            // image: DecorationImage(
            //   image: AssetImage("assets/reservations.jpg"),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              _buildDataRow("Donor Name", details["Full Name"]),
              _buildDataRow("Age", details["Age"]),
              _buildDataRow("Blood Group", details["Blood Group"]),
              _buildDataRow("Location", details["Location"]),
              _buildDataRow("Phone Number", details["Phone Number"]),
              
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
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
                color: Color.fromARGB(255, 250, 39, 39),
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
}

