import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:students_carpool/Firebase/DriverOps.dart';

import '../Service/RequestService.dart';

class RequestOps {

  static Future<void> createRequestRecord(String meetingPoint, DateTime date, String time ,String asset,String? userId) async {
    try {
      Timestamp formattedTimestamp = await RequestService.convertToTimestamp(date, time);
      // Find the driver by asset and get driverId and visitedLocationId
      Map<String, dynamic>? driverData = await DriverOps.findDriverByAsset(asset);

      if (driverData != null) {
        String driverId = driverData['driverId'] as String;
        String visitedLocationId = driverData['visitedLocationId'] as String;

        // Access the Firestore collection reference for Requests
        CollectionReference requests = FirebaseFirestore.instance.collection('Requests');

        // Create a new record with meetingPoint, dateTime, and driverId attributes
        await requests.add({
          'date': formattedTimestamp,
          'driverId': driverId,
          'status' : "Pending",
          'userId': userId,
          'visitedLocationId': visitedLocationId,
          'meetingPoint': meetingPoint,
          // Add more attributes as needed
        });

        print('Request record added to Firestore!');
      } else {
        print('Driver not found for asset: $asset');
      }
    } catch (e) {
      print('Error adding request record: $e');
    }
  }
  static Future<List<Map<String, dynamic>>?> getRequests(String? userId) async {
    try {
      // Access the Firestore collection reference for Requests
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('Requests');

      // Perform a query to get documents that match the given userId
      QuerySnapshot querySnapshot = await requestsCollection.where('userId', isEqualTo: userId).get();

      // Extract data from each document and store it in a List<Map<String, dynamic>>
      List<Map<String, dynamic>> requestsData = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; // Explicit casting
        if (data != null) {
          data['requestId'] = doc.id;
          requestsData.add(data);
        }
      });

      return requestsData;
    } catch (e) {
      print('Error getting requests: $e');
      return null;
    }
  }
  static Future<void> deleteRequest(String requestId) async {
    try {
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('Requests');

      // Delete the document with the specified ID
      await requestsCollection.doc(requestId).delete();

      print('Request deleted successfully!');
    } catch (e) {
      print('Error deleting request: $e');
    }
  }
}
