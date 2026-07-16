import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';
import '../../authentication/presentation/auth_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final List<String> _recentSearches = [
    'Aisha Usman',
    'Doctor',
    'Teacher',
    'Islamic speaker',
    'Quran teacher',
  ];

  final List<Map<String, dynamic>> _suggestedMembers = [
    {
      'name': 'Amina Yusuf',
      'age': '24',
      'state': 'Ilorin',
      'status': 'Online',
      'img': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Abdul Rahman',
      'age': '26',
      'state': 'Minna',
      'status': 'Online',
      'img': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Maryam Bello',
      'age': '23',
      'state': 'Kaduna',
      'status': 'Online',
      'img': 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Hassan Aliyu',
      'age': '28',
      'state': 'Abuja',
      'status': 'Online',
      'img': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isVerified = authState.user?.status == 'Verified';

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkCharcoal,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  'Find people, topics and more',
                  style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.favorite, size: 10, color: AppTheme.primaryGreen),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: AppTheme.darkCharcoal, size: 18),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBox(),
                  const SizedBox(height: 20),
                  if (!isVerified) ...[
                    _buildLockedTierOverlay(),
                  ] else ...[
                    _buildRecentSearchesSection(),
                    const SizedBox(height: 24),
                    _buildPopularSearchesSection(),
                    const SizedBox(height: 28),
                    _buildSuggestedMembersSection(),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const CustomBottomNav(currentIndex: 0),
        ],
      ),
    );
  }

  Widget _buildLockedTierOverlay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
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
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F3FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_outline, color: Color(0xFF7C3AED), size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'Search requires Tier 1 Upgrade',
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete your advanced profile details, submit ID verification, and unlock searches of opposite-gender seekers.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600], height: 1.5),
          ),
          const SizedBox(height: 20),
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

  // 1. SEARCH TEXT FIELD BOX
  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAF6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppTheme.secondaryGrey, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: GoogleFonts.inter(fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Search by name, interest, profession...',
                hintStyle: TextStyle(color: AppTheme.secondaryGrey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. RECENT SEARCHES
  Widget _buildRecentSearchesSection() {
    if (_recentSearches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
            ),
            GestureDetector(
              onTap: () => setState(() => _recentSearches.clear()),
              child: Text(
                'Clear all',
                style: GoogleFonts.inter(fontSize: 10, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentSearches.map((search) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAF6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[100]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    search,
                    style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => setState(() => _recentSearches.remove(search)),
                    child: const Icon(Icons.close, size: 10, color: AppTheme.secondaryGrey),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // 3. POPULAR SEARCHES CATEGORIES
  Widget _buildPopularSearchesSection() {
    final List<Map<String, dynamic>> categories = [
      {'title': 'New Members', 'sub': 'Find new members', 'icon': Icons.group_outlined, 'color': const Color(0xFFE8F5E9), 'iconColor': const Color(0xFF2E7D32)},
      {'title': 'Serious Matches', 'sub': 'Looking for something real', 'icon': Icons.favorite_border, 'color': const Color(0xFFFFE4E6), 'iconColor': const Color(0xFF9F1239)},
      {'title': 'Profession', 'sub': 'Search by profession', 'icon': Icons.work_outline, 'color': const Color(0xFFE3F2FD), 'iconColor': const Color(0xFF0D47A1)},
      {'title': 'Education', 'sub': 'Search by education', 'icon': Icons.school_outlined, 'color': const Color(0xFFF3E8FF), 'iconColor': const Color(0xFF6B21A8)},
      {'title': 'Location', 'sub': 'Search by location', 'icon': Icons.location_on_outlined, 'color': const Color(0xFFFFF3E0), 'iconColor': const Color(0xFFE65100)},
      {'title': 'Interests', 'sub': 'Search by interests', 'icon': Icons.star_outline, 'color': const Color(0xFFE0F2F1), 'iconColor': const Color(0xFF004D40)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Searches',
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            for (int i = 0; i < categories.length; i += 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(child: _buildCategoryCard(categories[i])),
                    const SizedBox(width: 8),
                    if (i + 1 < categories.length)
                      Expanded(child: _buildCategoryCard(categories[i + 1]))
                    else
                      const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> cat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cat['color'],
              shape: BoxShape.circle,
            ),
            child: Icon(cat['icon'], size: 14, color: cat['iconColor']),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat['title'],
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
                const SizedBox(height: 2),
                Text(
                  cat['sub'],
                  style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 12, color: AppTheme.secondaryGrey),
        ],
      ),
    );
  }

  // 4. SUGGESTED MEMBERS
  Widget _buildSuggestedMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Suggested Members',
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View all',
                style: GoogleFonts.inter(fontSize: 10, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _suggestedMembers.length,
            itemBuilder: (context, index) {
              final member = _suggestedMembers[index];
              return Container(
                width: 110,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                          child: Image.network(
                            member['img'],
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Status dot
                        Positioned(
                          left: 6,
                          bottom: 6,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  member['name'],
                                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.verified, size: 8, color: Color(0xFF10B981)),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '${member['age']}, ${member['state']}',
                            style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            height: 22,
                            child: OutlinedButton(
                              onPressed: () {
                                context.push('/match-detail', extra: member);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                'View Profile >',
                                style: GoogleFonts.inter(fontSize: 7, fontWeight: FontWeight.bold, color: AppTheme.secondaryGrey),
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
