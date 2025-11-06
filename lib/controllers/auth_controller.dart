import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthState state = AuthState();

  Future<UserCredential?> signIn(String email, String password) async {
    if (state.isLoading) return null;

    try {
      state = state.copyWith(isLoading: true, hasError: false);
      notifyListeners();

      final creds = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return creds;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        hasError: true,
        isLoading: false,
        message: e.toString(),
      );
      notifyListeners();

      // give snackbar time to display
      await Future.delayed(Duration(milliseconds: 50));
    } finally {
      state = state.copyWith(hasError: false, isLoading: false);
      notifyListeners();
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserCredential?> signUp({
    required String email,
    required String username,
    required String password,
    String profilePhoto = '',
  }) async {
    if (state.isLoading) return null;

    try {
      state = state.copyWith(isLoading: true, hasError: false);
      notifyListeners();

      final creds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await creds.user!.updateDisplayName(username);
      await creds.user!.updatePhotoURL(profilePhoto);
      await Future.delayed(Duration(seconds: 5), () => creds.user!.reload());

      await _firestore.collection("users").add({
        "id": creds.user!.uid,
        "username": username,
        "profilePhoto": profilePhoto,
        "email": email,
      });

      return creds;
    } on Exception catch (e) {
      state = state.copyWith(
        hasError: true,
        isLoading: false,
        message: e.toString(),
      );
      notifyListeners();

      // give snackbar time to display
      await Future.delayed(Duration(milliseconds: 50));
    } finally {
      state = state.copyWith(hasError: false, isLoading: false);
      notifyListeners();
    }
    return null;
  }
}

class AuthState {
  final bool hasError;
  final bool isLoading;
  final String message;

  const AuthState({
    this.hasError = false,
    this.isLoading = false,
    this.message = '',
  });

  AuthState copyWith({bool? hasError, bool? isLoading, String? message}) {
    return AuthState(
      hasError: hasError ?? this.hasError,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }
}
