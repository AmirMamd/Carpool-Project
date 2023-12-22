import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';

import '../Log/StatusHistory.dart';
import '../Routes/DetailsFromFaculty.dart';
class DriverOps {
  static Future<String?> findDriverByVisitedLocationId(String? visitedLocationId) async {
    try {
      QuerySnapshot driversSnapshot = await FirebaseFirestore.instance.collection('Drivers').get();

      for (QueryDocumentSnapshot drivers in driversSnapshot.docs) {
        final QuerySnapshot visitedLocationsSnapshot =
        await drivers.reference.collection('VisitedLocations').get();

        for (QueryDocumentSnapshot visitedLocation in visitedLocationsSnapshot.docs) {
          if (visitedLocation.id == visitedLocationId) {
            // Return the ID of the driver associated with the matching visitedLocationId
            return drivers.id;
          }
        }
      }

      // If no matching document is found, return null or handle accordingly
      return null;
    } catch (e) {
      print('Error finding driver visited location by asset: $e');
      return null;
    }
  }



  static Future<Map<String, dynamic>?> getLocationDetails(String visitedLocationId) async {
    try {
      final QuerySnapshot driversSnapshot = await FirebaseFirestore.instance.collection(
          'Drivers').get();
      for (final QueryDocumentSnapshot driverDoc in driversSnapshot.docs) {
        final QuerySnapshot visitedLocationsSnapshot =
        await driverDoc.reference.collection('VisitedLocations').get();


        for (final QueryDocumentSnapshot visitedLocationDoc in visitedLocationsSnapshot.docs) {
          if (visitedLocationId == visitedLocationDoc.id) {
            final imageUrl = visitedLocationDoc['imageUrl'];
            final name = visitedLocationDoc['name'];
            final price = visitedLocationDoc['price'].toDouble();

            return {
              'imageUrl': imageUrl,
              'name': name,
              'price': price,
            };
          }
        }
      }
    } catch (e) {
      print('Error fetching visited location details: $e');
    }
    return null;
  }
  static Future<List<Map<String, dynamic>>?> getAllLocationDetails() async {
    try {
      final QuerySnapshot driversSnapshot =
      await FirebaseFirestore.instance.collection('Drivers').get();

      List<Map<String, dynamic>> allLocations = [];

      for (final QueryDocumentSnapshot driverDoc in driversSnapshot.docs) {
        final QuerySnapshot visitedLocationsSnapshot =
        await driverDoc.reference.collection('VisitedLocations').get();

        for (final QueryDocumentSnapshot visitedLocationDoc
        in visitedLocationsSnapshot.docs) {
          final id = visitedLocationDoc.id;
          final imageUrl = visitedLocationDoc['imageUrl'];
          final name = visitedLocationDoc['name'];
          final price = visitedLocationDoc['price'].toDouble();

          allLocations.add({
            'id' : id,
            'imageUrl': imageUrl,
            'name': name,
            'price': price,
          });
        }
      }

      return allLocations;
    } catch (e) {
      print('Error fetching all visited location details: $e');
      return null;
    }
  }
// Define a function to fetch all visited locations across Doctor documents

  static Future<List<DriverPrice>> getDriversVisitedLocation(String locationName) async {
    List<DriverPrice> driversList = [];

    // Get all drivers
    QuerySnapshot driversSnapshot = await FirebaseFirestore.instance.collection('Drivers').get();

    // Loop through each driver
    for (QueryDocumentSnapshot driverDoc in driversSnapshot.docs) {
      String driverName = driverDoc['fullname'];
      String email = driverDoc['email'];

      // Get visited locations of the current driver
      QuerySnapshot visitedLocationsSnapshot =
      await driverDoc.reference.collection('VisitedLocations').where('name', isEqualTo: locationName).get();

      // Check if the location exists for the current driver
      if (visitedLocationsSnapshot.docs.isNotEmpty) {
        // Extract price and create DriverPrice object
        int visitedLocationPrice = visitedLocationsSnapshot.docs.first['price'];
        driversList.add(DriverPrice(driverDoc.id,driverName, email, visitedLocationPrice));
      }
    }

    return driversList;
  }

  static Stream<List<QueryDocumentSnapshot>> getAllVisitedLocationsStream() async* {
    QuerySnapshot driversSnapshot = await FirebaseFirestore.instance.collection('Drivers').get();

    List<Stream<QuerySnapshot>> streamsList = [];

    for (QueryDocumentSnapshot driverDoc in driversSnapshot.docs) {
      CollectionReference visitedLocationsRef = driverDoc.reference.collection('VisitedLocations');
      streamsList.add(visitedLocationsRef.snapshots());
    }

    Stream<QuerySnapshot> mergedStream = StreamGroup.merge(streamsList);

    List<QueryDocumentSnapshot> allSnapshots = [];

    await for (QuerySnapshot snap in mergedStream) {
      for (QueryDocumentSnapshot doc in snap.docs) {
        allSnapshots.add(doc);
        yield allSnapshots; // Yield the accumulated list after adding each document
      }
    }
  }
  static Future<DriverDetails?> getDriverDetailsById(String? driverId) async {
    try {
      DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance.collection('Drivers').doc(driverId).get();

      if (driverSnapshot.exists) {
        Map<String, dynamic>? driverData = driverSnapshot.data() as Map<String, dynamic>?;

        if (driverData != null) {
          return DriverDetails(
            id: driverSnapshot.id,
            email: driverData['email'] ?? '',
            fullname: driverData['fullname'] ?? '',
            phoneNumber: driverData['phoneNumber'] ?? '',
          );
        }
      }

      // If the document doesn't exist or data is null, return null or handle accordingly
      return null;
    } catch (e) {
      print('Error fetching driver details: $e');
      return null;
    }
  }




}