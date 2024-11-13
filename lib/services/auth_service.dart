import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // Register a user and send a verification email
  Future<User?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        String userId = user.uid;
        await user.sendEmailVerification(); // Send verification email

        await firestore.collection('users').doc(userId).set({
          'user_id': userId,
          'email': email,
          'name': name,
          'created_at': Timestamp.now()
        });

        print("User registered and data stored in Firestore!");

        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Handle specific errors related to registration
      if (e.code == 'email-already-in-use') {
        print('The email address is already in use.');
      } else if (e.code == 'weak-password') {
        print('The password is too weak.');
      } else {
        print(e.toString());
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in only if the user's email is verified
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          return user; // Sign in successful for verified users
        } else {
          await _auth.signOut(); // Sign out unverified users
          print('Please verify your email before logging in.');
          return null;
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Handle specific errors related to sign-in
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      } else {
        print(e.toString());
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Send a verification email to the currently signed-in user
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print('Verification email sent.');
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
