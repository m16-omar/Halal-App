import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme/app_theme.dart';
import '../../authentication/presentation/auth_provider.dart';

class PremiumUpgradeScreen extends ConsumerStatefulWidget {
  const PremiumUpgradeScreen({super.key});

  @override
  ConsumerState<PremiumUpgradeScreen> createState() => _PremiumUpgradeScreenState();
}

class _PremiumUpgradeScreenState extends ConsumerState<PremiumUpgradeScreen> {
  int _currentStep = 0;
  final int _totalSteps = 6;
  int _selectedPlan = 1; // Default to Premium (Recommended)

  // Countdown Timer state
  late Timer _timer;
  int _secondsRemaining = 86399; // 23 hours, 59 minutes, 59 seconds

  // STEP 2: PERSONAL DETAILS (Account)
  final _ageController = TextEditingController();
  final _tribeController = TextEditingController();
  final _stateOfOriginController = TextEditingController();
  final _currentlyBasedInController = TextEditingController();
  String _maritalStatus = 'Single';
  final _childrenController = TextEditingController();
  String _education = 'B.Sc.';
  final _occupationController = TextEditingController();

  // STEP 3: ID VERIFICATION (Verify)
  String _docType = 'National ID / NIN';
  final _idNumberController = TextEditingController();
  bool _hasUploadedDoc = false;

  // STEP 4: PAYMENT GATEWAY (Payment)
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();
  final _cardNameController = TextEditingController();

  // Advanced bio / spouse preferences for registration
  final _aboutMeController = TextEditingController();
  final _spouseAgeRangeController = TextEditingController();
  final _spouseDesiredQualitiesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Live countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _ageController.dispose();
    _tribeController.dispose();
    _stateOfOriginController.dispose();
    _currentlyBasedInController.dispose();
    _childrenController.dispose();
    _occupationController.dispose();
    _idNumberController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _cardNameController.dispose();
    _aboutMeController.dispose();
    _spouseAgeRangeController.dispose();
    _spouseDesiredQualitiesController.dispose();
    super.dispose();
  }

  String _getFormattedTime() {
    final hours = _secondsRemaining ~/ 3600;
    final minutes = (_secondsRemaining % 3600) ~/ 60;
    final seconds = _secondsRemaining % 60;
    
    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');
    
    return '$hStr:$mStr:$sStr';
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (_ageController.text.isEmpty || _tribeController.text.isEmpty || _currentlyBasedInController.text.isEmpty) {
        _showErrorSnackBar('Please fill out all required personal fields.');
        return;
      }
    }
    if (_currentStep == 2) {
      if (_idNumberController.text.isEmpty || !_hasUploadedDoc) {
        _showErrorSnackBar('Please enter your ID number and upload a verification photo.');
        return;
      }
    }
    if (_currentStep == 3) {
      if (_cardNumberController.text.length < 16 || _cardExpiryController.text.isEmpty || _cardCvvController.text.length < 3) {
        _showErrorSnackBar('Please enter valid credit card details.');
        return;
      }
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _processUpgrade();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      context.pop();
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _processUpgrade() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryGreen),
      ),
    );

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        Navigator.pop(context);
        final currentUser = ref.read(authProvider).user;
        if (currentUser != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_status', 'Verified');
          ref.read(authProvider.notifier).setTemporaryUser(
            fullName: currentUser.fullName,
            status: 'Verified',
          );
          await ref.read(authProvider.notifier).checkAutoLogin();
        }
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showErrorSnackBar(e.toString());
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified, color: AppTheme.primaryGreen, size: 54),
              ),
              const SizedBox(height: 20),
              Text(
                'Upgrade Successful!',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
              const SizedBox(height: 8),
              Text(
                'Alhamdulillah! Your detailed profile is complete, ID verification submitted, and Premium tier upgrade is active. You can now view matches of the opposite gender.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600], height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Start Matching'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkCharcoal),
          onPressed: _prevStep,
        ),
        title: Row(
          children: [
            Text(
              'Premium Upgrade',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
            ),
            const SizedBox(width: 4),
            const Text('✨', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.headset_mic_outlined, size: 14, color: AppTheme.primaryGreen),
              label: Text(
                'Help',
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.primaryGreen),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          // Top Progress Steps
          _buildProgressSteps(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildCurrentStepView(),
            ),
          ),
          // Bottom Continue Action Button
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  // --- PROGRESS TRACKER BAR ---
  Widget _buildProgressSteps() {
    final stepLabels = ['Choose Plan', 'Account', 'Verify', 'Payment', 'Review', 'Complete'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: List.generate(11, (index) {
              if (index % 2 == 0) {
                // Circle Step
                final stepNum = index ~/ 2;
                final isActive = stepNum <= _currentStep;
                return Expanded(
                  child: Center(
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: isActive ? AppTheme.primaryGreen : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive ? AppTheme.primaryGreen : Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${stepNum + 1}',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.white : Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                // Connecting line
                final lineIndex = index ~/ 2;
                final isPassed = lineIndex < _currentStep;
                return SizedBox(
                  width: 20,
                  child: Divider(
                    color: isPassed ? AppTheme.primaryGreen : Colors.grey[200],
                    thickness: 1.5,
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(stepLabels.length, (index) {
              final isCurrent = index == _currentStep;
              return Expanded(
                child: Text(
                  stepLabels[index],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? AppTheme.primaryGreen : Colors.grey[400],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // --- STICKY BOTTOM ACTION BAR ---
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentStep == _totalSteps - 1 ? 'Pay & Upgrade' : 'Continue',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'You can cancel or change your plan anytime.',
                  style: GoogleFonts.inter(fontSize: 9, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- ROUTE STEPS VIEWS ---
  Widget _buildCurrentStepView() {
    switch (_currentStep) {
      case 0:
        return _buildStep0ChoosePlan();
      case 1:
        return _buildStep1Personal();
      case 2:
        return _buildStep2IDVerification();
      case 3:
        return _buildStep3PaymentGateway();
      case 4:
        return _buildStep4Review();
      case 5:
        return _buildStep5Complete();
      default:
        return const SizedBox.shrink();
    }
  }

  // ================= STEP 0: CHOOSE PLAN =================
  Widget _buildStep0ChoosePlan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Banner + Crown Illustration
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step 1 of 6',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose Your Plan',
                    style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Unlock powerful features and find your perfect match faster.',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Crown 3D Shield Illustration
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF042415),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryGreen.withOpacity(0.2), blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: const Icon(Icons.workspace_premium, color: Color(0xFFD4AF37), size: 36),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Plans layout - Vertical static list (no horizontal scrolling)
        Column(
          children: [
            _buildPlanCard(
              index: 0,
              title: 'Basic',
              desc: 'Get started with essential features',
              price: '₦5,000',
              duration: '/ 1 Month',
              badge: 'Popular',
              icon: Icons.send_outlined,
              features: ['View limited profiles', 'Send interest', 'Supervised chat', 'Basic filters'],
            ),
            const SizedBox(height: 14),
            _buildPlanCard(
              index: 1,
              title: 'Premium',
              desc: 'Most popular for serious seekers',
              price: '₦12,000',
              duration: '/ 3 Months',
              badge: 'Best Value',
              icon: Icons.stars,
              features: [
                'View unlimited profiles',
                'Send unlimited interest',
                'Supervised chat',
                'Advanced filters',
                'See who viewed you',
                'Priority support'
              ],
              isRecommended: true,
            ),
            const SizedBox(height: 14),
            _buildPlanCard(
              index: 2,
              title: 'Platinum',
              desc: 'The ultimate experience for better matches',
              price: '₦20,000',
              duration: '/ 6 Months',
              badge: 'Ultimate',
              icon: Icons.diamond_outlined,
              features: [
                'All Premium features',
                'Top profile highlight',
                'Profile boost',
                'Read receipts',
                'Relationship guidance',
                'Priority support'
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 100% Safe & Private Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAF6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[150]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_outlined, color: AppTheme.primaryGreen, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '100% Safe & Private',
                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Your data is secure and will never be shared with anyone without your permission.',
                      style: GoogleFonts.inter(fontSize: 9, color: Colors.grey[600], height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.lock_outline, color: AppTheme.primaryGreen, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Limited Time Offer Countdown Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Text('🎁', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Limited Time Offer!',
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF92400E)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Get 10% off when you subscribe to any plan today.',
                      style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFFB45309)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Timer layout
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF042415),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getFormattedTime(),
                  style: GoogleFonts.shareTechMono(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // All plans include section
        Text(
          'All plans include',
          style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFeatureBadge(Icons.check_circle_outline, 'Verified\nMembers'),
            _buildFeatureBadge(Icons.lock_outline, 'Secure &\nPrivate'),
            _buildFeatureBadge(Icons.headphones_outlined, 'Expert\nSupport'),
            _buildFeatureBadge(Icons.favorite_border, 'Islamic Values\nFocused'),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String desc,
    required String price,
    required String duration,
    required String badge,
    required IconData icon,
    required List<String> features,
    bool isRecommended = false,
  }) {
    final isSelected = _selectedPlan == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryGreen
                : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppTheme.primaryGreen.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRecommended)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryGreen,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Recommended',
                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: isSelected ? AppTheme.primaryGreen : Colors.grey[400], size: 24),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: GoogleFonts.inter(fontSize: 8, color: Colors.grey[500], height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        duration,
                        style: GoogleFonts.inter(fontSize: 8, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.secondaryGrey),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Features checklist
                  ...features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 12),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                f,
                                style: GoogleFonts.inter(fontSize: 8, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 14),
                  // Select Radio Circle
                  Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryGreen : Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: isSelected
                          ? Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
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

  Widget _buildFeatureBadge(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAF6),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Icon(icon, color: AppTheme.primaryGreen, size: 16),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 8, color: Colors.grey[600], height: 1.3),
        ),
      ],
    );
  }

  // ================= STEP 1: PERSONAL DETAILS (Account) =================
  Widget _buildStep1Personal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Personal Details', 'Please fill out your lifestyle & education background.'),
        _buildTextField(_ageController, 'Age', 'e.g. 37', TextInputType.number),
        _buildTextField(_tribeController, 'Tribe', 'e.g. Nupe', TextInputType.text),
        _buildTextField(_stateOfOriginController, 'State of Origin', 'e.g. Niger State', TextInputType.text),
        _buildTextField(_currentlyBasedInController, 'Currently Based In', 'e.g. Suleja, Niger State', TextInputType.text),
        _buildDropdown('Marital Status', _maritalStatus, ['Single', 'Divorced', 'Widow', 'Widower'], (val) {
          if (val != null) setState(() => _maritalStatus = val);
        }),
        _buildTextField(_childrenController, 'Children', 'e.g. None', TextInputType.text),
        _buildDropdown('Education', _education, ['B.Sc.', 'M.Sc.', 'Ph.D.', 'HND', 'OND', 'High School', 'Other'], (val) {
          if (val != null) setState(() => _education = val);
        }),
        _buildTextField(_occupationController, 'Occupation', 'e.g. Teacher', TextInputType.text),
      ],
    );
  }

  // ================= STEP 2: ID VERIFICATION (Verify) =================
  Widget _buildStep2IDVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('ID Verification', 'Upload a valid government ID document to activate Tier 1.'),
        _buildDropdown('Document Type', _docType, ['National ID / NIN', 'International Passport', 'Driver\'s License'], (val) {
          if (val != null) setState(() => _docType = val);
        }),
        const SizedBox(height: 12),
        _buildTextField(_idNumberController, 'ID / NIN Card Number', 'Enter card ID number', TextInputType.text),
        const SizedBox(height: 20),
        Text(
          'Upload Document Photo',
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            setState(() {
              _hasUploadedDoc = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ID Document uploaded successfully!'),
                backgroundColor: AppTheme.primaryGreen,
              ),
            );
          },
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 2),
            ),
            child: _hasUploadedDoc
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 40),
                        SizedBox(height: 8),
                        Text('document_id_preview.jpg uploaded', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined, color: AppTheme.secondaryGrey, size: 36),
                        SizedBox(height: 8),
                        Text('Tap to snap or upload ID Card image', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // ================= STEP 3: PAYMENT GATEWAY (Payment) =================
  Widget _buildStep3PaymentGateway() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Premium Payment Gateway', 'Securely upgrade to Premium tier using Paystack gateway.'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Premium Tier Activation', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                  const SizedBox(height: 2),
                  Text('Includes advanced profile and verification', style: GoogleFonts.inter(fontSize: 9, color: Colors.grey[600])),
                ],
              ),
              Text(
                _selectedPlan == 0 ? '₦5,000' : (_selectedPlan == 1 ? '₦12,000' : '₦20,000'),
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField(_cardNameController, 'Cardholder Name', 'e.g. Amina Agaie', TextInputType.text),
        _buildTextField(_cardNumberController, 'Credit Card Number', '1234 5678 1234 5678', TextInputType.number),
        Row(
          children: [
            Expanded(child: _buildTextField(_cardExpiryController, 'Expiry Date', 'MM/YY', TextInputType.number)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(_cardCvvController, 'CVV', '123', TextInputType.number)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, color: Colors.grey, size: 14),
            const SizedBox(width: 4),
            Text('Secured by Paystack. Your transaction is encrypted.', style: GoogleFonts.inter(fontSize: 8, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  // ================= STEP 4: REVIEW =================
  Widget _buildStep4Review() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Review Details', 'Please verify your details before final activation.'),
        _buildReviewRow('Selected Plan', _selectedPlan == 0 ? 'Basic (₦5,000)' : (_selectedPlan == 1 ? 'Premium (₦12,000)' : 'Platinum (₦20,000)')),
        _buildReviewRow('Age', _ageController.text),
        _buildReviewRow('Tribe', _tribeController.text),
        _buildReviewRow('State of Origin', _stateOfOriginController.text),
        _buildReviewRow('Current Base', _currentlyBasedInController.text),
        _buildReviewRow('Marital Status', _maritalStatus),
        _buildReviewRow('Occupation', _occupationController.text),
        _buildReviewRow('ID Document', '$_docType (NIN verified)'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAF6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: AppTheme.primaryGreen, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'By proceeding, you authorize database verification of your government ID.',
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[700], height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500])),
          Text(value.isNotEmpty ? value : 'Not provided', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal)),
        ],
      ),
    );
  }

  // ================= STEP 5: COMPLETE =================
  Widget _buildStep5Complete() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5E9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.verified, color: AppTheme.primaryGreen, size: 64),
        ),
        const SizedBox(height: 24),
        Text(
          'Verification Finalized!',
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        const SizedBox(height: 12),
        Text(
          'Alhamdulillah! All details are successfully logged. Tap below to complete your premium upgrade and unlock all seeker matches.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600], height: 1.6),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ================= WIDGET HELPERS =================
  Widget _buildStepTitle(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        const SizedBox(height: 4),
        Text(
          desc,
          style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, TextInputType inputType, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: inputType,
            maxLines: maxLines,
            style: GoogleFonts.inter(fontSize: 12),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(fontSize: 11, color: Colors.grey[400]),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.primaryGreen)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                style: GoogleFonts.inter(fontSize: 12, color: AppTheme.darkCharcoal),
                items: options.map((opt) {
                  return DropdownMenuItem(value: opt, child: Text(opt));
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
