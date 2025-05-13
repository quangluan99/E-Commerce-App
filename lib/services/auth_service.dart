import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

//Signup
  Future<String?> signUp(
      {required String name,
      required String email,
      required String password,
      required String role}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      //save user data in firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'name': name, 'email': email, 'role': role});
      return null; //successfully : No error message
    } on FirebaseAuthException catch (err) {
      return err.toString(); //error : return the execption message
    }
  }

//Login
  Future<String?> logIn(
      {required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      //fetching the user's role from firestore to determine access level
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      return userDoc.get('role');
    } on FirebaseAuthException catch (err) {
      return err.toString(); //error : return the execption message
    }
  }

  //Logout
  signOut() async {
    await _auth.signOut();
  }
}
