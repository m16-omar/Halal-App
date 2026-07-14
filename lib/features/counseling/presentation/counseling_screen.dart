import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class CounselingScreen extends ConsumerStatefulWidget {
  const CounselingScreen({super.key});

  @override
  ConsumerState<CounselingScreen> createState() => _CounselingScreenState();
}

class _CounselingScreenState extends ConsumerState<CounselingScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSearchAndFilter(),
                            _buildVerseBanner(),
                            _buildGetGuidanceSection(),
                            _buildScheduleBanner(),
                            _buildRecommendedSection(),
                            _buildMakeDuaCard(),
                            _buildUpcomingSessionsSection(),
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
      color: const Color(0xFF042415),
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Counseling',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Guidance for a blessed marriage',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              // Notification Bell
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {},
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
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              // Appointments button
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Color(0xFF042415),
                ),
                label: Text(
                  'Appointments',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF042415),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9FAF6),
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SEARCH AND FILTER ---
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search topics, articles, videos...',
            hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.search, color: AppTheme.secondaryGrey),
            suffixIcon: IconButton(
              icon: const Icon(Icons.tune, color: AppTheme.primaryGreen),
              onPressed: () {},
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
          ),
        ),
      ),
    );
  }

  // --- ARABIC VERSE BANNER ---
  Widget _buildVerseBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC8E6C9), width: 0.5),
        ),
        child: Row(
          children: [
            // Left lantern/book graphic
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 40,
                      color: const Color(0xFFD4AF37).withOpacity(0.8),
                    ),
                    const Icon(
                      Icons.menu_book,
                      size: 28,
                      color: Color(0xFF2E7D32),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Ayah of the Day',
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Right Quran Verse text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"And among His signs is that He created for you from yourselves spouses that you may find tranquility in them."',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B5E20),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '— Qur\'an 30:21',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF558B2F),
                        ),
                      ),
                      // Carousel Indicator dots
                      Row(
                        children: List.generate(5, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: index == 0 ? 10 : 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? const Color(0xFF2E7D32)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- GET GUIDANCE SECTION ---
  Widget _buildGetGuidanceSection() {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Articles',
        'sub': 'Islamic insights\n& advice',
        'icon': Icons.menu_book_outlined,
      },
      {
        'title': 'Video Lessons',
        'sub': 'Learn from\nscholars',
        'icon': Icons.play_circle_outline,
      },
      {
        'title': 'Audio Talks',
        'sub': 'Listen to\nreminders',
        'icon': Icons.headset_outlined,
      },
      {
        'title': 'Ask a Scholar',
        'sub': 'Get answers to\nyour questions',
        'icon': Icons.chat_bubble_outline,
      },
      {
        'title': 'Pre-Marital Guidance',
        'sub': 'Prepare for a\nblessed home',
        'icon': Icons.people_outline,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 24.0,
            left: 20,
            right: 20,
            bottom: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Get Guidance',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCharcoal,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View all >',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Container(
                width: 115,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withOpacity(0.04)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cat['icon'], color: AppTheme.primaryGreen, size: 24),
                    const SizedBox(height: 6),
                    Text(
                      cat['title'],
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkCharcoal,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cat['sub'],
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        color: AppTheme.secondaryGrey,
                      ),
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

  // --- SCHEDULE BANNER ---
  Widget _buildScheduleBanner() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F8F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFB2DFDB).withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Schedule Counseling Session',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Book a one-on-one or couple session with a verified counselor or Imam.',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppTheme.darkCharcoal.withOpacity(0.7),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF042415),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Book a Session',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 8,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Mock illustration image
            Expanded(
              flex: 2,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.face, size: 40, color: Colors.grey[300]),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Icon(
                          Icons.chat_bubble,
                          size: 18,
                          color: AppTheme.accentGold.withOpacity(0.8),
                        ),
                      ),
                      const Icon(
                        Icons.supervisor_account,
                        size: 30,
                        color: AppTheme.primaryGreen,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- RECOMMENDED SECTION ---
  Widget _buildRecommendedSection() {
    final List<Map<String, String>> resources = [
      {
        'title': 'Building a Strong Islamic Marriage',
        'sub':
            'Key principles every couple should know before and after marriage.',
        'tag': 'Video',
        'duration': '12:45',
        'type': 'video',
      },
      {
        'title': 'Rights and Responsibilities in Marriage',
        'sub': 'A balanced understanding from the Qur\'an and Sunnah.',
        'tag': 'Article',
        'duration': '08:32',
        'type': 'article',
      },
      {
        'title': 'Communication in Marriage',
        'sub': 'How to communicate with love, respect and understanding.',
        'tag': 'Audio',
        'duration': '10:15',
        'type': 'audio',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended for You',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCharcoal,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View all >',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: resources.length,
          itemBuilder: (context, index) {
            final res = resources[index];
            IconData tagIcon = Icons.play_circle_outline;
            Color tagColor = const Color(0xFF673AB7);
            if (res['type'] == 'article') {
              tagIcon = Icons.description_outlined;
              tagColor = const Color(0xFF2E7D32);
            } else if (res['type'] == 'audio') {
              tagIcon = Icons.headset_outlined;
              tagColor = const Color(0xFFEF6C00);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withOpacity(0.03)),
              ),
              child: Row(
                children: [
                  // Video Thumbnail Card
                  Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(tagIcon, color: tagColor, size: 24),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            res['duration']!,
                            style: GoogleFonts.inter(
                              fontSize: 7,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Middle info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          res['title']!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkCharcoal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          res['sub']!,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppTheme.secondaryGrey,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(tagIcon, size: 8, color: tagColor),
                              const SizedBox(width: 4),
                              Text(
                                res['tag']!,
                                style: GoogleFonts.inter(
                                  fontSize: 8,
                                  color: tagColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Bookmark action
                  IconButton(
                    icon: const Icon(
                      Icons.bookmark_border_outlined,
                      color: AppTheme.secondaryGrey,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // --- MAKE DU'A CARD ---
  Widget _buildMakeDuaCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
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
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volunteer_activism_outlined,
                color: Color(0xFF7C3AED),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Make Du\'a',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5B21B6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Ask Allah to bless your efforts and guide you to the best spouse.',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF7C3AED),
                      height: 1.3,
                    ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
              ),
              child: Row(
                children: [
                  Text(
                    'View Du\'as',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 8,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UPCOMING SESSIONS SECTION ---
  Widget _buildUpcomingSessionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Sessions',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCharcoal,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View all >',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.04)),
            ),
            child: Row(
              children: [
                // Circular portrait of Imam Abdullahi
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[200],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Center info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Session with Imam Abdullahi',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkCharcoal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2E7D32),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Online',
                                  style: GoogleFonts.inter(
                                    fontSize: 7,
                                    color: const Color(0xFF2E7D32),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Topic: Preparing for a Blessed Marriage',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppTheme.secondaryGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 10,
                            color: AppTheme.primaryGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Sat, 17 May 2026',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: AppTheme.darkCharcoal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.access_time,
                            size: 10,
                            color: AppTheme.primaryGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '04:00 PM WAT',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: AppTheme.darkCharcoal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Join Session Action Button
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.videocam_outlined,
                    size: 12,
                    color: Color(0xFF042415),
                  ),
                  label: Text(
                    'Join Session',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF042415),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF042415), width: 1),
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- CUSTOM BOTTOM NAVIGATION BAR ---
  Widget _buildCustomBottomNav() {
    return const CustomBottomNav(currentIndex: 3);
  }
}
