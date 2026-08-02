import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme/app_theme.dart';
import '../../authentication/presentation/auth_provider.dart';

class SeekerSetupScreen extends ConsumerStatefulWidget {
  const SeekerSetupScreen({super.key});

  @override
  ConsumerState<SeekerSetupScreen> createState() => _SeekerSetupScreenState();
}

class _SeekerSetupScreenState extends ConsumerState<SeekerSetupScreen> {
  int _currentStep = 0;
  final int _totalSteps = 3;

  String? _gender;
  String? _ageGroup;
  String _lga = 'Bida';
  String _state = 'Niger';
  String? _practiceLevel;
  String? _timeline;
  final List<String> _selectedLanguages = [];
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPasswordVisible = false;
  
  final _occupationController = TextEditingController();
  final _expectationsController = TextEditingController();
  
  final _waliNameController = TextEditingController();
  final _waliRelationshipController = TextEditingController();
  final _waliContactController = TextEditingController();

  final List<String> _lgas = ['Bida', 'Gbako', 'Katcha', 'Lavun', 'Mokwa', 'Edu', 'Patigi', 'Lokoja', 'Other'];
  final List<String> _states = ['Niger', 'Kwara', 'Kogi', 'Federal Capital Territory (FCT)'];
  final List<String> _languages = ['Nupe', 'English', 'Hausa', 'Yoruba', 'Arabic'];

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentStep = prefs.getInt('draft_seeker_step') ?? 0;
      _gender = prefs.getString('draft_seeker_gender');
      _ageGroup = prefs.getString('draft_seeker_age_group');
      _nameController.text = prefs.getString('draft_seeker_name') ?? '';
      _emailController.text = prefs.getString('draft_seeker_email') ?? '';
      _passwordController.text = prefs.getString('draft_seeker_password') ?? '';
      _phoneController.text = prefs.getString('draft_seeker_phone') ?? '';
      _lga = prefs.getString('draft_seeker_lga') ?? 'Bida';
      _state = prefs.getString('draft_seeker_state') ?? 'Niger';
      _occupationController.text = prefs.getString('draft_seeker_occupation') ?? '';
      _practiceLevel = prefs.getString('draft_seeker_practice_level');
      
      final savedLanguages = prefs.getStringList('draft_seeker_languages');
      if (savedLanguages != null) {
        _selectedLanguages.clear();
        _selectedLanguages.addAll(savedLanguages);
      }
      
      _timeline = prefs.getString('draft_seeker_timeline');
      _expectationsController.text = prefs.getString('draft_seeker_expectations') ?? '';
      _waliNameController.text = prefs.getString('draft_seeker_wali_name') ?? '';
      _waliRelationshipController.text = prefs.getString('draft_seeker_wali_relationship') ?? '';
      _waliContactController.text = prefs.getString('draft_seeker_wali_contact') ?? '';
    });
  }

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('draft_seeker_step', _currentStep);
    if (_gender != null) await prefs.setString('draft_seeker_gender', _gender!);
    if (_ageGroup != null) await prefs.setString('draft_seeker_age_group', _ageGroup!);
    await prefs.setString('draft_seeker_name', _nameController.text);
    await prefs.setString('draft_seeker_email', _emailController.text);
    await prefs.setString('draft_seeker_password', _passwordController.text);
    await prefs.setString('draft_seeker_phone', _phoneController.text);
    await prefs.setString('draft_seeker_lga', _lga);
    await prefs.setString('draft_seeker_state', _state);
    await prefs.setString('draft_seeker_occupation', _occupationController.text);
    if (_practiceLevel != null) await prefs.setString('draft_seeker_practice_level', _practiceLevel!);
    await prefs.setStringList('draft_seeker_languages', _selectedLanguages);
    if (_timeline != null) await prefs.setString('draft_seeker_timeline', _timeline!);
    await prefs.setString('draft_seeker_expectations', _expectationsController.text);
    await prefs.setString('draft_seeker_wali_name', _waliNameController.text);
    await prefs.setString('draft_seeker_wali_relationship', _waliRelationshipController.text);
    await prefs.setString('draft_seeker_wali_contact', _waliContactController.text);
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('draft_seeker_step');
    await prefs.remove('draft_seeker_gender');
    await prefs.remove('draft_seeker_age_group');
    await prefs.remove('draft_seeker_name');
    await prefs.remove('draft_seeker_email');
    await prefs.remove('draft_seeker_password');
    await prefs.remove('draft_seeker_phone');
    await prefs.remove('draft_seeker_lga');
    await prefs.remove('draft_seeker_state');
    await prefs.remove('draft_seeker_occupation');
    await prefs.remove('draft_seeker_practice_level');
    await prefs.remove('draft_seeker_languages');
    await prefs.remove('draft_seeker_timeline');
    await prefs.remove('draft_seeker_expectations');
    await prefs.remove('draft_seeker_wali_name');
    await prefs.remove('draft_seeker_wali_relationship');
    await prefs.remove('draft_seeker_wali_contact');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _occupationController.dispose();
    _expectationsController.dispose();
    _waliNameController.dispose();
    _waliRelationshipController.dispose();
    _waliContactController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_nameController.text.trim().isEmpty) {
        _showErrorSnackBar('Please enter your first name.');
        return;
      }
      if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
        _showErrorSnackBar('Please enter a valid email address.');
        return;
      }
      if (_passwordController.text.length < 6) {
        _showErrorSnackBar('Password must be at least 6 characters.');
        return;
      }
      if (_phoneController.text.trim().isEmpty || _phoneController.text.trim().length < 9) {
        _showErrorSnackBar('Please enter a valid phone number.');
        return;
      }
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _saveDraft();
    } else {
      _showOtpVerificationDialog();
    }
  }

  void _showOtpVerificationDialog() {
    final rawPhone = _phoneController.text.trim();
    final cleanPhone = rawPhone.startsWith('+234') ? rawPhone : '+234$rawPhone';
    final otpVerificationController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'OTP Security Verification',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'We have sent a 6-digit verification code to your phone number $cleanPhone for account security.',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Text(
              'Verification Code',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: otpVerificationController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                hintText: 'Enter 6-digit OTP code',
                prefixIcon: Icon(Icons.lock_outline),
                counterText: '',
                suffixText: 'Use 123456',
                suffixStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (otpVerificationController.text.trim() == '123456') {
                  Navigator.pop(context); // Close OTP Modal
                  _registerSeeker(); // Proceed with API registration
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid OTP code. Please enter 123456.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Verify & Create Account',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerSeeker() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryGreen,
        ),
      ),
    );

    final rawPhone = _phoneController.text.trim();
    final cleanPhone = rawPhone.startsWith('+234') ? rawPhone : '+234$rawPhone';

    final success = await ref.read(authProvider.notifier).register(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phoneNumber: cleanPhone,
      gender: _gender ?? 'groom',
      stateVal: _state,
      waliName: _waliNameController.text.trim(),
      waliRelationship: _waliRelationshipController.text.trim(),
      waliContact: _waliContactController.text.trim(),
      ageGroup: _ageGroup ?? '',
      lga: _lga,
      occupation: _occupationController.text.trim(),
      practiceLevel: _practiceLevel ?? '',
      timeline: _timeline ?? '',
      expectations: _expectationsController.text.trim(),
    );

    if (mounted) {
      Navigator.of(context).pop();
      if (success) {
        await _clearDraft();
        context.push('/verification');
      } else {
        final error = ref.read(authProvider).errorMessage ?? 'Registration failed';
        _showErrorSnackBar(error);
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _saveDraft();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkCharcoal),
          onPressed: _currentStep > 0 ? _prevStep : () => context.pop(),
        ),
        title: Text(
          'Step ${_currentStep + 1} of $_totalSteps',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.secondaryGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: AppTheme.secondaryGrey.withAlpha(25),
              color: AppTheme.primaryGreen,
              minHeight: 4,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentStep == 0) _buildStep1(),
                    if (_currentStep == 1) _buildStep2(),
                    if (_currentStep == 2) _buildStep3(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _prevStep,
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      child: Text(_currentStep == _totalSteps - 1 ? 'Save & Verify' : 'Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Details',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Introduce yourself. Full names are kept confidential initially.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryGrey),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameController,
          onChanged: (val) => _saveDraft(),
          decoration: const InputDecoration(
            labelText: 'First Name (or Initials)',
            hintText: 'Enter your first name only',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _emailController,
          onChanged: (val) => _saveDraft(),
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          onChanged: (val) => _saveDraft(),
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Create a password (min. 6 characters)',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Phone Number',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkCharcoal,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                '+234',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                onChanged: (val) => _saveDraft(),
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '803 123 4567',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Gender',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildChoiceCard(
                label: 'Groom (Male)',
                isSelected: _gender == 'groom',
                onTap: () {
                  setState(() => _gender = 'groom');
                  _saveDraft();
                },
                icon: Icons.male,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChoiceCard(
                label: 'Bride (Female)',
                isSelected: _gender == 'bride',
                onTap: () {
                  setState(() => _gender = 'bride');
                  _saveDraft();
                },
                icon: Icons.female,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Age Group',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildChoiceCard(
                label: '18 - 25',
                isSelected: _ageGroup == '18-25',
                onTap: () {
                  setState(() => _ageGroup = '18-25');
                  _saveDraft();
                },
                icon: Icons.cake_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChoiceCard(
                label: '26 - 35',
                isSelected: _ageGroup == '26-35',
                onTap: () {
                  setState(() => _ageGroup = '26-35');
                  _saveDraft();
                },
                icon: Icons.cake_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChoiceCard(
                label: '36+',
                isSelected: _ageGroup == '36+',
                onTap: () {
                  setState(() => _ageGroup = '36+');
                  _saveDraft();
                },
                icon: Icons.cake_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: _state,
                decoration: const InputDecoration(labelText: 'State of Origin'),
                items: _states.map((String state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state, style: GoogleFonts.inter(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _state = val!);
                  _saveDraft();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: _lga,
                decoration: const InputDecoration(labelText: 'LGA of Origin'),
                items: _lgas.map((String lga) {
                  return DropdownMenuItem<String>(
                    value: lga,
                    child: Text(lga, style: GoogleFonts.inter(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _lga = val!);
                  _saveDraft();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _occupationController,
          onChanged: (val) => _saveDraft(),
          decoration: const InputDecoration(
            labelText: 'Occupation',
            hintText: 'Enter your profession',
            prefixIcon: Icon(Icons.work_outline),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deen & Expectations',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Specify your religious values and expectations to help find compatible matches.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryGrey),
        ),
        const SizedBox(height: 24),
        Text(
          'Islamic Practice Level',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            _buildRadioCard(
              label: 'Practising (Committed to all Fardh & Sunnah)',
              value: 'practising',
              groupValue: _practiceLevel,
              onChanged: (val) {
                setState(() => _practiceLevel = val);
                _saveDraft();
              },
            ),
            const SizedBox(height: 8),
            _buildRadioCard(
              label: 'Moderately Practising (Trying to build consistency)',
              value: 'moderate',
              groupValue: _practiceLevel,
              onChanged: (val) {
                setState(() => _practiceLevel = val);
                _saveDraft();
              },
            ),
            const SizedBox(height: 8),
            _buildRadioCard(
              label: 'Learning (Seeking guidance and knowledge)',
              value: 'learning',
              groupValue: _practiceLevel,
              onChanged: (val) {
                setState(() => _practiceLevel = val);
                _saveDraft();
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Languages Spoken (Choose all that apply)',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _languages.map((lang) {
            bool isSelected = _selectedLanguages.contains(lang);
            return FilterChip(
              label: Text(lang, style: GoogleFonts.inter(fontSize: 14)),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedLanguages.add(lang);
                  } else {
                    _selectedLanguages.remove(lang);
                  }
                });
                _saveDraft();
              },
              selectedColor: AppTheme.primaryGreen.withAlpha(51),
              checkmarkColor: AppTheme.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text(
          'Expectation Timeline for Marriage',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: _timeline,
          hint: const Text('Select timeline'),
          decoration: const InputDecoration(prefixIcon: Icon(Icons.hourglass_empty_outlined)),
          items: ['Within 6 months', 'Within 1 year', '1 to 2 years', 'Flexible'].map((String timeline) {
            return DropdownMenuItem<String>(
              value: timeline,
              child: Text(timeline, style: GoogleFonts.inter(fontSize: 14)),
            );
          }).toList(),
          onChanged: (val) {
            setState(() => _timeline = val);
            _saveDraft();
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _expectationsController,
          onChanged: (val) => _saveDraft(),
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Marriage Expectations',
            hintText: 'Describe what you are looking for in a spouse (e.g. qualities, family values)...',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wali / Guardian Details',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'A Wali\'s involvement is key to a blessed and sharia-compliant matchmaking process.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryGrey),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _waliNameController,
          onChanged: (val) => _saveDraft(),
          decoration: const InputDecoration(
            labelText: 'Wali\'s Name',
            hintText: 'Enter guardian\'s full name',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _waliRelationshipController,
          onChanged: (val) => _saveDraft(),
          decoration: const InputDecoration(
            labelText: 'Wali\'s Relationship',
            hintText: 'e.g. Father, Uncle, Elder Brother',
            prefixIcon: Icon(Icons.family_restroom_outlined),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _waliContactController,
          onChanged: (val) => _saveDraft(),
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Wali\'s Phone Number / WhatsApp',
            hintText: 'e.g. +234...',
            prefixIcon: Icon(Icons.phone_outlined),
            helperText: 'Your Wali will be sent a secure verification and chat link.',
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceCard({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen.withAlpha(20) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.secondaryGrey.withAlpha(51),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryGreen : AppTheme.secondaryGrey),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryGreen : AppTheme.darkCharcoal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioCard({
    required String label,
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen.withAlpha(20) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.secondaryGrey.withAlpha(51),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppTheme.primaryGreen,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.darkCharcoal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
