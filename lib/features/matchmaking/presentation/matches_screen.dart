import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  int _selectedStatusFilter = 0; // 0: All Matches, 1: New Members, 2: Recently Active, 3: Near You, 4: Compatible
  String _selectedAge = '20 - 30';
  String _selectedLocation = 'All';
  String _selectedEducation = 'All';

  // Mock portraits
  final String _aishaPhoto = 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80';
  final String _yusufPhoto = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80';
  final String _fatimaPhoto = 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=500&auto=format&fit=crop&q=80';
  final String _ibrahimPhoto = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80';
  final String _maryamPhoto = 'https://images.unsplash.com/photo-1589156280159-27698a70f29e?w=500&auto=format&fit=crop&q=80';
  final String _hassanPhoto = 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=80';
  final String _zainabPhoto = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF6),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      _buildPremiumBanner(),
                      _buildSubNavigationTabBar(),
                      _buildFilterBar(),
                      _buildDailyPicksSection(),
                      _buildIncreaseChancesCard(),
                      _buildRecommendedSection(),
                      _buildTrustInAllahCard(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const CustomBottomNav(currentIndex: 1),
        ],
      ),
    );
  }

  // 1. HEADER SECTION
  Widget _buildHeaderSection() {
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
                'Matches',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCharcoal,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Find your hopeful partner',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.secondaryGrey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.favorite, size: 14, color: AppTheme.primaryGreen),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: IconButton(
                  icon: const Icon(Icons.search, color: AppTheme.darkCharcoal, size: 22),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: AppTheme.darkCharcoal, size: 22),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. PREMIUM MATCHES BANNER
  Widget _buildPremiumBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF042415),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF042415).withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Shield Badge
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                color: Colors.white.withOpacity(0.05),
              ),
              child: const Icon(Icons.shield_outlined, color: Color(0xFFD4AF37), size: 24),
            ),
            const SizedBox(width: 14),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Matches',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Get up to 5x more visibility and connect with serious members.',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Upgrade button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFECC8),
                foregroundColor: const Color(0xFF042415),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                minimumSize: Size.zero,
              ),
              child: Text(
                'Upgrade to Premium >',
                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF042415)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. SUB-NAVIGATION TAB BAR
  Widget _buildSubNavigationTabBar() {
    final List<Map<String, dynamic>> tabs = [
      {'label': 'All Matches', 'icon': Icons.group_outlined},
      {'label': 'New Members', 'icon': Icons.person_add_alt_1_outlined},
      {'label': 'Recently Active', 'icon': Icons.access_time},
      {'label': 'Near You', 'icon': Icons.location_on_outlined},
      {'label': 'Compatible', 'icon': Icons.favorite_outline},
    ];

    return Container(
      color: Colors.white,
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedStatusFilter == index;
          final tab = tabs[index];
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _selectedStatusFilter = index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    tab['icon'],
                    size: 16,
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.secondaryGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tab['label'],
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppTheme.primaryGreen : AppTheme.secondaryGrey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 4. FILTER BAR
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Filter Badge
            _buildFilterChip(
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 12, color: AppTheme.darkCharcoal),
                  const SizedBox(width: 4),
                  Text(
                    'Filter',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  ),
                ],
              ),
            ),
            _buildDropdownFilterChip('Age', _selectedAge, ['18 - 30', '20 - 30', '31 - 40', '41+'], (val) {
              setState(() => _selectedAge = val);
            }),
            _buildDropdownFilterChip('Location', _selectedLocation, ['All', 'Niger', 'Kwara', 'Abuja'], (val) {
              setState(() => _selectedLocation = val);
            }),
            _buildDropdownFilterChip('Education', _selectedEducation, ['All', 'Undergraduate', 'Graduate', 'Doctorate'], (val) {
              setState(() => _selectedEducation = val);
            }),
            _buildFilterChip(
              child: Text(
                'More Filters',
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: AppTheme.darkCharcoal),
              ),
            ),
            _buildFilterChip(
              child: Row(
                children: [
                  const Icon(Icons.refresh, size: 12, color: Colors.red),
                  const SizedBox(width: 4),
                  Text(
                    'Reset',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedAge = '20 - 30';
                  _selectedLocation = 'All';
                  _selectedEducation = 'All';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({required Widget child, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAF6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: child,
      ),
    );
  }

  Widget _buildDropdownFilterChip(String label, String value, List<String> options, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAF6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
            ],
          ),
          const SizedBox(width: 4),
          PopupMenuButton<String>(
            icon: const Icon(Icons.keyboard_arrow_down, size: 12, color: AppTheme.secondaryGrey),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 100),
            itemBuilder: (context) => options.map((opt) => PopupMenuItem(value: opt, child: Text(opt, style: GoogleFonts.inter(fontSize: 11)))).toList(),
            onSelected: onChanged,
          ),
        ],
      ),
    );
  }

  // 5. DAILY PICKS SECTION
  Widget _buildDailyPicksSection() {
    final List<Map<String, dynamic>> dailyPicks = [
      {
        'name': 'Aisha Usman',
        'age': 22,
        'location': 'Ilorin, Kwara State',
        'job': 'Undergraduate - Biology',
        'status': 'Online',
        'compatibility': '92%',
        'img': _aishaPhoto,
      },
      {
        'name': 'Yusuf Ahmad',
        'age': 25,
        'location': 'Minna, Niger State',
        'job': 'B.Eng - Mechanical Eng.',
        'status': 'Online',
        'compatibility': '89%',
        'img': _yusufPhoto,
      },
      {
        'name': 'Fatima Bello',
        'age': 24,
        'location': 'Abuja, FCT',
        'job': 'Undergraduate - Law',
        'status': 'Recently Active',
        'compatibility': '87%',
        'img': _fatimaPhoto,
      },
      {
        'name': 'Ibrahim Musa',
        'age': 27,
        'location': 'Kano, Kano State',
        'job': 'B.Sc - Computer Science',
        'status': 'Online',
        'compatibility': '85%',
        'img': _ibrahimPhoto,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 20, right: 20, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Picks',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View all >',
                  style: GoogleFonts.inter(fontSize: 11, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 12),
          child: Text(
            'Handpicked matches based on your preferences',
            style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
          ),
        ),
        SizedBox(
          height: 255,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: dailyPicks.length,
            itemBuilder: (context, index) {
              final pick = dailyPicks[index];
              bool isOnline = pick['status'] == 'Online';
              return GestureDetector(
                onTap: () {
                  context.push('/match-detail', extra: pick);
                },
                child: Container(
                  width: 145,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Picture & Badges
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                            child: Image.network(
                              pick['img'],
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Status badge
                          Positioned(
                            left: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: isOnline ? const Color(0xFF10B981) : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    pick['status'],
                                    style: GoogleFonts.inter(fontSize: 7, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Favorite button
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Center(
                                child: Icon(Icons.favorite_border, size: 14, color: AppTheme.secondaryGrey),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Details
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${pick['name']}, ${pick['age']}',
                                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified, size: 12, color: Color(0xFF10B981)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              pick['location'],
                              style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.work_outline, size: 8, color: AppTheme.secondaryGrey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    pick['job'],
                                    style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Islamic tags
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check, size: 6, color: Color(0xFF2E7D32)),
                                      const SizedBox(width: 2),
                                      Text('Practicing', style: GoogleFonts.inter(fontSize: 6, color: const Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8EAF6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('Sunni', style: GoogleFonts.inter(fontSize: 6, color: const Color(0xFF1A237E), fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${pick['compatibility']} Compatible',
                              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 6. INCREASE YOUR CHANCES PROMO CARD
  Widget _buildIncreaseChancesCard() {
    final List<Map<String, dynamic>> actions = [
      {'title': 'Add More\nPhotos', 'percent': '+15%', 'icon': Icons.add_a_photo_outlined},
      {'title': 'Verify Your\nProfile', 'percent': '+30%', 'icon': Icons.verified_user_outlined},
      {'title': 'Add About\nYou', 'percent': '+10%', 'icon': Icons.edit_note_outlined},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Left content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Increase Your Chances',
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete your profile and get more matches that are right for you.',
                    style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey, height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  // Progress line
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile Completeness',
                              style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: const LinearProgressIndicator(
                                value: 0.92,
                                backgroundColor: Color(0xFFECEFF1),
                                color: AppTheme.primaryGreen,
                                minHeight: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '92%',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Right scrolling completion checks
            SizedBox(
              width: 140,
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: actions.length,
                      itemBuilder: (context, index) {
                        final act = actions[index];
                        return Container(
                          width: 60,
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAF6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(act['icon'], size: 14, color: AppTheme.primaryGreen),
                              const SizedBox(height: 3),
                              Text(
                                act['title'],
                                style: GoogleFonts.inter(fontSize: 6, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal, height: 1.1),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                act['percent'],
                                style: GoogleFonts.inter(fontSize: 6, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 14, color: AppTheme.secondaryGrey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 7. RECOMMENDED FOR YOU SECTION
  Widget _buildRecommendedSection() {
    final List<Map<String, dynamic>> recommended = [
      {
        'name': 'Maryam Abdullahi',
        'age': 23,
        'location': 'Lagos, State',
        'job': 'B.Sc - Biochemistry',
        'status': 'Online',
        'tags': ['Practicing Muslim', 'Sunni', "5'8\" • Average Build"],
        'compatibility': '91%',
        'img': _maryamPhoto,
      },
      {
        'name': 'Hassan Aliyu',
        'age': 26,
        'location': 'Kaduna, Kaduna State',
        'job': 'B.Eng - Civil Engineering',
        'status': 'Recently Active',
        'tags': ['Practicing Muslim', 'Sunni', "5'8\" • Athletic Build"],
        'compatibility': '88%',
        'img': _hassanPhoto,
      },
      {
        'name': 'Zainab Lawal',
        'age': 21,
        'location': 'Jos, Plateau State',
        'job': 'Undergraduate - Mass Comm.',
        'status': 'Online',
        'tags': ['Practicing Muslim', 'Sunni', "5'3\" • Slim Build"],
        'compatibility': '86%',
        'img': _zainabPhoto,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 20, right: 20, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended for You',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View all >',
                  style: GoogleFonts.inter(fontSize: 11, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 12),
          child: Text(
            'Members who match your values and preferences',
            style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: recommended.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final rec = recommended[index];
            bool isOnline = rec['status'] == 'Online';
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Photo
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          rec['img'],
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Small online status dot
                      Positioned(
                        left: 4,
                        bottom: 4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isOnline ? const Color(0xFF10B981) : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Middle Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${rec['name']}, ${rec['age']}',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, size: 12, color: Color(0xFF10B981)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rec['location'],
                          style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rec['job'],
                          style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Tags row
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: (rec['tags'] as List<String>).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAF6),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey[100]!),
                              ),
                              child: Text(
                                tag,
                                style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey, fontWeight: FontWeight.w500),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Right actions column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            rec['compatibility'],
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Compatible',
                            style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.bookmark_border_outlined, size: 16, color: AppTheme.secondaryGrey),
                        ],
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        onPressed: () {
                          context.push('/match-detail', extra: rec);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF042415),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          'View Profile',
                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // 8. TRUST IN ALLAH CARD
  Widget _buildTrustInAllahCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3E8FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD8B4FE).withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.menu_book, color: Color(0xFF7C3AED), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trust in Allah',
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF5B21B6)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '“And among His signs is that He created for you from yourselves spouses that you may find tranquility in them.” - Qur\'an 30:21',
                    style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF7C3AED), height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                minimumSize: Size.zero,
              ),
              child: Text(
                'Read More',
                style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
