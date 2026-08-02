import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_theme.dart';
import '../../authentication/presentation/auth_provider.dart';

class WaliSetupScreen extends ConsumerStatefulWidget {
  const WaliSetupScreen({super.key});

  @override
  ConsumerState<WaliSetupScreen> createState() => _WaliSetupScreenState();
}

class _WaliSetupScreenState extends ConsumerState<WaliSetupScreen> {
  int _currentStep = 0;
  final int _totalSteps = 2;

  // STEP 1: Wali Details
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPasswordVisible = false;

  // STEP 2: Ward & Relationship Details
  final _wardNameController = TextEditingController();
  final _wardEmailController = TextEditingController();
  String _relationship = 'Father';

  final List<String> _relationships = [
    'Father',
    'Brother',
    'Uncle',
    'Grandfather',
    'Maternal Uncle',
    'Paternal Uncle',
    'Legal Guardian',
    'Other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _wardNameController.dispose();
    _wardEmailController.dispose();
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
        _showErrorSnackBar('Please enter your full name.');
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
    } else if (_currentStep == 1) {
      if (_wardNameController.text.trim().isEmpty) {
        _showErrorSnackBar('Please enter your ward\'s full name.');
        return;
      }
      if (_wardEmailController.text.trim().isEmpty || !_wardEmailController.text.contains('@')) {
        _showErrorSnackBar('Please enter your ward\'s registered email address.');
        return;
      }
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _showOtpVerificationDialog();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
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
                  _registerWali(); // Proceed with API registration
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

  Future<void> _registerWali() async {
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

    final success = await ref.read(authProvider.notifier).registerWali(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: cleanPhone,
      relationship: _relationship,
      wardEmail: _wardEmailController.text.trim(),
    );

    if (mounted) {
      Navigator.of(context).pop(); // Close spinner
      if (success) {
        context.go('/'); // Send Wali directly to the dashboard
      } else {
        final error = ref.read(authProvider).errorMessage ?? 'Registration failed';
        _showErrorSnackBar(error);
      }
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
          'Wali (Guardian) details',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Create a guardian account to chaperone, verify, and guide your ward.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryGrey),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your full name',
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
            prefixIcon: const Icon(Icons.lock_outline),
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
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ward Linkage details',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Provide details about the seeker (ward) you are supervising. Your ward must have registered on the app first.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryGrey),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _wardNameController,
          decoration: const InputDecoration(
            labelText: 'Ward\'s Full Name',
            hintText: 'Enter your ward\'s full name',
            prefixIcon: Icon(Icons.favorite_border),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _wardEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Ward\'s Registered Email',
            hintText: 'Enter your ward\'s email address',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Your Relationship to the Ward',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkCharcoal,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _relationship,
          items: _relationships.map((rel) {
            return DropdownMenuItem<String>(
              value: rel,
              child: Text(rel),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _relationship = val;
              });
            }
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.family_restroom),
          ),
        ),
      ],
    );
  }
}
