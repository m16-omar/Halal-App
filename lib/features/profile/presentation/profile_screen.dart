import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../authentication/presentation/auth_provider.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final int _currentIndex = 4; // Profile tab selected

  final String _aishaPhoto = 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80';
  final String _yusufPhoto = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80';
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF6),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      color: AppTheme.primaryGreen,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            _buildSeekerProfileCard(),
                            _buildSubActionsRow(),
                            _buildPremiumVerificationBanner(),
                            _buildYourActivitySection(),
                            _buildCompleteYourProfileChecklist(),
                            _buildGoPremiumBanner(),
                            _buildAccountPreferencesSection(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildCustomBottomNav(),
        ],
      ),
    );
  }

  // --- HEADER SECTION ---
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Profile',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCharcoal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your profile and settings',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.secondaryGrey,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Notification Bell
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_outlined, color: AppTheme.darkCharcoal, size: 26),
                    onPressed: () => context.push('/notifications'),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '3',
                        style: GoogleFonts.inter(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              // Settings Button
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: AppTheme.darkCharcoal, size: 26),
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SEEKER PROFILE CARD ---
  Widget _buildSeekerProfileCard() {
    final user = ref.watch(authProvider).user;
    final isMale = user?.gender.toLowerCase() == 'male' || user?.gender.toLowerCase() == 'groom';
    final photoUrl = isMale ? _yusufPhoto : _aishaPhoto;
    final fullName = user?.fullName ?? 'Aisha Usman';
    final locationText = user?.state != null && user!.state.isNotEmpty ? "${user.state}, Nigeria" : "Ilorin, Kwara State, Nigeria";
    final educationText = isMale ? "Bachelor of Engineering • Software Engineer" : "Undergraduate – Biology • Student";

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF042415), Color(0xFF0D3E29)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF042415).withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Photo with Camera overlay
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Middle: Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        fullName,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isMale ? '25 years • 12 Rajab 1443 AH' : '22 years • 15 Safar 1446 AH',
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                // Pill Tags Row
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _buildPillTag('Practicing Muslim', const Color(0xFF0A5C3D)),
                    _buildPillTag('Sunni', const Color(0xFF10B981).withOpacity(0.2)),
                    _buildPillTag(isMale ? 'Bearded' : 'Niqabi', const Color(0xFF6B21A8)),
                  ],
                ),
                const SizedBox(height: 8),
                // Location row
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.white70, size: 12),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        locationText,
                        style: GoogleFonts.inter(fontSize: 10, color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Education row
                Row(
                  children: [
                    const Icon(Icons.school_outlined, color: Colors.white70, size: 12),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        educationText,
                        style: GoogleFonts.inter(fontSize: 10, color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Right: Profile Strength column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(
                      value: 0.92,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                      strokeWidth: 4,
                    ),
                  ),
                  Text(
                    '92%',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Profile Strength',
                style: GoogleFonts.inter(fontSize: 8, color: Colors.white54),
              ),
              Text(
                'Excellent',
                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Improve Profile',
                        style: GoogleFonts.inter(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right, size: 8, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPillTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // --- SUB ACTIONS GRID ROW ---
  Widget _buildSubActionsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildSubActionItem(Icons.person_outline, 'Edit Profile', onTap: () {}),
              _buildSubActionItem(Icons.verified_user_outlined, 'Verification', onTap: () {
                context.push('/verification');
              }),
              _buildSubActionItem(Icons.image_outlined, 'Photos', badgeCount: 12, onTap: () {}),
              _buildSubActionItem(Icons.star_outline, 'My Interests', onTap: () {}),
              _buildSubActionItem(Icons.description_outlined, 'Documents', onTap: () {}),
              _buildSubActionItem(Icons.visibility_outlined, 'Profile Views', badgeCount: 36, onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubActionItem(IconData icon, String label, {int? badgeCount, VoidCallback? onTap}) {
    return SizedBox(
      width: 78,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: AppTheme.primaryGreen, size: 24),
                if (badgeCount != null)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: GoogleFonts.inter(fontSize: 7, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // --- PREMIUM VERIFICATION BANNER ---
  Widget _buildPremiumVerificationBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F8F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFB2DFDB).withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.verified_user, color: Color(0xFF2E7D32), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You are Premium Verified',
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Your profile is visible to verified members only.',
                    style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'View Verification Details >',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: const Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withOpacity(0.04)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 10, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 2),
                      Text('Verified on', style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '12 Apr 2026',
                    style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- YOUR ACTIVITY SECTION ---
  Widget _buildYourActivitySection() {
    final List<Map<String, dynamic>> activities = [
      {'count': '24', 'label': 'Interest Received', 'icon': Icons.favorite, 'color': Colors.red},
      {'count': '18', 'label': 'Interest Sent', 'icon': Icons.send_outlined, 'color': Colors.teal},
      {'count': '5', 'label': 'Conversations', 'icon': Icons.people_outline, 'color': Colors.blue},
      {'count': '2', 'label': 'Meetings Proposed', 'icon': Icons.calendar_today_outlined, 'color': Colors.green},
      {'count': '36', 'label': 'Profile Views', 'icon': Icons.visibility_outlined, 'color': Colors.orange},
      {'count': '7', 'label': 'Saved Profiles', 'icon': Icons.bookmark_border_outlined, 'color': Colors.purple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Activity',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View all',
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final act = activities[index];
              return Container(
                width: 95,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withOpacity(0.03)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(act['icon'], color: act['color'], size: 18),
                    const SizedBox(height: 4),
                    Text(
                      act['count'],
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      act['label'],
                      style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- COMPLETE YOUR PROFILE CHECKLIST ---
  Widget _buildCompleteYourProfileChecklist() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.04)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Complete Your Profile',
                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
                Text(
                  '4/6 Completed',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF1B5E20)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Add more details to get better matches.',
              style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey),
            ),
            const SizedBox(height: 12),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 4 / 6,
                backgroundColor: Color(0xFFE8F5E9),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 16),
            // Two-column Checklist grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildChecklistItem('Basic Information', true),
                      _buildChecklistItem('Lifestyle & Values', true),
                      _buildChecklistItem('Family Background', true),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildChecklistItem('Photos', false, detail: '3/5 photos added'),
                      _buildChecklistItem('Identity Verification', true),
                      _buildChecklistItem('About Me', false, detail: 'Add your story', isCallToAction: true),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String label, bool isCompleted, {String? detail, bool isCallToAction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: isCompleted ? const Color(0xFF2E7D32) : Colors.grey[400],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
                if (detail != null)
                  Text(
                    detail,
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: isCallToAction ? const Color(0xFFEF6C00) : AppTheme.secondaryGrey,
                    ),
                  ),
              ],
            ),
          ),
          if (!isCompleted)
            Icon(Icons.chevron_right, size: 10, color: Colors.grey[400]),
        ],
      ),
    );
  }

  // --- GO PREMIUM BANNER ---
  Widget _buildGoPremiumBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDDD6FE).withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.workspace_premium_outlined, color: Color(0xFF7C3AED), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Go Premium',
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF5B21B6)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Get more visibility, unlimited interests, and advanced features.',
                    style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF7C3AED), height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => context.push('/premium-upgrade'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                minimumSize: Size.zero,
              ),
              child: Row(
                children: [
                  Text('Upgrade to Premium', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_forward_ios, size: 8, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ACCOUNT & PREFERENCES ---
  Widget _buildAccountPreferencesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Text(
              'Account & Preferences',
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.04)),
            ),
            child: Column(
              children: [
                _buildPreferenceTile(Icons.notifications_none_outlined, 'Notification Settings', onTap: () => context.push('/settings')),
                const Divider(height: 1, indent: 48),
                _buildPreferenceTile(Icons.lock_outline, 'Privacy & Security', onTap: () => context.push('/settings')),
                const Divider(height: 1, indent: 48),
                _buildPreferenceTile(Icons.language, 'Language', trailing: _selectedLanguage, onTap: () => _showLanguageBottomSheet(context)),
                const Divider(height: 1, indent: 48),
                _buildPreferenceTile(Icons.help_outline, 'Help & Support', onTap: () => _showHelpSupportBottomSheet(context)),
                const Divider(height: 1, indent: 48),
                _buildPreferenceTile(Icons.exit_to_app, 'Log Out', isDestructive: true, onTap: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (mounted) {
                    context.go('/login');
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceTile(IconData icon, String label, {String? trailing, bool isDestructive = false, VoidCallback? onTap}) {
    Color itemColor = isDestructive ? Colors.red : AppTheme.darkCharcoal;
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : AppTheme.primaryGreen, size: 20),
      title: Text(
        label,
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: itemColor),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: GoogleFonts.inter(fontSize: 12, color: AppTheme.secondaryGrey),
            ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 16, color: Colors.grey[400]),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      dense: true,
    );
  }



  void _showLanguageBottomSheet(BuildContext context) {
    final List<String> languages = ['English', 'العربية (Arabic)', 'Hausa', 'Yoruba'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select App Language',
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
              const SizedBox(height: 12),
              ...languages.map((lang) {
                bool isSelected = _selectedLanguage == lang || 
                  (_selectedLanguage == 'English' && lang == 'English');
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    lang,
                    style: GoogleFonts.inter(
                      fontSize: 12, 
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppTheme.primaryGreen : AppTheme.darkCharcoal
                    ),
                  ),
                  trailing: isSelected 
                    ? const Icon(Icons.check, color: AppTheme.primaryGreen, size: 18) 
                    : null,
                  onTap: () {
                    setState(() {
                      _selectedLanguage = lang;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Language changed to $lang'),
                        backgroundColor: AppTheme.primaryGreen,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showHelpSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Help & Support',
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.question_answer_outlined, color: AppTheme.primaryGreen, size: 20),
                title: Text('Frequently Asked Questions (FAQs)', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.chevron_right, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/settings'); // Lead to settings help section
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat_outlined, color: AppTheme.primaryGreen, size: 20),
                title: Text('Chat with Support Admin', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.chevron_right, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Connecting to Support via WhatsApp (07045859388)...'),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.mail_outline, color: AppTheme.primaryGreen, size: 20),
                title: Text('Email Support Team', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.chevron_right, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Support Email: support@nupehalalconnect.com'),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // --- CUSTOM BOTTOM NAVIGATION BAR ---
  Widget _buildCustomBottomNav() {
    return const CustomBottomNav(currentIndex: 4);
  }
}
