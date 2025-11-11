import 'package:blood_glucose_monitor/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  late final AuthService _service;

  AuthState state;

  AuthController() : state = AuthState(), _service = AuthService();

  Future signIn(String email, String password) async {
    if (state.isLoading) return null;

    try {
      state = state.copyWith(isLoading: true, hasError: false);
      notifyListeners();
      await _service.signIn(email, password);
    } catch (e) {
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
  }

  Future signUp({
    required String email,
    required String username,
    required String password,
    String profilePhoto = '',
  }) async {
    if (state.isLoading) return null;

    try {
      state = state.copyWith(isLoading: true, hasError: false);
      notifyListeners();
      await _service.signUp(
        email: email,
        username: username,
        password: password,
      );
    } catch (e) {
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
