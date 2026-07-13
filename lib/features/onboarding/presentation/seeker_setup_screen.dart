import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _registerSeeker();
    }
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

    final success = await ref.read(authProvider.notifier).register(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      gender: _gender ?? 'groom',
      stateVal: _state,
      waliName: _waliNameController.text.trim(),
      waliRelationship: _waliRelationshipController.text.trim(),
      waliContact: _waliContactController.text.trim(),
    );

    if (mounted) {
      Navigator.of(context).pop();
      if (success) {
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
          decoration: const InputDecoration(
            labelText: 'First Name (or Initials)',
            hintText: 'Enter your first name only',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _emailController,
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
                onTap: () => setState(() => _gender = 'groom'),
                icon: Icons.male,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChoiceCard(
                label: 'Bride (Female)',
                isSelected: _gender == 'bride',
                onTap: () => setState(() => _gender = 'bride'),
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
                onTap: () => setState(() => _ageGroup = '18-25'),
                icon: Icons.cake_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChoiceCard(
                label: '26 - 35',
                isSelected: _ageGroup == '26-35',
                onTap: () => setState(() => _ageGroup = '26-35'),
                icon: Icons.cake_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChoiceCard(
                label: '36+',
                isSelected: _ageGroup == '36+',
                onTap: () => setState(() => _ageGroup = '36+'),
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
                onChanged: (val) => setState(() => _state = val!),
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
                onChanged: (val) => setState(() => _lga = val!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _occupationController,
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
              onChanged: (val) => setState(() => _practiceLevel = val),
            ),
            const SizedBox(height: 8),
            _buildRadioCard(
              label: 'Moderately Practising (Trying to build consistency)',
              value: 'moderate',
              groupValue: _practiceLevel,
              onChanged: (val) => setState(() => _practiceLevel = val),
            ),
            const SizedBox(height: 8),
            _buildRadioCard(
              label: 'Learning (Seeking guidance and knowledge)',
              value: 'learning',
              groupValue: _practiceLevel,
              onChanged: (val) => setState(() => _practiceLevel = val),
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
          onChanged: (val) => setState(() => _timeline = val),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _expectationsController,
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
          decoration: const InputDecoration(
            labelText: 'Wali\'s Name',
            hintText: 'Enter guardian\'s full name',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _waliRelationshipController,
          decoration: const InputDecoration(
            labelText: 'Wali\'s Relationship',
            hintText: 'e.g. Father, Uncle, Elder Brother',
            prefixIcon: Icon(Icons.family_restroom_outlined),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _waliContactController,
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
