import 'package:cloud_firestore/cloud_firestore.dart';

class DriverOps {
  static Future<Map<String, dynamic>?> findDriverByAsset(String asset) async {
    try {
      // Access the Firestore collection reference for Drivers
      CollectionReference driversCollection = FirebaseFirestore.instance
          .collection('Drivers');

      // Perform a query to find the document in VisitedLocations subcollection
      QuerySnapshot querySnapshot = await driversCollection.get();

      for (QueryDocumentSnapshot driverDoc in querySnapshot.docs) {
        QuerySnapshot visitedLocationsSnapshot =
        await driverDoc.reference.collection('VisitedLocations').where(
            'imageUrl', isEqualTo: asset).get();

        if (visitedLocationsSnapshot.docs.isNotEmpty) {
          // If a matching VisitedLocation document is found, return its ID and Driver ID
          return {
            'driverId': driverDoc.id,
            'visitedLocationId': visitedLocationsSnapshot.docs.first.id,
          };
        }
      }
      // If no matching document is found, return null or handle accordingly
      return null;
    } catch (e) {
      print('Error finding driver by asset: $e');
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
}