import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _currentIndex = 4; // Profile tab selected
  int _activeTab = 0; // "About" tab active
  int _selectedQuotePage = 0;

  final String _aishaPhoto = 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF6),
      body: RefreshIndicator(
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
              _buildHeader(),
              _buildProfileContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }

  // --- HEADER SECTION ---
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF04140C),
            Color(0xFF082214),
          ],
        ),
      ),
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aisha\'s Profile',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Last active 2 hours ago',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withAlpha(178),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.white, size: 24),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white, size: 24),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- PROFILE CONTENT BODY ---
  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPersonalSummaryCard(),
          const SizedBox(height: 16),
          _buildKeySpecsRow(),
          const SizedBox(height: 20),
          _buildTabBar(),
          const SizedBox(height: 20),
          _buildSplitColumns(),
          const SizedBox(height: 24),
          _buildCompatibilityAndQuoteRow(),
          const SizedBox(height: 24),
          _buildFooterMetadata(),
        ],
      ),
    );
  }

  // --- PERSONAL SUMMARY CARD ---
  Widget _buildPersonalSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Photo with Badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 140,
                  height: 180,
                  child: Image.network(
                    _aishaPhoto,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(color: Colors.grey[200]),
                  ),
                ),
              ),
              // Top Right Verified Badge
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check, color: Colors.white, size: 8),
                      const SizedBox(width: 2),
                      Text(
                        'Verified',
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Left Photo Count
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(128),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.image_outlined, color: Colors.white, size: 10),
                      const SizedBox(width: 4),
                      Text(
                        '4',
                        style: GoogleFonts.inter(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Info Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Aisha Usman',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkCharcoal,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.verified, color: Color(0xFF10B981), size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '22 years old  •  15 Safar 1446 AH',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.secondaryGrey,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSummaryDetailRow(Icons.location_on_outlined, 'Ilorin, Kwara State, Nigeria'),
                const SizedBox(height: 6),
                _buildSummaryDetailRow(Icons.school_outlined, 'Student – Biology\nUniversity of Ilorin'),
                const SizedBox(height: 6),
                _buildSummaryDetailRow(Icons.brightness_3_outlined, 'Practicing Muslim\nSunni  •  Niqabi'),
                const SizedBox(height: 12),
                // Profile Strength
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Profile Strength: Excellent',
                                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32)),
                              ),
                            ],
                          ),
                          Text(
                            '92%',
                            style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: const LinearProgressIndicator(
                          value: 0.92,
                          backgroundColor: Colors.white60,
                          color: Color(0xFF2E7D32),
                          minHeight: 4,
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
    );
  }

  Widget _buildSummaryDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppTheme.primaryGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 11, color: AppTheme.darkCharcoal, height: 1.3),
          ),
        ),
      ],
    );
  }

  // --- KEY SPECS ROW ---
  Widget _buildKeySpecsRow() {
    final List<Map<String, String>> specs = [
      {'title': 'Marital Status', 'value': 'Never Married', 'icon': 'person'},
      {'title': 'Height', 'value': '162 cm', 'icon': 'straighten'},
      {'title': 'Education', 'value': 'Undergraduate', 'icon': 'bookmark'},
      {'title': 'Family Origin', 'value': 'Ilorin, Kwara State', 'icon': 'home'},
      {'title': 'Looking For', 'value': 'Marriage', 'icon': 'favorite'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(8), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: specs.map((spec) {
          IconData iconData;
          switch (spec['icon']) {
            case 'person':
              iconData = Icons.person_outline;
              break;
            case 'straighten':
              iconData = Icons.straighten;
              break;
            case 'bookmark':
              iconData = Icons.bookmark_border;
              break;
            case 'home':
              iconData = Icons.home_outlined;
              break;
            default:
              iconData = Icons.favorite_border;
          }
          return Expanded(
            child: Column(
              children: [
                Icon(iconData, color: AppTheme.primaryGreen, size: 18),
                const SizedBox(height: 6),
                Text(
                  spec['title']!,
                  style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  spec['value']!,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- TAB BAR WIDGET ---
  Widget _buildTabBar() {
    final List<String> tabs = ['About', 'Preferences', 'Lifestyle', 'Family Background', 'Photos'];
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12, width: 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            bool isActive = _activeTab == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _activeTab = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isActive ? AppTheme.primaryGreen : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? AppTheme.primaryGreen : AppTheme.secondaryGrey,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // --- SPLIT COLUMNS (About & Values on Left, Chaperone actions on Right) ---
  Widget _buildSplitColumns() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column
        Expanded(
          flex: 11,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // About Me
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withAlpha(8), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Me',
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"I am a practicing Muslim who loves Allah and strives to follow the Qur\'an and Sunnah. I value kindness, honesty, and good character. I am looking for a God-fearing man to build a happy home with, Insha\'Allah."',
                      style: GoogleFonts.inter(fontSize: 11, color: AppTheme.darkCharcoal, height: 1.4, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // What I Value Most
              _buildTagsCard(
                title: 'What I Value Most',
                tags: [
                  {'label': 'Deen', 'bg': const Color(0xFFE8F5E9), 'color': const Color(0xFF2E7D32), 'icon': Icons.brightness_3_outlined},
                  {'label': 'Honesty', 'bg': const Color(0xFFFFEBEE), 'color': const Color(0xFFC62828), 'icon': Icons.favorite_outline},
                  {'label': 'Respect', 'bg': const Color(0xFFE8EAF6), 'color': const Color(0xFF283593), 'icon': Icons.handshake_outlined},
                  {'label': 'Family', 'bg': const Color(0xFFFFF9C4), 'color': const Color(0xFFF57F17), 'icon': Icons.family_restroom_outlined},
                  {'label': 'Loyalty', 'bg': const Color(0xFFE0F7FA), 'color': const Color(0xFF00838F), 'icon': Icons.shield_outlined},
                ],
              ),
              const SizedBox(height: 16),
              // Hobbies & Interests
              _buildTagsCard(
                title: 'Hobbies & Interests',
                tags: [
                  {'label': 'Reading', 'bg': const Color(0xFFE8F5E9), 'color': const Color(0xFF2E7D32), 'icon': Icons.menu_book_outlined},
                  {'label': 'Qur\'an', 'bg': const Color(0xFFE8F5E9), 'color': const Color(0xFF2E7D32), 'icon': Icons.auto_stories_outlined},
                  {'label': 'Cooking', 'bg': const Color(0xFFFFEBEE), 'color': const Color(0xFFC62828), 'icon': Icons.restaurant_outlined},
                  {'label': 'Nature', 'bg': const Color(0xFFE8F5E9), 'color': const Color(0xFF2E7D32), 'icon': Icons.nature_people_outlined},
                  {'label': 'Learning', 'bg': const Color(0xFFF3E5F5), 'color': const Color(0xFF6A1B9A), 'icon': Icons.lightbulb_outline},
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Right Column
        Expanded(
          flex: 9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interest Request
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFF3CD), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interested in Aisha?',
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFB78103)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Send an interest request to her wali to start the process.',
                      style: GoogleFonts.inter(fontSize: 9, color: AppTheme.darkCharcoal, height: 1.3),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Interest request successfully sent to Wali.', style: GoogleFonts.inter()),
                            backgroundColor: AppTheme.primaryGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF042415),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 38),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_add_alt_1_outlined, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'Send Interest Request',
                              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Wali info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withAlpha(8), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.security_outlined, size: 14, color: AppTheme.primaryGreen),
                        const SizedBox(width: 6),
                        Text(
                          'Wali Information',
                          style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Haji Usman Ahmad\n(Father)',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                    Text(
                      'Ilorin, Kwara State',
                      style: GoogleFonts.inter(fontSize: 9, color: AppTheme.secondaryGrey),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryGreen,
                        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                        minimumSize: const Size(double.infinity, 36),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        backgroundColor: const Color(0xFFF1F3F0),
                      ),
                      child: Text(
                        'View Wali Details',
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Share Profile
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withAlpha(8), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.share_outlined, size: 14, color: AppTheme.primaryGreen),
                        const SizedBox(width: 6),
                        Text(
                          'Share Profile',
                          style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Share this profile with your wali or a trusted family member.',
                      style: GoogleFonts.inter(fontSize: 9, color: AppTheme.secondaryGrey, height: 1.3),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryGreen,
                        side: const BorderSide(color: AppTheme.primaryGreen, width: 1),
                        minimumSize: const Size(double.infinity, 36),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.share_outlined, size: 10, color: AppTheme.primaryGreen),
                          const SizedBox(width: 4),
                          Text(
                            'Share Now',
                            style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold),
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
      ],
    );
  }

  Widget _buildTagsCard({required String title, required List<Map<String, dynamic>> tags}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: tag['bg'],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tag['icon'], size: 10, color: tag['color']),
                    const SizedBox(width: 4),
                    Text(
                      tag['label'],
                      style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: tag['color']),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- COMPATIBILITY OVERVIEW & HER OWN WORDS ---
  Widget _buildCompatibilityAndQuoteRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Compatibility Overview
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withAlpha(8), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compatibility Overview',
                  style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Circular Progress
                    Column(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  value: 0.87,
                                  strokeWidth: 4,
                                  backgroundColor: Color(0xFFF1F3F0),
                                  color: Color(0xFF10B981),
                                ),
                              ),
                              Text(
                                '87%',
                                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'High Compatibility',
                          style: GoogleFonts.inter(fontSize: 7, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Stats Details
                    Expanded(
                      child: Column(
                        children: [
                          _buildCompatibilityDetailRow('Deen & Values', '95%'),
                          const SizedBox(height: 4),
                          _buildCompatibilityDetailRow('Lifestyle Match', '82%'),
                          const SizedBox(height: 4),
                          _buildCompatibilityDetailRow('Family Background', '85%'),
                          const SizedBox(height: 4),
                          _buildCompatibilityDetailRow('Education & Goals', '86%'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'View full compatibility report',
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right, color: AppTheme.primaryGreen, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Her Own Words
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            height: 148, // match heights roughly
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6).withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Her in Her Own Words',
                      style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                    const SizedBox(height: 6),
                    const Icon(Icons.format_quote, size: 16, color: Colors.blueAccent),
                    const SizedBox(height: 4),
                    Text(
                      'I see marriage as a partnership built on faith, love and mercy. I want a companion who will help me get closer to Allah and build a home filled with His blessings.',
                      style: GoogleFonts.inter(fontSize: 9, color: AppTheme.darkCharcoal, height: 1.3),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                // Carousel dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _selectedQuotePage ? const Color(0xFF2E7D32) : Colors.black12,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompatibilityDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.check, size: 8, color: Color(0xFF10B981)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
      ],
    );
  }

  // --- FOOTER METADATA ---
  Widget _buildFooterMetadata() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(8), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFooterMetaCol('Joined', '12 Mar 2024', Icons.calendar_today_outlined),
              _buildFooterMetaCol('Profile ID', 'NHC-24567', Icons.fingerprint_outlined),
              _buildFooterMetaCol('Verified on', '15 Apr 2024', Icons.verified_outlined),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flag_outlined, color: Colors.red, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Report Profile',
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Text(
                  'Report if inappropriate',
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.red.withOpacity(0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterMetaCol(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 14, color: AppTheme.secondaryGrey),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
        ),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
      ],
    );
  }

  // --- CUSTOM BOTTOM NAVIGATION BAR ---
  Widget _buildCustomBottomNav() {
    return Container(
      height: 85,
      color: const Color(0xFF04140C),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavItem(Icons.home_outlined, 'Home', 0),
          _buildNavItem(Icons.favorite_border, 'Matches', 1),
          _buildWaliChatButton(),
          _buildNavItem(Icons.supervisor_account_outlined, 'Counseling', 2),
          _buildNavItem(Icons.person, 'Profile', 3), // Profile selected
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          context.go('/home');
        } else if (index == 1) {
          context.push('/matches');
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF10B981) : Colors.white60,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF10B981) : Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaliChatButton() {
    return GestureDetector(
      onTap: () {
        context.push('/wali-chat');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: const Offset(0, -6),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.people_alt,
                color: Color(0xFF04140C),
                size: 24,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -2),
            child: Text(
              'Wali Chat',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4AF37),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
