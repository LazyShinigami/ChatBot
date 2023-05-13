import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Handle all authentication shit here
class AuthService {
  final _auth = FirebaseAuth.instance;

  singOut() async {
    await _auth.signOut();
  }

  Stream get authChanges {
    var x = _auth.authStateChanges();
    return x;
  }

  signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return '';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return '';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return '';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  deleteAccount() async {
    await _auth.currentUser!.delete();
    _auth.signOut();
    print('Account Deleted!');
  }
}

// Handle all data detching updating deleting shit here
class Store {
  Store(this.email);
  String email;
  final _store = FirebaseFirestore.instance;
  Stream getUserChatData() {
    var docRef = _store.collection('chats').doc(email).snapshots();
    return docRef;
  }

  addAMessage({required String message, required String sender}) async {
    try {
      await _store.collection('chats').doc(email).set({
        'history': FieldValue.arrayUnion([
          {'msg': message, 'sender': sender}
        ])
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error while adding message to Firebase: $e');
    }
  }

  clearHistory() async {
    try {
      await _store
          .collection('chats')
          .doc(email)
          .update({'history': FieldValue.delete()})
          .then((value) => print("User's history is deleted"))
          .catchError(
              (error) => print("Failed to delete user's history: $error"));
    } catch (e) {
      print('Error while clearing history: $e');
    }
  }

  deleteUserData() async {
    try {
      await _store.collection('chats').doc(email).delete();
    } catch (e) {
      print(e);
    }
  }
}
