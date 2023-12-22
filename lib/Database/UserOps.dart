import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserOps {
  static Future<String?> findUserIdByEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  static Future<String?> getCurrentUserDocumentId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? userEmail = user.email;
      if (userEmail != null) {
        return await findUserIdByEmail(userEmail);
      }
    }
    return null;
  }
}
