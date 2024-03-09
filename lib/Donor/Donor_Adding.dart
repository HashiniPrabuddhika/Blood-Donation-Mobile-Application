import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import '../services/database.dart';

class booking extends StatefulWidget {
  const booking({super.key});
  @override
  State<booking> createState() => _bookingState();
}

class _bookingState extends State<booking> {
  TextEditingController fulnamecontroller= new TextEditingController();
  TextEditingController agecontroller= new TextEditingController();
  TextEditingController bloodgroupcontroller= new TextEditingController();
  TextEditingController locationcontroller= new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
      title: const Text(
          'Blood Donor',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 166, 47, 7),
        iconTheme: const IconThemeData(color: Colors.white),
    ),
      body: Container(
        margin: EdgeInsets.only(left:20.0,top:10.0,right: 20.0),
        child: SingleChildScrollView(
          child: Column        
            (crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(height: 30.0,), 
              Text( "Donor Name",
              style:TextStyle(color:Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),),              
              Container( 
                padding: EdgeInsets.only(left: 10.0),
                decoration:BoxDecoration(border:Border.all(),borderRadius:BorderRadius.circular( 10) ),
                child:TextField(
                  controller:fulnamecontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),   
              SizedBox(height: 20.0,),            
              Text( "Age",
              style:TextStyle(color:Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),), 
              Container( 
                padding: EdgeInsets.only(left: 10.0),
                decoration:BoxDecoration(border:Border.all(),borderRadius:BorderRadius.circular( 10) ),
                child:TextField(
                  controller:agecontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),         
              SizedBox(height: 20.0,), 
              Text( "Blood Group",
              style:TextStyle(color:Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),), 
              Container( 
                padding: EdgeInsets.only(left: 8.0),
                decoration:BoxDecoration(border:Border.all(),borderRadius:BorderRadius.circular( 10) ),
                child:TextField(
                  controller:bloodgroupcontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),            
              SizedBox(height: 20.0,),  
              Text( " Location",
              style:TextStyle(color:Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),), 
              Container( 
                padding: EdgeInsets.only(left: 10.0),
                decoration:BoxDecoration(border:Border.all(),borderRadius:BorderRadius.circular( 10) ),
                child:TextField(
                  controller:locationcontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
                
              SizedBox(height: 30.0,),   
                Center(
                  child: ElevatedButton(onPressed:() async{
                      String Id=randomAlphaNumeric(10);
                      Map<String,dynamic>donorInfoMap={
                        "Full Name":fulnamecontroller.text,
                        "Age":agecontroller.text,
                        "Blood Group":bloodgroupcontroller.text,
                        "Id":Id,
                        "Location":locationcontroller.text,
                      };          
                      await DatbaseMethods().addDonorDeatails(donorInfoMap, Id).then((value) =>
                        Fluttertoast.showToast(
                          msg: "Donor has been added successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        )
                      );
                      Navigator.pop(context);

                  },
                  child:Text(
                    "Add Donor",style: TextStyle(
                    color: const Color.fromARGB(255, 183, 151, 151),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color(0xFFfeba02),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.black),
                    ),          
                  ),
                  ),
              ),
            ],                 
          ),
        )
      ),
    );
  }
}
