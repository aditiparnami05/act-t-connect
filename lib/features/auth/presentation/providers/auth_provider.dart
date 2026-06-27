import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/name_formatter.dart';
import '../../../../shared/data/dummy_data.dart';

const _authKey = 'is_authenticated';
const _rememberKey = 'remember_me';
const _emailKey = 'saved_email';
const _userNameKey = 'saved_user_name';

/// Authentication state management.
class AuthState {
  const AuthState({
    required this.isAuthenticated,
    this.userName = 'User',
    this.email = '',
  });

  final bool isAuthenticated;
  final String userName;
  final String email;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(isAuthenticated: false)) {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_rememberKey) ?? false;
    final isAuth = prefs.getBool(_authKey) ?? false;
    if (remember && isAuth) {
      final email = prefs.getString(_emailKey) ?? DummyData.userEmail;
      final userName =
          prefs.getString(_userNameKey) ?? NameFormatter.fromEmail(email);
      state = AuthState(
        isAuthenticated: true,
        email: email,
        userName: userName,
      );
    }
  }

  Future<String?> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final normalizedEmail = email.trim().toLowerCase();
    final isAdminLogin = normalizedEmail == DummyData.userEmail &&
        password == DummyData.userPassword;
    final isDemoLogin =
        normalizedEmail.contains('@') && password.trim().length >= 6;

    if (!isAdminLogin && !isDemoLogin) {
      return 'Invalid email or password';
    }

    final userName = NameFormatter.fromEmail(normalizedEmail);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authKey, true);
    await prefs.setBool(_rememberKey, rememberMe);
    await prefs.setString(_emailKey, normalizedEmail);
    await prefs.setString(_userNameKey, userName);

    state = AuthState(
      isAuthenticated: true,
      email: normalizedEmail,
      userName: userName,
    );
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authKey, false);
    state = const AuthState(isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final authLoadingProvider = StateProvider<bool>((ref) => false);
