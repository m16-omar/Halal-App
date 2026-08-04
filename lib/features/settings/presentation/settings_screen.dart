import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';
import '../../authentication/presentation/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;
  bool _matchAlerts = true;
  String _profileVisibility = 'Matches Only';

  // Profile data state
  String _profileName = 'Abdullahi';
  int _profileAge = 28;
  String _profileLocation = 'Minna, Niger State';
  String _profileJob = 'Software Engineer';

  // Contact details state
  String _email = 'abdullahi@example.com';
  String _phone = '+234 812 345 6789';

  // Discovery settings state
  double _discoveryRadius = 80.0;

  // Partner Preferences state
  double _prefMinAge = 20.0;
  double _prefMaxAge = 35.0;
  String _prefEducation = "Bachelor's Degree";
  String _prefSect = 'Sunni';

  // Premium lifestyle fields (only shown/saved for Verified seekers)
  String _bloodGroup = 'A+';
  String _genotype = 'AA';
  String _healthStatus = '';
  String _appearance = '';
  String _islamicLevel = 'Practising';
  String _modeOfDressing = 'Hijab (Full covering)';
  String _openToPolygamy = 'No';
  String _willingToRelocate = 'No';
  String _marriageTimeline = 'As soon as possible';
  // Spouse preference fields
  String _spouseMaritalStatus = 'Any';
  String _spouseChildrenPref = 'No preference';
  String _spouseLocation = '';

  // Blocked users list (empty by default; managed locally)
  final List<String> _blockedUsers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authProvider.notifier).refreshUserStatus();
      final user = ref.read(authProvider).user;
      if (user != null) {
        setState(() {
          _profileName = user.fullName;
          _profileAge = user.age ?? 28;
          _profileLocation = user.state;
          _profileJob = user.occupation ?? '';
          _email = user.email ?? '';
          _phone = user.phoneNumber;
          // Pre-fill premium lifestyle fields if they exist
          _bloodGroup = user.bloodGroup ?? 'A+';
          _genotype = user.genotype ?? 'AA';
          _healthStatus = user.healthStatus ?? '';
          _appearance = user.appearance ?? '';
          _islamicLevel = user.islamicLevel ?? 'Practising';
          _modeOfDressing = user.modeOfDressing ?? 'Hijab (Full covering)';
          _openToPolygamy = user.openToPolygamy ?? 'No';
          _willingToRelocate = user.willingToRelocate ?? 'No';
          _marriageTimeline = user.marriageTimeline ?? 'As soon as possible';
          // Spouse preferences
          _spouseMaritalStatus = user.spouseMaritalStatus ?? 'Any';
          _spouseChildrenPref = user.spouseChildrenPref ?? 'No preference';
          _spouseLocation = user.spouseLocation ?? '';
        });
      }
    });
  }

  void _showEditProfileBottomSheet() {
    final user = ref.read(authProvider).user;
    final isPremium = (user?.status ?? 'Unverified') == 'Verified';

    final nameController = TextEditingController(text: _profileName);
    final ageController = TextEditingController(text: _profileAge.toString());
    final locationController = TextEditingController(text: _profileLocation);
    final jobController = TextEditingController(text: _profileJob);
    final healthStatusController = TextEditingController(text: _healthStatus);
    final appearanceController = TextEditingController(text: _appearance);
    final spouseLocationController = TextEditingController(text: _spouseLocation);

    // Local modal state for premium dropdowns
    String bloodGroup = _bloodGroup;
    String genotype = _genotype;
    String islamicLevel = _islamicLevel;
    String modeOfDressing = _modeOfDressing;
    String openToPolygamy = _openToPolygamy;
    String willingToRelocate = _willingToRelocate;
    String marriageTimeline = _marriageTimeline;
    String spouseMaritalStatus = _spouseMaritalStatus;
    String spouseChildrenPref = _spouseChildrenPref;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Profile Information',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkCharcoal,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 12),

                // ===== BASIC FIELDS =====
                Text('Full Name', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Enter your name'),
                ),
                const SizedBox(height: 16),
                Text('Age', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Enter your age'),
                ),
                const SizedBox(height: 16),
                Text('Location', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(hintText: 'Enter location'),
                ),
                const SizedBox(height: 16),
                Text('Job Title', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: jobController,
                  decoration: const InputDecoration(hintText: 'Enter job title'),
                ),

                // ===== PREMIUM LIFESTYLE FIELDS =====
                if (isPremium) ...[  
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium, color: AppTheme.primaryGreen, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Health & Lifestyle',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildModalDropdown('Blood Group', bloodGroup,
                      ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                      (val) { if (val != null) setModalState(() => bloodGroup = val); }),
                  const SizedBox(height: 12),
                  _buildModalDropdown('Genotype', genotype,
                      ['AA', 'AS', 'SS', 'AC', 'SC'],
                      (val) { if (val != null) setModalState(() => genotype = val); }),
                  const SizedBox(height: 12),
                  Text('Health Status', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: healthStatusController,
                    decoration: const InputDecoration(hintText: 'e.g. Healthy, Diabetic, Asthmatic'),
                  ),
                  const SizedBox(height: 12),
                  Text('Appearance / Build', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: appearanceController,
                    decoration: const InputDecoration(hintText: 'e.g. Slim, Athletic, Average'),
                  ),
                  const SizedBox(height: 12),
                  _buildModalDropdown('Islamic Practice Level', islamicLevel,
                      ['Beginner', 'Moderate', 'Practising', 'Strictly Practising', 'Sufi'],
                      (val) { if (val != null) setModalState(() => islamicLevel = val); }),
                  const SizedBox(height: 12),
                  _buildModalDropdown('Mode of Dressing', modeOfDressing,
                      ['Niqab', 'Hijab (Full covering)', 'Hijab (Modest)', 'Traditional/Modest dress', 'Islamic dress (male)', 'Smart/Modest casual', 'Casual'],
                      (val) { if (val != null) setModalState(() => modeOfDressing = val); }),
                  const SizedBox(height: 12),
                  _buildModalDropdown('Open to Polygamy', openToPolygamy,
                      ['Yes', 'No', 'Not sure'],
                      (val) { if (val != null) setModalState(() => openToPolygamy = val); }),
                  const SizedBox(height: 12),
                  _buildModalDropdown('Willing to Relocate', willingToRelocate,
                      ['Yes', 'No', 'Maybe'],
                      (val) { if (val != null) setModalState(() => willingToRelocate = val); }),
                  const SizedBox(height: 12),
                  _buildModalDropdown('Marriage Timeline', marriageTimeline,
                      ['As soon as possible', 'Within 6 months', 'Within 1 year', '1–2 years', 'Not sure yet'],
                      (val) { if (val != null) setModalState(() => marriageTimeline = val); }),

                  // ===== SPOUSE PREFERENCES SUBSECTION =====
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.favorite_border_outlined, color: AppTheme.primaryGreen, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Spouse Preferences',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildModalDropdown('Spouse Marital Status', spouseMaritalStatus,
                      ['Any', 'Single', 'Divorced', 'Widowed'],
                      (val) { if (val != null) setModalState(() => spouseMaritalStatus = val); }),
                  const SizedBox(height: 12),
                  _buildModalDropdown('Children Preference', spouseChildrenPref,
                      ['No preference', 'OK with children', 'Prefer no children'],
                      (val) { if (val != null) setModalState(() => spouseChildrenPref = val); }),
                  const SizedBox(height: 12),
                  Text('Location Preference', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: spouseLocationController,
                    decoration: const InputDecoration(hintText: 'e.g. Niger, FCT, Kwara or Any'),
                  ),
                ],

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final updatedName = nameController.text.trim();
                      final updatedAge = int.tryParse(ageController.text.trim());
                      final updatedLocation = locationController.text.trim();
                      final updatedJob = jobController.text.trim();

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(child: CircularProgressIndicator()),
                      );

                      final success = await ref.read(authProvider.notifier).updateProfile(
                        fullName: updatedName,
                        stateName: updatedLocation,
                        phoneNumber: _phone,
                        email: _email,
                        age: updatedAge,
                        occupation: updatedJob,
                        education: _prefEducation,
                        // Premium lifestyle fields (only sent when premium)
                        bloodGroup: isPremium ? bloodGroup : null,
                        genotype: isPremium ? genotype : null,
                        healthStatus: isPremium ? healthStatusController.text.trim() : null,
                        appearance: isPremium ? appearanceController.text.trim() : null,
                        islamicLevel: isPremium ? islamicLevel : null,
                        modeOfDressing: isPremium ? modeOfDressing : null,
                        openToPolygamy: isPremium ? openToPolygamy : null,
                        willingToRelocate: isPremium ? willingToRelocate : null,
                        marriageTimeline: isPremium ? marriageTimeline : null,
                        spouseMaritalStatus: isPremium ? spouseMaritalStatus : null,
                        spouseChildrenPref: isPremium ? spouseChildrenPref : null,
                        spouseLocation: isPremium ? spouseLocationController.text.trim() : null,
                      );

                      if (context.mounted) Navigator.pop(context); // Dismiss loading

                      if (success) {
                        setState(() {
                          _profileName = updatedName;
                          if (updatedAge != null) _profileAge = updatedAge;
                          _profileLocation = updatedLocation;
                          _profileJob = updatedJob;
                          if (isPremium) {
                            _bloodGroup = bloodGroup;
                            _genotype = genotype;
                            _healthStatus = healthStatusController.text.trim();
                            _appearance = appearanceController.text.trim();
                            _islamicLevel = islamicLevel;
                            _modeOfDressing = modeOfDressing;
                            _openToPolygamy = openToPolygamy;
                            _willingToRelocate = willingToRelocate;
                            _marriageTimeline = marriageTimeline;
                            _spouseMaritalStatus = spouseMaritalStatus;
                            _spouseChildrenPref = spouseChildrenPref;
                            _spouseLocation = spouseLocationController.text.trim();
                          }
                        });
                        if (context.mounted) {
                          Navigator.pop(context); // Dismiss sheet
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated successfully.')),
                          );
                        }
                      } else {
                        final error = ref.read(authProvider).errorMessage ?? 'Sync failed';
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to save changes: $error')),
                          );
                        }
                      }
                    },
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable dropdown field for use inside bottom sheet modals
  Widget _buildModalDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: options.contains(value) ? value : options.first,
          items: options
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt, style: GoogleFonts.inter(fontSize: 13))))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  void _showContactDetailsBottomSheet() {
    final emailController = TextEditingController(text: _email);
    final phoneController = TextEditingController(text: _phone);

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
                  'Email & Phone Number',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkCharcoal,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),
            Text('Email Address', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter your email'),
            ),
            const SizedBox(height: 16),
            Text('Phone Number', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: 'Enter your phone number'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final updatedEmail = emailController.text.trim();
                  final updatedPhone = phoneController.text.trim();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );

                  final success = await ref.read(authProvider.notifier).updateProfile(
                    fullName: _profileName,
                    stateName: _profileLocation,
                    phoneNumber: updatedPhone,
                    email: updatedEmail,
                    age: _profileAge,
                    occupation: _profileJob,
                    education: _prefEducation,
                  );

                  if (context.mounted) {
                    Navigator.pop(context); // Dismiss loading dialog
                  }

                  if (success) {
                    setState(() {
                      _email = updatedEmail;
                      _phone = updatedPhone;
                    });
                    if (context.mounted) {
                      Navigator.pop(context); // Dismiss sheet
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contact details synced to backend successfully.')),
                      );
                    }
                  } else {
                    final error = ref.read(authProvider).errorMessage ?? 'Sync failed';
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to sync contact details: $error')),
                      );
                    }
                  }
                },
                child: Text(
                  'Save Contact Details',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVerificationStatusDialog() {
    final user = ref.read(authProvider).user;
    final status = user?.status ?? 'Unverified';

    String statusLabel;
    String statusDesc;
    Color statusColor;
    IconData statusIcon;

    if (status == 'Verified') {
      statusLabel = 'PREMIUM VERIFIED ✓';
      statusDesc = 'Your profile has been fully verified by our admin board after reviewing your government-issued documentation. Your Premium badge is now ACTIVE.';
      statusColor = AppTheme.primaryGreen;
      statusIcon = Icons.verified;
    } else if (status == 'Pending') {
      statusLabel = 'PENDING REVIEW';
      statusDesc = 'Your documents are currently under review by our admin team. You will be notified once the verification is approved. This typically takes 24–48 hours.';
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_empty_outlined;
    } else {
      statusLabel = 'NOT VERIFIED';
      statusDesc = 'Your account has not been verified yet. Submit a valid government ID through the Premium Upgrade process to unlock Premium Verified status and see matches.';
      statusColor = Colors.red[400]!;
      statusIcon = Icons.verified_user_outlined;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 28),
            const SizedBox(width: 8),
            Text('Verification Status', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Text(
                statusLabel,
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              statusDesc,
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.darkCharcoal, height: 1.4),
            ),
            if (status == 'Unverified') ...[  
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/premium-upgrade');
                  },
                  icon: const Icon(Icons.verified_outlined, size: 16),
                  label: Text('Start Verification Now', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it', style: GoogleFonts.inter(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showPartnerPreferencesBottomSheet() {
    double minAge = _prefMinAge;
    double maxAge = _prefMaxAge;
    String education = _prefEducation;
    String sect = _prefSect;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
                    'Partner Preferences',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkCharcoal,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Preferred Age Range: ${minAge.toInt()} - ${maxAge.toInt()} years',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              RangeSlider(
                values: RangeValues(minAge, maxAge),
                min: 18,
                max: 60,
                divisions: 42,
                activeColor: AppTheme.primaryGreen,
                inactiveColor: Colors.grey[200],
                labels: RangeLabels('${minAge.toInt()}', '${maxAge.toInt()}'),
                onChanged: (RangeValues vals) {
                  setModalState(() {
                    minAge = vals.start;
                    maxAge = vals.end;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text('Education Level', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: education,
                items: ["High School", "Bachelor's Degree", "Master's Degree", "PhD"]
                    .map((edu) => DropdownMenuItem(value: edu, child: Text(edu)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() => education = val);
                  }
                },
              ),
              const SizedBox(height: 16),
              Text('Sect / Practice School', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: sect,
                items: ["Sunni", "Salafi", "Sufi", "Other"]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() => sect = val);
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      _prefMinAge = minAge;
                      _prefMaxAge = maxAge;
                      _prefEducation = education;
                      _prefSect = sect;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Partner preferences updated successfully.')),
                    );
                  },
                  child: Text(
                    'Save Preferences',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDiscoveryRadiusBottomSheet() {
    double radius = _discoveryRadius;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discovery Radius',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkCharcoal,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Maximum Distance', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('${radius.toInt()} km', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                ],
              ),
              const SizedBox(height: 12),
              Slider(
                value: radius,
                min: 10,
                max: 500,
                divisions: 49,
                activeColor: AppTheme.primaryGreen,
                inactiveColor: Colors.grey[200],
                label: '${radius.toInt()} km',
                onChanged: (val) {
                  setModalState(() => radius = val);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      _discoveryRadius = radius;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Discovery radius set to ${radius.toInt()} km.')),
                    );
                  },
                  child: Text(
                    'Save Radius',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBlockedUsersBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Blocked Users',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkCharcoal,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              if (_blockedUsers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: Text('No blocked users yet.', style: GoogleFonts.inter(color: AppTheme.secondaryGrey)),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _blockedUsers.length,
                    itemBuilder: (context, index) {
                      final user = _blockedUsers[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                          title: Text(
                            user,
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                          ),
                          subtitle: Text('Blocked on 12 Apr 2026', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey)),
                          trailing: TextButton(
                            onPressed: () {
                              setModalState(() {
                                _blockedUsers.remove(user);
                              });
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$user has been unblocked.')),
                              );
                            },
                            child: Text(
                              'Unblock',
                              style: GoogleFonts.inter(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Change Password', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: oldController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Current Password'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: newController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm New Password'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              if (oldController.text.isEmpty ||
                  newController.text.isEmpty ||
                  confirmController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all password fields.')),
                );
                return;
              }
              if (newController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New passwords do not match.')),
                );
                return;
              }
              if (newController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New password must be at least 6 characters.')),
                );
                return;
              }
              // Dismiss dialog first
              Navigator.pop(dialogContext);
              // Show loading spinner
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: AppTheme.primaryGreen),
                ),
              );
              final success = await ref.read(authProvider.notifier).changePassword(
                oldPassword: oldController.text,
                newPassword: newController.text,
              );
              if (mounted) Navigator.pop(context); // Dismiss spinner
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully.'),
                    backgroundColor: AppTheme.primaryGreen,
                  ),
                );
              } else {
                final error = ref.read(authProvider).errorMessage ?? 'Password change failed.';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error), backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
            child: Text('Update', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAboutBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3), width: 2),
              ),
              child: const Icon(Icons.mosque_outlined, color: AppTheme.primaryGreen, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              'Nupe Halal Connect',
              style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Version 1.0.0',
                style: GoogleFonts.inter(fontSize: 12, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'A Halal matchmaking platform built on Islamic values and ethics. Connecting Muslim men and women seeking marriage under the guidance of their Wali and supervised by verified Imams.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            _buildAboutInfoRow(Icons.email_outlined, 'support@nupehalalconnect.com'),
            const SizedBox(height: 10),
            _buildAboutInfoRow(Icons.phone_outlined, '+234 704 585 9388'),
            const SizedBox(height: 10),
            _buildAboutInfoRow(Icons.language_outlined, 'www.nupehalalconnect.com'),
            const SizedBox(height: 10),
            _buildAboutInfoRow(Icons.copyright_outlined, '© 2026 Nupe Halal Connect. All rights reserved.'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryGreen),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Close', style: GoogleFonts.inter(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: AppTheme.primaryGreen),
        const SizedBox(width: 8),
        Flexible(
          child: Text(text, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
        ),
      ],
    );
  }

  void _showHelpCenterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Help Center & FAQs',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkCharcoal,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(
                        'How does the Wali guardian system work?',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'Nupe Halal Connect enforces strict Islamic etiquette. For female seekers, communications and matching request approvals are supervised by their registered Wali (guardian) directly via the Wali app portal.',
                            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.secondaryGrey, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(
                        'Is my personal data kept secure?',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'Absolutely. We encrypt all user profile information, contact coordinates, and document files. Photos are protected and screenshot capabilities are restricted to ensure maximum privacy.',
                            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.secondaryGrey, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(
                        'How do I upgrade to Premium Verification?',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'Go to the verification screen under account settings and upload a clear picture of a valid government ID. Once reviewed and approved by our admins, you will receive the Premium Verification status badge.',
                            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.secondaryGrey, height: 1.4),
                          ),
                        ),
                      ],
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

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Terms of Service', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              'Welcome to Nupe Halal Connect. By accessing or using our mobile application, you agree to comply with and be bound by the following terms and conditions:\n\n1. Ethical Use: Users must interact with other members solely for the purpose of seeking marriage in accordance with Islamic values.\n\n2. Guardian Consent: Female seekers acknowledge and agree that their registered Wali will have full insight and final approval of matches.\n\n3. Accurate Information: All details provided must be accurate, authentic, and verified.',
              style: GoogleFonts.inter(fontSize: 13, height: 1.4, color: AppTheme.darkCharcoal),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.inter(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Privacy Policy', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              'Nupe Halal Connect is committed to protecting your privacy. This policy details how we collect, store, and safeguard your data:\n\n1. Data Collection: We collect setup profiles, verification identity cards, and chat communications.\n\n2. Security Standards: All sensitive documents and database records are securely encrypted using standard protocols.\n\n3. Zero Sharing: We never sell or share user data with third parties for commercial use.',
              style: GoogleFonts.inter(fontSize: 13, height: 1.4, color: AppTheme.darkCharcoal),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.inter(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userStatus = authState.user?.status ?? 'Unverified';
    Color badgeBg;
    Color badgeText;
    if (userStatus == 'Verified') {
      badgeBg = const Color(0xFFE8F5E9);
      badgeText = AppTheme.primaryGreen;
    } else if (userStatus == 'Pending') {
      badgeBg = const Color(0xFFFFF3E0);
      badgeText = Colors.orange[800]!;
    } else {
      badgeBg = const Color(0xFFECEFF1);
      badgeText = Colors.blueGrey[700]!;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.darkCharcoal, size: 20),
            padding: EdgeInsets.zero,
            onPressed: () => context.pop(),
          ),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkCharcoal,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAF6),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // 1. ACCOUNT SETTINGS
                  _buildSectionHeader('Account Settings'),
                  _buildSettingsTile(
                    Icons.person_outline,
                    'Edit Profile Information',
                    subtitle: 'Update basic, lifestyle & family details',
                    onTap: _showEditProfileBottomSheet,
                  ),
                  _buildSettingsTile(
                    Icons.mail_outline,
                    'Email & Phone Number',
                    subtitle: 'manage your contact details',
                    onTap: _showContactDetailsBottomSheet,
                  ),
                  _buildSettingsTile(
                    Icons.verified_user_outlined,
                    'Verification Status',
                    onTap: _showVerificationStatusDialog,
                    trailingWidget: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: badgeText.withOpacity(0.3)),
                      ),
                      child: Text(
                        userStatus == 'Verified' ? 'Premium Verified' : userStatus,
                        style: GoogleFonts.inter(fontSize: 11, color: badgeText, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. MATCH PREFERENCES
                  _buildSectionHeader('Match Preferences'),
                  _buildSettingsTile(
                    Icons.tune,
                    'Partner Preferences',
                    subtitle: 'Refine location, education, religiosity preferences',
                    onTap: _showPartnerPreferencesBottomSheet,
                  ),
                  _buildSettingsTile(
                    Icons.location_on_outlined,
                    'Discovery Radius',
                    subtitle: 'Set maximum match distance filters',
                    onTap: _showDiscoveryRadiusBottomSheet,
                  ),
                  const SizedBox(height: 20),

                  // 3. NOTIFICATIONS
                  _buildSectionHeader('Notification Preferences'),
                  _buildSwitchTile(
                    Icons.notifications_active_outlined,
                    'Push Notifications',
                    'Get instant updates for matches & chats',
                    _pushNotifications,
                    (val) {
                      setState(() => _pushNotifications = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Push notifications ${val ? 'enabled' : 'disabled'}.')),
                      );
                    },
                  ),
                  _buildSwitchTile(
                    Icons.favorite_border,
                    'Match Alerts',
                    'Notify me when a new match is found',
                    _matchAlerts,
                    (val) {
                      setState(() => _matchAlerts = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Match alerts ${val ? 'enabled' : 'disabled'}.')),
                      );
                    },
                  ),
                  _buildSwitchTile(
                    Icons.email_outlined,
                    'Email Alerts',
                    'Weekly match digests and newsletters',
                    _emailAlerts,
                    (val) {
                      setState(() => _emailAlerts = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email alerts ${val ? 'enabled' : 'disabled'}.')),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // 4. PRIVACY & SECURITY
                  _buildSectionHeader('Privacy & Security'),
                  _buildDropdownTile(
                    Icons.lock_outline,
                    'Profile Visibility',
                    'Control who can see your profile card',
                    _profileVisibility,
                    ['Public', 'Matches Only', 'Private'],
                    (val) {
                      if (val != null) {
                        setState(() => _profileVisibility = val);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Profile visibility updated to $val.')),
                        );
                      }
                    },
                  ),
                  _buildSettingsTile(
                    Icons.block_outlined,
                    'Blocked Users',
                    subtitle: 'Manage blocked profiles list',
                    onTap: _showBlockedUsersBottomSheet,
                  ),
                  _buildSettingsTile(
                    Icons.security_outlined,
                    'Change Password',
                    onTap: _showChangePasswordDialog,
                  ),
                  const SizedBox(height: 20),

                  // 5. HELP & LEGAL
                  _buildSectionHeader('Help & Support'),
                  _buildSettingsTile(Icons.help_outline, 'Help Center / FAQs', onTap: _showHelpCenterBottomSheet),
                  _buildSettingsTile(Icons.description_outlined, 'Terms of Service', onTap: _showTermsDialog),
                  _buildSettingsTile(Icons.policy_outlined, 'Privacy Policy', onTap: _showPrivacyPolicyDialog),
                  _buildSettingsTile(
                    Icons.info_outline,
                    'About Nupe Halal Connect',
                    onTap: _showAboutBottomSheet,
                    trailingWidget: Text(
                      'v1.0.0',
                      style: GoogleFonts.inter(fontSize: 12, color: AppTheme.secondaryGrey),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 6. DANGER ZONE
                  _buildSectionHeader('Danger Zone'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[100]!),
                    ),
                    child: ListTile(
                      onTap: () {
                        // Account deletion warning confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Account', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                            content: Text(
                              'Are you absolutely sure you want to delete your account? This action is irreversible and all your match history will be lost.',
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context); // Close dialog
                                  final success = await ref.read(authProvider.notifier).deleteAccount();
                                  if (context.mounted) {
                                    if (success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Account permanently deleted.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      context.go('/login');
                                    } else {
                                      final errorMsg = ref.read(authProvider).errorMessage ?? 'Failed to delete account.';
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(errorMsg),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: Text('Delete', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                      leading: const Icon(Icons.delete_forever_outlined, color: Colors.red, size: 20),
                      title: Text(
                        'Permanently Delete Account',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.red, size: 18),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          const CustomBottomNav(currentIndex: 4), // Profile Settings
        ],
      ),
    );
  }

  // BUILD SECTION HEADER
  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, top: 4.0),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.secondaryGrey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // STANDARD TILE
  Widget _buildSettingsTile(IconData icon, String title, {String? subtitle, Widget? trailingWidget, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ListTile(
        onTap: onTap,
        dense: false,
        leading: Icon(icon, color: AppTheme.darkCharcoal, size: 20),
        title: Text(
          title,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
              )
            : null,
        trailing: trailingWidget ?? const Icon(Icons.chevron_right, color: AppTheme.secondaryGrey, size: 18),
      ),
    );
  }

  // SWITCH TILE
  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ListTile(
        dense: false,
        leading: Icon(icon, color: AppTheme.darkCharcoal, size: 20),
        title: Text(
          title,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: AppTheme.primaryGreen,
          inactiveThumbColor: Colors.grey[300],
          inactiveTrackColor: Colors.grey[200],
        ),
      ),
    );
  }

  // DROPDOWN TILE
  Widget _buildDropdownTile(IconData icon, String title, String subtitle, String currentValue, List<String> options, ValueChanged<String?> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ListTile(
        dense: false,
        leading: Icon(icon, color: AppTheme.darkCharcoal, size: 20),
        title: Text(
          title,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
        ),
        trailing: DropdownButton<String>(
          value: currentValue,
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.secondaryGrey),
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.darkCharcoal, fontWeight: FontWeight.bold),
          items: options.map((opt) {
            return DropdownMenuItem(
              value: opt,
              child: Text(opt),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
