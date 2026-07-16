import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../authentication/presentation/auth_provider.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  int _selectedHeroPage = 0;
  int _selectedCandidatePage = 0;
  final Set<String> _bookmarkedCandidates = {};

  // Mock profile images
  final String _abdullahiAvatar = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80';
  final String _aishaPhoto = 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&auto=format&fit=crop&q=80';
  final String _yusufPhoto = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&auto=format&fit=crop&q=80';
  final String _maryamPhoto = 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=300&auto=format&fit=crop&q=80';

  // Tips & Articles images
  final String _quranImg = 'https://images.unsplash.com/photo-1609599006353-e629fffaae6f?w=100&auto=format&fit=crop&q=80';
  final String _ringsImg = 'https://images.unsplash.com/photo-1469371670807-013ccf25f16a?w=100&auto=format&fit=crop&q=80';
  final String _prayImg = 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=100&auto=format&fit=crop&q=80';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final userName = user?.fullName.split(' ').first ?? 'Seeker';

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
              _buildHeaderSection(user, userName),
              _buildMainDashboardContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }

  // --- HEADER SECTION (Dark Forest Green Gradient) ---
  Widget _buildHeaderSection(SeekerUser? user, String userName) {
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
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Profile info
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.softCream,
                    backgroundImage: NetworkImage(_abdullahiAvatar),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assalamu alaikum,',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.softCream.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        userName,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.softCream,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Verified/Pending/Unverified Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: ((user?.status == 'Verified'
                              ? const Color(0xFF10B981)
                              : user?.status == 'Pending'
                                  ? const Color(0xFFD4AF37)
                                  : const Color(0xFF9E9E9E))).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: user?.status == 'Verified'
                                ? const Color(0xFF10B981)
                                : user?.status == 'Pending'
                                    ? const Color(0xFFD4AF37)
                                    : const Color(0xFF9E9E9E),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user?.status == 'Verified'
                                  ? Icons.check
                                  : user?.status == 'Pending'
                                      ? Icons.hourglass_empty
                                      : Icons.warning_amber_rounded,
                              color: user?.status == 'Verified'
                                  ? const Color(0xFF10B981)
                                  : user?.status == 'Pending'
                                      ? const Color(0xFFD4AF37)
                                      : const Color(0xFF9E9E9E),
                              size: 10,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              user?.status ?? 'Unverified',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: user?.status == 'Verified'
                                    ? const Color(0xFF10B981)
                                    : user?.status == 'Pending'
                                        ? const Color(0xFFD4AF37)
                                        : const Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Header Actions
              Row(
                children: [
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined, color: AppTheme.softCream, size: 26),
                        onPressed: () => context.push('/notifications'),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.softCream, size: 24),
                    onPressed: () => context.push('/messages'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_outlined, color: AppTheme.softCream, size: 26),
                    onPressed: () => context.push('/search'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildHeroCard(),
        ],
      ),
    );
  }

  // --- HERO CARD (Islamic Design + Quranic Quote) ---
  Widget _buildHeroCard() {
    final List<Map<String, String>> slides = [
      {
        'header': 'Finding a spouse is',
        'subheader': 'half of your Deen.',
        'body': '“And among His signs is that He created for you from yourselves spouses that you may find tranquility in them.”',
        'author': '– Qur\'an 30:21',
      },
      {
        'header': 'Our Lord, grant us',
        'subheader': 'comfort in our spouses',
        'body': '“Our Lord, grant us from among our wives and offspring comfort to our eyes and make us an example for the righteous.”',
        'author': '– Qur\'an 25:74',
      },
      {
        'header': 'The most perfect',
        'subheader': 'believer in faith',
        'body': '“The most perfect believer in faith is the one who is best in moral character, and the best of you are those who are best to their wives.”',
        'author': '– Jami\' at-Tirmidhi (1162)',
      },
      {
        'header': 'They are a garment',
        'subheader': 'for you & you for them',
        'body': '“They are a garment for you and you are a garment for them.”',
        'author': '– Qur\'an 2:187',
      },
    ];

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0C2B1B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            PageView.builder(
              itemCount: slides.length,
              onPageChanged: (page) {
                setState(() {
                  _selectedHeroPage = page;
                });
              },
              itemBuilder: (context, slideIndex) {
                final slide = slides[slideIndex];
                return Stack(
                  children: [
                    // Arch silhouette Sunset Drawing on the right
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 160,
                      child: CustomPaint(
                        painter: MosqueArchPainter(),
                      ),
                    ),
                    
                    // Quran book and lantern overlay
                    Positioned(
                      right: 12,
                      bottom: 8,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(Icons.menu_book_outlined, size: 48, color: AppTheme.accentGold.withOpacity(0.85)),
                          const SizedBox(width: 8),
                          Icon(Icons.light_mode_outlined, size: 36, color: AppTheme.accentGold.withOpacity(0.7)),
                        ],
                      ),
                    ),

                    // Left Quote Content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slide['header']!,
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.softCream,
                                ),
                              ),
                              Text(
                                slide['subheader']!,
                                style: GoogleFonts.amiri(
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              slide['body']!,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: AppTheme.softCream.withOpacity(0.8),
                                height: 1.4,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                slide['author']!,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGold,
                                ),
                              ),
                              // Spacer for dots
                              const SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            // Floating Indicator Dots overlay
            Positioned(
              right: 16,
              bottom: 16,
              child: Row(
                children: List.generate(slides.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _selectedHeroPage
                          ? AppTheme.accentGold
                          : AppTheme.softCream.withOpacity(0.3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- MAIN DASHBOARD CONTENT (White Scrollable Body) ---
  Widget _buildMainDashboardContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickNavigation(),
          const SizedBox(height: 24),
          _buildStatsRow(),
          const SizedBox(height: 24),
          _buildRecommendedSection(),
          const SizedBox(height: 24),
          _buildDailyReminderCard(),
          const SizedBox(height: 24),
          _buildUpcomingAppointments(),
          const SizedBox(height: 24),
          _buildTipsAndCommunityGrid(),
        ],
      ),
    );
  }

  // --- QUICK NAVIGATION MENU ---
  Widget _buildQuickNavigation() {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Find Matches',
        'subtitle': 'Discover compatible profiles',
        'icon': Icons.person_search_outlined,
        'bg': const Color(0xFFE8F5E9),
        'color': const Color(0xFF2E7D32),
        'route': '/matches',
      },
      {
        'title': 'Interest Requests',
        'subtitle': 'View & respond to requests',
        'icon': Icons.favorite_outline,
        'bg': const Color(0xFFFFEBEE),
        'color': const Color(0xFFC62828),
        'route': '/interest-requests',
      },
      {
        'title': 'My Wali',
        'subtitle': 'Manage guardian access',
        'icon': Icons.people_outline,
        'bg': const Color(0xFFF3E5F5),
        'color': const Color(0xFF6A1B9A),
        'route': '/wali-chat',
      },
      {
        'title': 'Imam Connect',
        'subtitle': 'Chat with local imams',
        'icon': Icons.mosque_outlined,
        'bg': const Color(0xFFE3F2FD),
        'color': const Color(0xFF1565C0),
        'route': '/counseling',
      },
      {
        'title': 'Meetings',
        'subtitle': 'Manage your meetings',
        'icon': Icons.calendar_month_outlined,
        'bg': const Color(0xFFFFF3E0),
        'color': const Color(0xFFEF6C00),
        'route': '/propose-meeting',
      },
      {
        'title': 'Resources',
        'subtitle': 'Learn & grow in Deen',
        'icon': Icons.menu_book_outlined,
        'bg': const Color(0xFFE0F2F1),
        'color': const Color(0xFF00695C),
        'route': '/counseling',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: menuItems.map((item) {
            return GestureDetector(
              onTap: () {
                final route = item['route'] as String;
                if (route == '/matches' || route == '/wali-chat' || route == '/counseling') {
                  context.go(route);
                } else {
                  context.push(route);
                }
              },
              child: Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: item['bg'],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'], color: item['color'], size: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'],
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.darkCharcoal),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['subtitle'],
                      style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // --- STATS ROW ---
  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF04140C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Stat 1
          Expanded(child: _buildStatColumn(
            icon: Icons.people,
            iconBg: const Color(0xFF1E5631).withOpacity(0.2),
            iconColor: const Color(0xFF10B981),
            value: '128',
            label: 'Matches',
            subLabel: 'New this week',
            badgeText: '+12',
            badgeBg: const Color(0xFF1E5631),
          )),
          _buildDivider(),
          // Stat 2
          Expanded(child: _buildStatColumn(
            icon: Icons.favorite,
            iconBg: Colors.red.withOpacity(0.15),
            iconColor: Colors.redAccent,
            value: '18',
            label: 'Interest Requests',
            subLabel: 'Pending',
            badgeText: '+5',
            badgeBg: Colors.redAccent,
          )),
          _buildDivider(),
          // Stat 3
          Expanded(child: _buildStatColumn(
            icon: Icons.verified_user,
            iconBg: Colors.amber.withOpacity(0.15),
            iconColor: AppTheme.accentGold,
            value: '92%',
            label: 'Profile Strength',
            subLabel: 'Excellent',
            showProgress: true,
          )),
          _buildDivider(),
          // Stat 4
          Expanded(child: _buildStatColumn(
            icon: Icons.stars,
            iconBg: Colors.blue.withOpacity(0.15),
            iconColor: Colors.blueAccent,
            value: 'Premium',
            label: 'Active',
            subLabel: 'Until 21 Aug, 2026',
            textColor: Colors.blueAccent,
          )),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 48,
      width: 1,
      color: Colors.white24,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildStatColumn({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String value,
    required String label,
    required String subLabel,
    String? badgeText,
    Color? badgeBg,
    bool showProgress = false,
    Color? textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 14),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textColor ?? Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 9, color: Colors.white70, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          subLabel,
          style: GoogleFonts.inter(fontSize: 7, color: Colors.white38),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showProgress) ...[
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: const LinearProgressIndicator(
              value: 0.92,
              backgroundColor: Colors.white12,
              color: AppTheme.accentGold,
              minHeight: 3,
            ),
          ),
        ],
        if (badgeText != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badgeText,
              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ],
    );
  }

  // --- RECOMMENDED FOR YOU ---
  Widget _buildRecommendedSection() {
    final authState = ref.read(authProvider);
    final isVerified = authState.user?.status == 'Verified';

    if (!isVerified) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.accentGold.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F3FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline, color: Color(0xFF7C3AED), size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Unlock Tier 1 Matchmaking',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your advanced profile details, submit ID verification, and upgrade to see latest seekers of the opposite gender.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => context.push('/premium-upgrade'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Complete Profile & Pay to Unlock',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    final List<Map<String, dynamic>> candidates = [
      {
        'name': 'Aisha',
        'age': '24',
        'state': 'Minna, Niger State',
        'job': 'Teacher',
        'tags': ['Practicing', 'Niqabi', 'Kind'],
        'img': _aishaPhoto,
      },
      {
        'name': 'Yusuf',
        'age': '28',
        'state': 'Bida, Niger State',
        'job': 'Civil Engineer',
        'tags': ['Practicing', 'Sunni', 'Family Oriented'],
        'img': _yusufPhoto,
      },
      {
        'name': 'Maryam',
        'age': '22',
        'state': 'Ilorin, Kwara State',
        'job': 'Student',
        'tags': ['Practicing', 'Hijabi', 'Easygoing'],
        'img': _maryamPhoto,
      },
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended For You',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'See all',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                  ),
                  const Icon(Icons.chevron_right, color: AppTheme.primaryGreen, size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: candidates.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final candidate = candidates[index];
              return _buildCandidateCard(candidate);
            },
          ),
        ),
        const SizedBox(height: 12),
        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == _selectedCandidatePage
                    ? AppTheme.primaryGreen
                    : Colors.black12,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCandidateCard(Map<String, dynamic> candidate) {
    return GestureDetector(
      onTap: () {
        context.push('/match-detail', extra: candidate);
      },
      child: Container(
        width: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: Image.network(
                candidate['img'],
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.grey[200]),
              ),
            ),
            // Background Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            // Top Left New Badge
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'New',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Top Right Bookmark
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: () {
                  final candidateName = candidate['name'] as String;
                  setState(() {
                    if (_bookmarkedCandidates.contains(candidateName)) {
                      _bookmarkedCandidates.remove(candidateName);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$candidateName removed from saved profiles'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    } else {
                      _bookmarkedCandidates.add(candidateName);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$candidateName added to saved profiles!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _bookmarkedCandidates.contains(candidate['name'])
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: _bookmarkedCandidates.contains(candidate['name'])
                        ? AppTheme.accentGold
                        : Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            // Bottom Info Column
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${candidate['name']}, ${candidate['age']}',
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Color(0xFF10B981), size: 14),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.white70, size: 10),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          candidate['state'],
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 9),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.work_outline, color: Colors.white70, size: 10),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          candidate['job'],
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 9),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: (candidate['tags'] as List<String>).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(color: Colors.white, fontSize: 8),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // --- DAILY ISLAMIC REMINDER ---
  Widget _buildDailyReminderCard() {
    return GestureDetector(
      onTap: () {
        context.push('/daily-reminder');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8F5E9), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular mosque outline badge
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF042415),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mosque_outlined,
                color: AppTheme.accentGold,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Islamic Reminder',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E5631),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lower your gaze, guard your heart, and let Allah choose what is best for you.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.darkCharcoal,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '– Surah An-Nur (24:30)',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: AppTheme.secondaryGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppTheme.secondaryGrey, size: 24),
          ],
        ),
      ),
    );
  }

  // --- UPCOMING APPOINTMENTS ---
  Widget _buildUpcomingAppointments() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Appointments',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'View all',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                  ),
                  const Icon(Icons.chevron_right, color: AppTheme.primaryGreen, size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Appointment 1
            Expanded(
              child: _buildAppointmentCard(
                title: 'Meeting with Wali',
                subtitle: 'With Aisha\'s Wali',
                time: '11:00 AM – 12:00 PM',
                dateDay: '15',
                dateMonth: 'JUL',
                badgeText: 'Confirmed',
                badgeBg: const Color(0xFFE8F5E9),
                badgeTextColor: const Color(0xFF2E7D32),
                dateBg: const Color(0xFFE8F5E9),
                dateTextColor: const Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(width: 16),
            // Appointment 2
            Expanded(
              child: _buildAppointmentCard(
                title: 'Pre-Marital Counseling',
                subtitle: 'With Imam Usman',
                time: '04:00 PM – 05:00 PM',
                dateDay: '17',
                dateMonth: 'JUL',
                badgeText: 'Upcoming',
                badgeBg: const Color(0xFFF3E5F5),
                badgeTextColor: const Color(0xFF6A1B9A),
                dateBg: const Color(0xFFF3E5F5),
                dateTextColor: const Color(0xFF6A1B9A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppointmentCard({
    required String title,
    required String subtitle,
    required String time,
    required String dateDay,
    required String dateMonth,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
    required Color dateBg,
    required Color dateTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.04), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Date Badge
              Container(
                width: 42,
                height: 48,
                decoration: BoxDecoration(
                  color: dateBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dateDay,
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: dateTextColor),
                    ),
                    Text(
                      dateMonth,
                      style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: dateTextColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Appointment text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 12, color: AppTheme.secondaryGrey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  time,
                  style: GoogleFonts.inter(fontSize: 9, color: AppTheme.secondaryGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badgeText,
              style: GoogleFonts.inter(fontSize: 9, color: badgeTextColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- DOUBLE COLUMNS: TIPS & ARTICLES VS COMMUNITY POSTS ---
  Widget _buildTipsAndCommunityGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column 1: Tips & Articles
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tips & Articles',
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  ),
                  Text(
                    'See all',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildArticleCard(
                title: '10 Qualities of a Righteous Spouse',
                time: 'Read time • 4 min',
                img: _quranImg,
              ),
              const SizedBox(height: 12),
              _buildArticleCard(
                title: 'Preparing Yourself for Marriage',
                time: 'Read time • 6 min',
                img: _ringsImg,
              ),
              const SizedBox(height: 12),
              _buildArticleCard(
                title: 'Dua for a Good Spouse',
                time: 'Read time • 3 min',
                img: _prayImg,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Column 2: Community Posts
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Community Posts',
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  ),
                  Text(
                    'See all',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCommunityCard(
                user: 'Masjid Central Minna',
                time: '2h ago',
                text: 'Jumu\'ah reminder: Marriage is Sunnah. Build your home on Imaan.',
                likes: '42',
                avatarBg: const Color(0xFFE8F5E9),
                avatarIcon: Icons.mosque_outlined,
              ),
              const SizedBox(height: 12),
              _buildCommunityCard(
                user: 'Imam Usman',
                time: '6h ago',
                text: 'A beautiful reminder on patience in seeking a righteous spouse.',
                likes: '35',
                avatarBg: const Color(0xFFFFF3E0),
                avatarIcon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              _buildCommunityCard(
                user: 'Nupe Sisters Circle',
                time: '1d ago',
                text: 'New sisters halaqah this Saturday. All are welcome!',
                likes: '28',
                avatarBg: const Color(0xFFF3E5F5),
                avatarIcon: Icons.group_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArticleCard({
    required String title,
    required String time,
    required String img,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.02), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Image.network(
                img,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.grey[200]),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                    ),
                    const Icon(Icons.bookmark_border, size: 12, color: AppTheme.secondaryGrey),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard({
    required String user,
    required String time,
    required String text,
    required String likes,
    required Color avatarBg,
    required IconData avatarIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.02), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: avatarBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(avatarIcon, size: 12, color: AppTheme.primaryGreen),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user,
                      style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      time,
                      style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: GoogleFonts.inter(fontSize: 9, color: AppTheme.darkCharcoal, height: 1.3),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.favorite_border, size: 10, color: AppTheme.secondaryGrey),
              const SizedBox(width: 2),
              Text(
                likes,
                style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- CUSTOM BOTTOM NAVIGATION BAR ---
  Widget _buildCustomBottomNav() {
    return const CustomBottomNav(currentIndex: 0);
  }
}

// --- CUSTOM PAINTER: ISLAMIC ARCH BACKGROUND ---
class MosqueArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw sunset gradient background inside the arch path bounds
    final Paint backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE2A154),
          Color(0xFF884325),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Define the Islamic Pointed (Ogee) Arch path
    final Path archPath = Path();
    archPath.moveTo(size.width * 0.15, size.height);
    archPath.lineTo(size.width * 0.15, size.height * 0.4);
    
    // Draw left ogee curve
    archPath.cubicTo(
      size.width * 0.15, size.height * 0.25,
      size.width * 0.35, size.height * 0.15,
      size.width * 0.5, size.height * 0.05,
    );
    
    // Draw right ogee curve
    archPath.cubicTo(
      size.width * 0.65, size.height * 0.15,
      size.width * 0.85, size.height * 0.25,
      size.width * 0.85, size.height * 0.4,
    );
    
    archPath.lineTo(size.width * 0.85, size.height);
    archPath.close();

    // Clip to the arch path and draw the sunset background
    canvas.save();
    canvas.clipPath(archPath);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // 2. Draw Mosque Silhouette inside the arch
    final Paint mosquePaint = Paint()
      ..color = const Color(0xFF04140C).withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final Path mosquePath = Path();
    // Start base
    mosquePath.moveTo(size.width * 0.15, size.height);
    
    // Minaret Left
    mosquePath.lineTo(size.width * 0.25, size.height);
    mosquePath.lineTo(size.width * 0.25, size.height * 0.45);
    mosquePath.lineTo(size.width * 0.23, size.height * 0.45);
    mosquePath.lineTo(size.width * 0.25, size.height * 0.35); // Pointy tip
    mosquePath.lineTo(size.width * 0.27, size.height * 0.45);
    mosquePath.lineTo(size.width * 0.25, size.height * 0.45);
    mosquePath.lineTo(size.width * 0.25, size.height);

    // Mosque Base building
    mosquePath.lineTo(size.width * 0.35, size.height);
    mosquePath.lineTo(size.width * 0.35, size.height * 0.65);
    
    // Left small dome
    mosquePath.arcToPoint(
      Offset(size.width * 0.43, size.height * 0.65),
      radius: const Radius.circular(8),
      clockwise: true,
    );
    mosquePath.lineTo(size.width * 0.43, size.height * 0.60);
    
    // Center Large Dome
    mosquePath.arcToPoint(
      Offset(size.width * 0.57, size.height * 0.60),
      radius: const Radius.circular(16),
      clockwise: true,
    );
    mosquePath.lineTo(size.width * 0.57, size.height * 0.65);
    
    // Right small dome
    mosquePath.arcToPoint(
      Offset(size.width * 0.65, size.height * 0.65),
      radius: const Radius.circular(8),
      clockwise: true,
    );
    mosquePath.lineTo(size.width * 0.65, size.height);

    // Minaret Right
    mosquePath.lineTo(size.width * 0.75, size.height);
    mosquePath.lineTo(size.width * 0.75, size.height * 0.45);
    mosquePath.lineTo(size.width * 0.73, size.height * 0.45);
    mosquePath.lineTo(size.width * 0.75, size.height * 0.35); // Pointy tip
    mosquePath.lineTo(size.width * 0.77, size.height * 0.45);
    mosquePath.lineTo(size.width * 0.75, size.height * 0.45);
    mosquePath.lineTo(size.width * 0.75, size.height);
    
    mosquePath.close();
    canvas.drawPath(mosquePath, mosquePaint);
    canvas.restore();

    // 3. Draw Golden Arch Border
    final Paint borderPaint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawPath(archPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
