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
  final String phoneNumber;
  final String role; // 'seeker' or 'wali'
  final String? email;
  final String? relationship;
  final String? wardName;
  final int? age;
  final String? occupation;
  final String? education;
  final String? islamicLevel;
  final String? modeOfDressing;
  final String? stateOfOrigin;
  final String? currentlyBasedIn;
  final String? tribe;
  final String? maritalStatus;
  final String? children;
  final String? aboutMe;
  final String? spouseAgeRange;
  final String? spouseDesiredQualities;
  final String? spouseMaritalStatus;
  final String? spouseChildrenPref;
  final String? spouseLocation;
  final String? bloodGroup;
  final String? genotype;
  final String? healthStatus;
  final String? appearance;
  final String? openToPolygamy;
  final String? willingToRelocate;
  final String? marriageTimeline;

  SeekerUser({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.state,
    required this.status,
    required this.waliName,
    required this.phoneNumber,
    this.role = 'seeker',
    this.email,
    this.relationship,
    this.wardName,
    this.age,
    this.occupation,
    this.education,
    this.islamicLevel,
    this.modeOfDressing,
    this.stateOfOrigin,
    this.currentlyBasedIn,
    this.tribe,
    this.maritalStatus,
    this.children,
    this.aboutMe,
    this.spouseAgeRange,
    this.spouseDesiredQualities,
    this.spouseMaritalStatus,
    this.spouseChildrenPref,
    this.spouseLocation,
    this.bloodGroup,
    this.genotype,
    this.healthStatus,
    this.appearance,
    this.openToPolygamy,
    this.willingToRelocate,
    this.marriageTimeline,
  });

  factory SeekerUser.fromJson(Map<String, dynamic> json) {
    return SeekerUser(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      gender: (json['gender'] as String?) ?? '',
      state: (json['state'] as String?) ?? '',
      status: (json['status'] as String?) ?? 'Unverified',
      waliName: (json['wali_name'] as String?) ?? '',
      phoneNumber: (json['phone_number'] as String?) ?? '',
      role: (json['role'] as String?) ?? 'seeker',
      email: json['email'] as String?,
      relationship: json['relationship'] as String?,
      wardName: json['ward_name'] as String?,
      age: json['age'] as int?,
      occupation: json['occupation'] as String?,
      education: json['education'] as String?,
      islamicLevel: json['islamic_level'] as String?,
      modeOfDressing: json['mode_of_dressing'] as String?,
      stateOfOrigin: json['state_of_origin'] as String?,
      currentlyBasedIn: json['currently_based_in'] as String?,
      tribe: json['tribe'] as String?,
      maritalStatus: json['marital_status'] as String?,
      children: json['children'] as String?,
      aboutMe: json['about_me'] as String?,
      spouseAgeRange: json['spouse_age_range'] as String?,
      spouseDesiredQualities: json['spouse_desired_qualities'] as String?,
      spouseMaritalStatus: json['spouse_marital_status'] as String?,
      spouseChildrenPref: json['spouse_children'] as String?,
      spouseLocation: json['spouse_location'] as String?,
      bloodGroup: json['blood_group'] as String?,
      genotype: json['genotype'] as String?,
      healthStatus: json['health_status'] as String?,
      appearance: json['appearance'] as String?,
      openToPolygamy: json['open_to_polygamy'] as String?,
      willingToRelocate: json['willing_to_relocate'] as String?,
      marriageTimeline: json['marriage_timeline'] as String?,
    );
  }
}

class AuthState {
  final bool isLoading;
  final SeekerUser? user;
  final String? errorMessage;

  AuthState({this.isLoading = false, this.user, this.errorMessage});

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
    await prefs.setString('user_phone_number', user.phoneNumber);
    await prefs.setString('user_role', user.role);
    if (user.email != null) await prefs.setString('user_email', user.email!);
    if (user.relationship != null)
      await prefs.setString('user_relationship', user.relationship!);
    if (user.wardName != null)
      await prefs.setString('user_ward_name', user.wardName!);
    if (user.age != null) await prefs.setInt('user_age', user.age!);
    if (user.occupation != null) await prefs.setString('user_occupation', user.occupation!);
    if (user.education != null) await prefs.setString('user_education', user.education!);
    if (user.islamicLevel != null) await prefs.setString('user_islamic_level', user.islamicLevel!);
    if (user.modeOfDressing != null) await prefs.setString('user_mode_of_dressing', user.modeOfDressing!);
    if (user.stateOfOrigin != null) await prefs.setString('user_state_of_origin', user.stateOfOrigin!);
    if (user.currentlyBasedIn != null) await prefs.setString('user_currently_based_in', user.currentlyBasedIn!);
    if (user.tribe != null) await prefs.setString('user_tribe', user.tribe!);
    if (user.maritalStatus != null) await prefs.setString('user_marital_status', user.maritalStatus!);
    if (user.children != null) await prefs.setString('user_children', user.children!);
    if (user.aboutMe != null) await prefs.setString('user_about_me', user.aboutMe!);
    if (user.spouseAgeRange != null) await prefs.setString('user_spouse_age_range', user.spouseAgeRange!);
    if (user.spouseDesiredQualities != null) await prefs.setString('user_spouse_desired_qualities', user.spouseDesiredQualities!);
    if (user.spouseMaritalStatus != null) await prefs.setString('user_spouse_marital_status', user.spouseMaritalStatus!);
    if (user.spouseChildrenPref != null) await prefs.setString('user_spouse_children_pref', user.spouseChildrenPref!);
    if (user.spouseLocation != null) await prefs.setString('user_spouse_location', user.spouseLocation!);
    if (user.bloodGroup != null) await prefs.setString('user_blood_group', user.bloodGroup!);
    if (user.genotype != null) await prefs.setString('user_genotype', user.genotype!);
    if (user.healthStatus != null) await prefs.setString('user_health_status', user.healthStatus!);
    if (user.appearance != null) await prefs.setString('user_appearance', user.appearance!);
    if (user.openToPolygamy != null) await prefs.setString('user_open_to_polygamy', user.openToPolygamy!);
    if (user.willingToRelocate != null) await prefs.setString('user_willing_to_relocate', user.willingToRelocate!);
    if (user.marriageTimeline != null) await prefs.setString('user_marriage_timeline', user.marriageTimeline!);
  }

  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_fullname');
    await prefs.remove('user_gender');
    await prefs.remove('user_state');
    await prefs.remove('user_status');
    await prefs.remove('user_wali_name');
    await prefs.remove('user_phone_number');
    await prefs.remove('user_role');
    await prefs.remove('user_email');
    await prefs.remove('user_relationship');
    await prefs.remove('user_ward_name');
    await prefs.remove('user_age');
    await prefs.remove('user_occupation');
    await prefs.remove('user_education');
    await prefs.remove('user_islamic_level');
    await prefs.remove('user_mode_of_dressing');
    await prefs.remove('user_state_of_origin');
    await prefs.remove('user_currently_based_in');
    await prefs.remove('user_tribe');
    await prefs.remove('user_marital_status');
    await prefs.remove('user_children');
    await prefs.remove('user_about_me');
    await prefs.remove('user_spouse_age_range');
    await prefs.remove('user_spouse_desired_qualities');
    await prefs.remove('user_spouse_marital_status');
    await prefs.remove('user_spouse_children_pref');
    await prefs.remove('user_spouse_location');
    await prefs.remove('user_blood_group');
    await prefs.remove('user_genotype');
    await prefs.remove('user_health_status');
    await prefs.remove('user_appearance');
    await prefs.remove('user_open_to_polygamy');
    await prefs.remove('user_willing_to_relocate');
    await prefs.remove('user_marriage_timeline');
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
          phoneNumber: prefs.getString('user_phone_number') ?? '',
          role: prefs.getString('user_role') ?? 'seeker',
          email: prefs.getString('user_email'),
          relationship: prefs.getString('user_relationship'),
          wardName: prefs.getString('user_ward_name'),
          age: prefs.getInt('user_age'),
          occupation: prefs.getString('user_occupation'),
          education: prefs.getString('user_education'),
          islamicLevel: prefs.getString('user_islamic_level'),
          modeOfDressing: prefs.getString('user_mode_of_dressing'),
          stateOfOrigin: prefs.getString('user_state_of_origin'),
          currentlyBasedIn: prefs.getString('user_currently_based_in'),
          tribe: prefs.getString('user_tribe'),
          maritalStatus: prefs.getString('user_marital_status'),
          children: prefs.getString('user_children'),
          aboutMe: prefs.getString('user_about_me'),
          spouseAgeRange: prefs.getString('user_spouse_age_range'),
          spouseDesiredQualities: prefs.getString('user_spouse_desired_qualities'),
          spouseMaritalStatus: prefs.getString('user_spouse_marital_status'),
          spouseChildrenPref: prefs.getString('user_spouse_children_pref'),
          spouseLocation: prefs.getString('user_spouse_location'),
          bloodGroup: prefs.getString('user_blood_group'),
          genotype: prefs.getString('user_genotype'),
          healthStatus: prefs.getString('user_health_status'),
          appearance: prefs.getString('user_appearance'),
          openToPolygamy: prefs.getString('user_open_to_polygamy'),
          willingToRelocate: prefs.getString('user_willing_to_relocate'),
          marriageTimeline: prefs.getString('user_marriage_timeline'),
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

  Future<bool> login({
    String? email,
    String? password,
    String? phone,
    String? otp,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final Map<String, dynamic> body = {};
      if (phone != null && otp != null) {
        body['phone'] = phone;
        body['otp'] = otp;
      } else {
        body['email'] = email ?? '';
        body['password'] = password ?? '';
      }

      final response = await _apiClient.post('/login/', body);

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
      state = AuthState(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _clearUserFromPrefs();
    state = AuthState();
  }

  Future<bool> deleteAccount() async {
    final currentUser = state.user;
    if (currentUser == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiClient.post('/user/delete/', {
        'seeker_id': currentUser.id,
      });

      if (response['status'] == 'success') {
        await _clearUserFromPrefs();
        state = AuthState();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response['message'] ?? 'Failed to delete account.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Connection error while deleting account: $e',
      );
      return false;
    }
  }

  void setTemporaryUser({
    required String fullName,
    String status = 'Unverified',
  }) {
    state = AuthState(
      user: SeekerUser(
        id: -1,
        fullName: fullName,
        gender: '',
        state: '',
        status: status,
        waliName: '',
        phoneNumber: '',
      ),
    );
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String gender,
    required String stateVal,
    required String waliName,
    required String waliRelationship,
    required String waliContact,
    String ageGroup = '',
    String lga = '',
    String occupation = '',
    String practiceLevel = '',
    String timeline = '',
    String expectations = '',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.post('/seekers/', {
        'full_name': fullName,
        'email': email,
        'password': password,
        'phone_number': phoneNumber,
        'gender': gender,
        'state': stateVal,
        'wali_name': waliName,
        'wali_relationship': waliRelationship,
        'wali_contact': waliContact,
        'status': 'Unverified',
        'age_group': ageGroup,
        'lga': lga,
        'occupation': occupation,
        'practice_level': practiceLevel,
        'timeline': timeline,
        'expectations': expectations,
      });

      if (response['status'] == 'success') {
        final userData = response['user'];
        final user = SeekerUser.fromJson(userData);
        await _saveUserToPrefs(user);
        await markOnboardingComplete();
        state = AuthState(user: user);
        return true;
      } else {
        state = AuthState(
          errorMessage: response['message'] ?? 'Registration failed',
        );
        return false;
      }
    } catch (e) {
      state = AuthState(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> registerWali({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String relationship,
    required String wardEmail,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.post('/walis/register/', {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'relationship': relationship,
        'ward_email': wardEmail,
      });

      if (response['status'] == 'success') {
        final userData = response['user'];
        final user = SeekerUser.fromJson(userData);
        await _saveUserToPrefs(user);
        await markOnboardingComplete();
        state = AuthState(user: user);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response['message'] ?? 'Registration failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
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
        state = AuthState(
          errorMessage: response['message'] ?? 'Verification submission failed',
        );
        return false;
      }
    } catch (e) {
      state = AuthState(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> premiumUpgrade({
    required int seekerId,
    required int age,
    required String stateOfOrigin,
    required String currentlyBasedIn,
    required String tribe,
    required String maritalStatus,
    required String children,
    required String education,
    required String occupation,
    required String aboutMe,
    required String spouseAgeRange,
    required String spouseDesiredQualities,
    String spouseMaritalStatus = 'Any',
    String spouseChildrenPref = 'No preference',
    String spouseLocation = '',
    String bloodGroup = '',
    String genotype = '',
    String healthStatus = '',
    String islamicLevel = '',
    String modeOfDressing = '',
    String appearance = '',
    String openToPolygamy = 'No',
    String willingToRelocate = 'No',
    String marriageTimeline = '',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.post('/premium-upgrade/', {
        'seeker_id': seekerId,
        'age': age,
        'state_of_origin': stateOfOrigin,
        'currently_based_in': currentlyBasedIn,
        'tribe': tribe,
        'marital_status': maritalStatus,
        'children': children,
        'education': education,
        'occupation': occupation,
        'about_me': aboutMe,
        'spouse_age_range': spouseAgeRange,
        'spouse_desired_qualities': spouseDesiredQualities,
        'spouse_marital_status': spouseMaritalStatus,
        'spouse_children': spouseChildrenPref,
        'spouse_location': spouseLocation,
        'blood_group': bloodGroup,
        'genotype': genotype,
        'health_status': healthStatus,
        'islamic_level': islamicLevel,
        'mode_of_dressing': modeOfDressing,
        'appearance': appearance,
        'open_to_polygamy': openToPolygamy,
        'willing_to_relocate': willingToRelocate,
        'marriage_timeline': marriageTimeline,
      });

      if (response['status'] == 'success') {
        final userData = response['user'];
        final user = SeekerUser.fromJson(userData);
        await _saveUserToPrefs(user);
        state = AuthState(user: user);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response['message'] ?? 'Premium upgrade failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> updateProfile({
    required String fullName,
    required String stateName,
    required String phoneNumber,
    required String email,
    int? age,
    String? occupation,
    String? education,
    String? islamicLevel,
    String? modeOfDressing,
    // Premium lifestyle fields (only sent for premium seekers)
    String? bloodGroup,
    String? genotype,
    String? healthStatus,
    String? appearance,
    String? openToPolygamy,
    String? willingToRelocate,
    String? marriageTimeline,
    // Spouse preference fields (only sent for premium seekers)
    String? spouseMaritalStatus,
    String? spouseChildrenPref,
    String? spouseLocation,
  }) async {
    final currentUser = state.user;
    if (currentUser == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.post('/user/update/', {
        'id': currentUser.id,
        'role': currentUser.role,
        'full_name': fullName,
        'state': stateName,
        'phone_number': phoneNumber,
        'email': email,
        if (age != null) 'age': age,
        if (occupation != null) 'occupation': occupation,
        if (education != null) 'education': education,
        if (islamicLevel != null) 'islamic_level': islamicLevel,
        if (modeOfDressing != null) 'mode_of_dressing': modeOfDressing,
        if (bloodGroup != null) 'blood_group': bloodGroup,
        if (genotype != null) 'genotype': genotype,
        if (healthStatus != null) 'health_status': healthStatus,
        if (appearance != null) 'appearance': appearance,
        if (openToPolygamy != null) 'open_to_polygamy': openToPolygamy,
        if (willingToRelocate != null) 'willing_to_relocate': willingToRelocate,
        if (marriageTimeline != null) 'marriage_timeline': marriageTimeline,
        if (spouseMaritalStatus != null) 'spouse_marital_status': spouseMaritalStatus,
        if (spouseChildrenPref != null) 'spouse_children': spouseChildrenPref,
        if (spouseLocation != null) 'spouse_location': spouseLocation,
      });

      if (response['status'] == 'success') {
        final userData = response['user'];
        final updatedUser = SeekerUser.fromJson(userData);
        await _saveUserToPrefs(updatedUser);
        state = AuthState(user: updatedUser);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response['message'] ?? 'Update failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final currentUser = state.user;
    if (currentUser == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.post('/user/change-password/', {
        'seeker_id': currentUser.id,
        'role': currentUser.role,
        'old_password': oldPassword,
        'new_password': newPassword,
      });

      if (response['status'] == 'success') {
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response['message'] ?? 'Password change failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> refreshUserStatus() async {
    final currentUser = state.user;
    if (currentUser == null) return;

    try {
      final response = await _apiClient.get(
        '/user/status/',
        queryParameters: {
          'id': currentUser.id.toString(),
          'role': currentUser.role,
        },
      );

      if (response['status'] == 'success') {
        final userData = response['user'];
        final updatedUser = SeekerUser.fromJson(userData);
        await _saveUserToPrefs(updatedUser);
        state = AuthState(user: updatedUser);
      }
    } catch (e) {
      // Fail silently for background status updates to avoid disrupting user experience
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
