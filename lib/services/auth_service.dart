import 'package:blood_glucose_monitor/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProfile? user; // observable

  // singleton
  static final AuthService _authService = AuthService._internal();
  factory AuthService() => _authService;
  AuthService._internal() {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      user = UserProfile(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? "",
        profilePhoto: firebaseUser.photoURL ?? "",
        username: firebaseUser.displayName ?? "",
      );
    }
    notifyListeners();
  }

  Future signIn(String email, String password) async {
    try {
      final creds = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = UserProfile(
        email: email,
        username: creds.user?.displayName ?? "_glucoseboy",
        id: creds.user!.uid,
        profilePhoto: creds.user?.photoURL ?? "nil",
      );
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      user = null;
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }

  Future signUp({
    required String email,
    required String username,
    required String password,
    String profilePhoto = '',
  }) async {
    try {
      final creds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await creds.user!.updateDisplayName(username);
      await creds.user!.updatePhotoURL(profilePhoto);
      await creds.user!.reload();

      await _firestore.collection("users").add({
        "id": creds.user!.uid,
        "username": username,
        "profilePhoto": profilePhoto,
        "email": email,
      });

      user = UserProfile(
        email: email,
        username: username,
        id: creds.user!.uid,
        profilePhoto: profilePhoto,
      );
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }
}
