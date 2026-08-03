import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

  // Blocked users list
  final List<String> _blockedUsers = ['Ahmad Bello', 'Fatima Yusuf'];

  void _showEditProfileBottomSheet() {
    final nameController = TextEditingController(text: _profileName);
    final ageController = TextEditingController(text: _profileAge.toString());
    final locationController = TextEditingController(text: _profileLocation);
    final jobController = TextEditingController(text: _profileJob);

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
                        _profileName = nameController.text.trim();
                        _profileAge = int.tryParse(ageController.text) ?? _profileAge;
                        _profileLocation = locationController.text.trim();
                        _profileJob = jobController.text.trim();
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile information updated successfully.')),
                      );
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
                onPressed: () {
                  setState(() {
                    _email = emailController.text.trim();
                    _phone = phoneController.text.trim();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact details updated successfully.')),
                  );
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.verified, color: AppTheme.primaryGreen, size: 28),
            const SizedBox(width: 8),
            Text('Verification Status', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nupe Halal Connect Profile: PREMIUM VERIFIED',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
            ),
            const SizedBox(height: 12),
            Text(
              'Your profile has been fully verified by our admin board after reviewing your government-issued documentation.',
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.darkCharcoal, height: 1.4),
            ),
            const SizedBox(height: 10),
            Text(
              'Verified date: 15 June 2026\nBadge status: ACTIVE',
              style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
            ),
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
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              if (oldController.text.isEmpty || newController.text.isEmpty || confirmController.text.isEmpty) return;
              if (newController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New passwords do not match.')),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
            child: Text('Update', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
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
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                      ),
                      child: Text(
                        'Premium Verified',
                        style: GoogleFonts.inter(fontSize: 11, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
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
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.go('/login');
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
