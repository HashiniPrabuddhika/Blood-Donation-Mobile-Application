 import 'package:cloud_firestore/cloud_firestore.dart';
class DatbaseMethods{

  Future addDonorDeatails(Map<String,dynamic> donorInfoMap,String id)
  async{ 
    return await FirebaseFirestore.instance
    .collection("Adding")
    .doc(id)
    .set(donorInfoMap);
  }

  Future <Stream<QuerySnapshot>> getDonorDetails() async{
    return await FirebaseFirestore.instance.collection("Adding").snapshots();
  }

   Future updateDonorDetails(Map<String,dynamic> updateInfo,String id)
  async{ 
    return await FirebaseFirestore.instance
    .collection("Adding")
    .doc(id)
    .set(updateInfo);
  }

Future deleteDonorDetails(String id) async {
  return await FirebaseFirestore.instance
      .collection("Adding")
      .doc(id)
      .delete();
}

  
  //  Future deleteBookingDetails(String id)
  // async{ 
  //   return await FirebaseFirestore.instance
  //   .collection("Booking")
  //   .doc(id)
  //   ;
  // }

  Future<List<Map<String, dynamic>>> getReservationsByBloodGroupName(String bloodgroup) async {
    // Replace this with actual logic to fetch reservations from the database
    // based on the hall name
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Adding") 
          .where("Blood Group", isEqualTo: bloodgroup)
          .get();

      return querySnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Not maching blood group: $e");
      throw e;
    }
  }

}
