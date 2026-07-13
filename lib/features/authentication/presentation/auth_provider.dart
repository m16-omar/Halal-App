import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

class SeekerUser {
  final int id;
  final String fullName;
  final String gender;
  final String state;
  final String status;

  SeekerUser({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.state,
    required this.status,
  });

  factory SeekerUser.fromJson(Map<String, dynamic> json) {
    return SeekerUser(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      gender: json['gender'] as String,
      state: json['state'] as String,
      status: json['status'] as String,
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

  void logout() {
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
