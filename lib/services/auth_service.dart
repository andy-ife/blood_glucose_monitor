import 'package:blood_glucose_monitor/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProfile user = UserProfile(); // observable

  // singleton
  static final AuthService _authService = AuthService._internal();
  factory AuthService() => _authService;
  AuthService._internal();

  Future signIn(String email, String password) async {
    try {
      final creds = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = UserProfile(
        email: email,
        username: creds.user!.displayName!,
        id: creds.user!.uid,
        profilePhoto: creds.user!.photoURL!,
      );
      notifyListeners();
    } on Exception {
      user = UserProfile();
      notifyListeners();
      rethrow;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
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
        username: creds.user!.displayName!,
        id: creds.user!.uid,
        profilePhoto: creds.user!.photoURL!,
      );
      notifyListeners();
    } on Exception {
      user = UserProfile();
      notifyListeners();
      rethrow;
    }
  }
}
