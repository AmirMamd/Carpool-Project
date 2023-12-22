import 'package:cloud_firestore/cloud_firestore.dart';

class RouteService {
  static Stream<List<QueryDocumentSnapshot>> removeDuplicateLocations(Stream<List<QueryDocumentSnapshot>> initialStream) async* {
    List<List<QueryDocumentSnapshot>> allSnapshots = [];

    await for (List<QueryDocumentSnapshot> snapList in initialStream) {
      List<QueryDocumentSnapshot> filteredSnapshots = [];

      for (var i = 0; i < snapList.length; i++) {
        bool foundDuplicate = false;
        for (var j = i + 1; j < snapList.length; j++) {
          // Compare names and remove duplicates
          if (snapList[i]['name'] == snapList[j]['name']) {
            foundDuplicate = true;
            break;
          }
        }
        if (!foundDuplicate) {
          filteredSnapshots.add(snapList[i]);
        }
      }

      allSnapshots.add(filteredSnapshots);
      yield filteredSnapshots; // Yield the list after removing duplicates
    }
  }
}
