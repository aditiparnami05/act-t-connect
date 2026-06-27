import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../data/dummy_data.dart';

const _businessNameKey = 'business_name';

/// Logged-in user + business identity used across invoices and headers.
class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.email,
    required this.businessName,
  });

  final String displayName;
  final String email;
  final String businessName;
}

final userProfileProvider = Provider<UserProfile>((ref) {
  final auth = ref.watch(authProvider);
  final customBusinessName = ref.watch(businessNameProvider);

  if (!auth.isAuthenticated) {
    return UserProfile(
      displayName: 'User',
      email: '',
      businessName: DummyData.businessProfile.name,
    );
  }

  return UserProfile(
    displayName: auth.userName,
    email: auth.email,
    businessName: customBusinessName ?? auth.userName,
  );
});

/// Optional custom business name override (company profile).
final businessNameProvider =
    StateNotifierProvider<BusinessNameNotifier, String?>((ref) {
  return BusinessNameNotifier();
});

class BusinessNameNotifier extends StateNotifier<String?> {
  BusinessNameNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_businessNameKey);
  }

  Future<void> setBusinessName(String name) async {
    state = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_businessNameKey, name);
  }
}
