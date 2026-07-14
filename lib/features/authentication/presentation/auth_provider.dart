import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';

class SeekerUser {
  final int id;
  final String fullName;
  final String gender;
  final String state;
  final String status;
  final String waliName;

  SeekerUser({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.state,
    required this.status,
    required this.waliName,
  });

  factory SeekerUser.fromJson(Map<String, dynamic> json) {
    return SeekerUser(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      gender: json['gender'] as String,
      state: json['state'] as String,
      status: json['status'] as String,
      waliName: (json['wali_name'] as String?) ?? '',
    );
  }
}

class AuthState {
  final bool isLoading;
  final SeekerUser? user;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    SeekerUser? user,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  final ApiClient _apiClient = ApiClient();

  @override
  AuthState build() {
    return AuthState();
  }

  // --- PERSISTENCE HELPERS ---
  Future<void> _saveUserToPrefs(SeekerUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user.id);
    await prefs.setString('user_fullname', user.fullName);
    await prefs.setString('user_gender', user.gender);
    await prefs.setString('user_state', user.state);
    await prefs.setString('user_status', user.status);
    await prefs.setString('user_wali_name', user.waliName);
  }

  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_fullname');
    await prefs.remove('user_gender');
    await prefs.remove('user_state');
    await prefs.remove('user_status');
    await prefs.remove('user_wali_name');
  }

  Future<bool> checkAutoLogin() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      if (userId != null) {
        final user = SeekerUser(
          id: userId,
          fullName: prefs.getString('user_fullname') ?? '',
          gender: prefs.getString('user_gender') ?? '',
          state: prefs.getString('user_state') ?? '',
          status: prefs.getString('user_status') ?? 'Unverified',
          waliName: prefs.getString('user_wali_name') ?? '',
        );
        state = AuthState(user: user);
        return true;
      }
      state = AuthState();
      return false;
    } catch (e) {
      state = AuthState(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> isFirstTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasRunBefore = prefs.getBool('has_run_before');
      return hasRunBefore != true;
    } catch (_) {
      return true; // Fallback to first-time user (safe route) if SharedPreferences fails
    }
  }

  Future<void> markOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_run_before', true);
    } catch (_) {
      // Ignore write errors to prevent crashes
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.post('/login/', {
        'email': email,
        'password': password,
      });

      if (response['status'] == 'success') {
        final userData = response['user'];
        final user = SeekerUser.fromJson(userData);
        await _saveUserToPrefs(user);
        await markOnboardingComplete();
        state = AuthState(user: user);
        return true;
      } else {
        state = AuthState(errorMessage: response['message'] ?? 'Login failed');
        return false;
      }
    } catch (e) {
      state = AuthState(errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<void> logout() async {
    await _clearUserFromPrefs();
    state = AuthState();
  }

  void setTemporaryUser({required String fullName, String status = 'Unverified'}) {
    state = AuthState(
      user: SeekerUser(
        id: -1,
        fullName: fullName,
        gender: '',
        state: '',
        status: status,
        waliName: '',
      ),
    );
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String gender,
    required String stateVal,
    required String waliName,
    required String waliRelationship,
    required String waliContact,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.post('/seekers/', {
        'full_name': fullName,
        'email': email,
        'password': password,
        'gender': gender,
        'state': stateVal,
        'wali_name': waliName,
        'wali_relationship': waliRelationship,
        'wali_contact': waliContact,
        'status': 'Unverified',
      });

      if (response['status'] == 'success') {
        final userData = response['user'];
        final user = SeekerUser.fromJson(userData);
        await _saveUserToPrefs(user);
        await markOnboardingComplete();
        state = AuthState(user: user);
        return true;
      } else {
        state = AuthState(errorMessage: response['message'] ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      state = AuthState(errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> submitVerification({
    required int seekerId,
    String documentType = 'Government-Issued ID',
    String documentPreviewUrl = 'https://via.placeholder.com/150',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.post('/verify/', {
        'seeker_id': seekerId,
        'document_type': documentType,
        'document_preview_url': documentPreviewUrl,
      });

      if (response['status'] == 'success') {
        final userData = response['user'];
        final user = SeekerUser.fromJson(userData);
        await _saveUserToPrefs(user);
        state = AuthState(user: user);
        return true;
      } else {
        state = AuthState(errorMessage: response['message'] ?? 'Verification submission failed');
        return false;
      }
    } catch (e) {
      state = AuthState(errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
