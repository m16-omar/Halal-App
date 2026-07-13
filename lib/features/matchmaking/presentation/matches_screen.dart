import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_theme.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  int _currentIndex = 1; // Matches tab selected
  int _selectedStatusFilter = 0;
  String _selectedAge = '18 - 30';
  String _selectedLocation = 'All';
  String _selectedEducation = 'All';
  String _selectedMadhab = 'All';
  int _currentPage = 1;

  // Mock candidates photos
  final String _aishaPhoto = 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&auto=format&fit=crop&q=80';
  final String _yusufPhoto = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&auto=format&fit=crop&q=80';
  final String _maryamPhoto = 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=300&auto=format&fit=crop&q=80';
  final String _abdullahiPhoto = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80';

  final List<Map<String, dynamic>> _mockCandidates = [
    {
      'name': 'Aisha Usman',
      'age': '22',
      'hijri': '15 Safar 1446 AH',
      'state': 'Ilorin, Kwara State',
      'job': 'Undergraduate – Biology',
      'madhab': 'Sunni',
      'practice': 'Practicing',
      'compatibility': '92%',
      'compatibilityVal': 0.92,
      'statusBadge': 'New',
      'statusBg': const Color(0xFF10B981),
      'height': '164 cm',
      'marital': 'Never Married',
      'specialTag': 'Niqabi',
      'specialTagBg': const Color(0xFFF3E5F5),
      'specialTagColor': const Color(0xFF6A1B9A),
      'img': 'aisha',
    },
    {
      'name': 'Yusuf Ahmad',
      'age': '28',
      'hijri': '10 Rabi\'ul Awwal 1446 AH',
      'state': 'Bida, Niger State',
      'job': 'Civil Engineer',
      'madhab': 'Sunni',
      'practice': 'Practicing',
      'compatibility': '89%',
      'compatibilityVal': 0.89,
      'statusBadge': 'New',
      'statusBg': const Color(0xFF10B981),
      'height': '175 cm',
      'marital': 'Never Married',
      'specialTag': 'Family Oriented',
      'specialTagBg': const Color(0xFFFFF3E0),
      'specialTagColor': const Color(0xFFE65100),
      'img': 'yusuf',
    },
    {
      'name': 'Maryam Ibrahim',
      'age': '23',
      'hijri': '2 Rabi\'ul Thani 1446 AH',
      'state': 'Minna, Niger State',
      'job': 'Undergraduate – Education',
      'madhab': 'Sunni',
      'practice': 'Practicing',
      'compatibility': '87%',
      'compatibilityVal': 0.87,
      'statusBadge': 'Recently Active',
      'statusBg': const Color(0xFF0D47A1),
      'height': '158 cm',
      'marital': 'Never Married',
      'specialTag': 'Loves Reading',
      'specialTagBg': const Color(0xFFE8EAF6),
      'specialTagColor': const Color(0xFF1A237E),
      'img': 'maryam',
    },
    {
      'name': 'Abdullahi Musa',
      'age': '25',
      'hijri': '20 Safar 1446 AH',
      'state': 'Abuja, FCT',
      'job': 'Graduate – Computer Science',
      'madhab': 'Sunni',
      'practice': 'Practicing',
      'compatibility': '85%',
      'compatibilityVal': 0.85,
      'statusBadge': 'Online',
      'statusBg': const Color(0xFF2E7D32),
      'height': '178 cm',
      'marital': 'Never Married',
      'specialTag': 'Fitness Lover',
      'specialTagBg': const Color(0xFFE0F2F1),
      'specialTagColor': const Color(0xFF004D40),
      'img': 'abdullahi',
    },
  ];

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
              _buildHeaderSection(),
              _buildMainFeedContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }

  // --- HEADER SECTION (Matches Header & Filter Pills) ---
  Widget _buildHeaderSection() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Discover compatible matches for a blessed marriage',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withAlpha(178),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search_outlined, color: Colors.white, size: 26),
                    onPressed: () {},
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.tune_outlined, color: Colors.white, size: 24),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFD4AF37), // Gold filter badge
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '2',
                            style: TextStyle(color: Color(0xFF04140C), fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatusFiltersRow(),
        ],
      ),
    );
  }

  // --- HORIZONTAL STATUS FILTERS ROW ---
  Widget _buildStatusFiltersRow() {
    final List<Map<String, dynamic>> filters = [
      {'label': 'All Matches', 'count': '128'},
      {'label': 'New This Week', 'count': '24'},
      {'label': 'Online Now', 'count': '18'},
      {'label': 'Recently Active', 'count': '36'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (index) {
          bool isSelected = _selectedStatusFilter == index;
          final filter = filters[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedStatusFilter = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E5631).withAlpha(51) : Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF10B981) : Colors.white24,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    filter['label'],
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF10B981) : Colors.white12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      filter['count'],
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // --- MAIN FEED BODY ---
  Widget _buildMainFeedContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildDropdownFiltersCard(),
          const SizedBox(height: 16),
          _buildIncreaseChancesCard(),
          const SizedBox(height: 20),
          _buildResultsHeader(),
          const SizedBox(height: 16),
          _buildCandidatesList(),
          const SizedBox(height: 20),
          _buildPaginationControls(),
          const SizedBox(height: 24),
          _buildTipsCard(),
        ],
      ),
    );
  }

  // --- DROPDOWN FILTERS CARD ---
  Widget _buildDropdownFiltersCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDropdownSelector('Age', _selectedAge, ['18 - 30', '31 - 40', '41+'])),
              const SizedBox(width: 8),
              Expanded(child: _buildDropdownSelector('Location', _selectedLocation, ['All', 'Niger', 'Kwara', 'Abuja'])),
              const SizedBox(width: 8),
              Expanded(child: _buildDropdownSelector('Education', _selectedEducation, ['All', 'Undergraduate', 'Graduate', 'Doctorate'])),
              const SizedBox(width: 8),
              Expanded(child: _buildDropdownSelector('Madhab', _selectedMadhab, ['All', 'Sunni', 'Maliki', 'Shafi\'i'])),
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
                const Icon(Icons.tune_outlined, size: 16, color: AppTheme.primaryGreen),
                const SizedBox(width: 6),
                Text(
                  'More Filters',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 16, color: AppTheme.primaryGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSelector(String label, String value, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 12, color: AppTheme.secondaryGrey),
            ],
          ),
        ],
      ),
    );
  }

  // --- INCREASE YOUR CHANCES PROMO CARD ---
  Widget _buildIncreaseChancesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white70,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.trending_up, color: Color(0xFF2E7D32), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Increase Your Chances',
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1B5E20)),
                ),
                const SizedBox(height: 2),
                Text(
                  'Complete your profile, verify your identity and add more photos.',
                  style: GoogleFonts.inter(fontSize: 9, color: AppTheme.darkCharcoal, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircularProgressIndicator(
                      value: 0.87,
                      strokeWidth: 3.5,
                      backgroundColor: Colors.white30,
                      color: Color(0xFF2E7D32),
                    ),
                    Text(
                      '87%',
                      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF1B5E20)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF042415),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(80, 26),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Improve Profile', style: GoogleFonts.inter(fontSize: 7, fontWeight: FontWeight.bold)),
                    const Icon(Icons.chevron_right, size: 8, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- RESULTS LIST HEADER ---
  Widget _buildResultsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '128 Matches Found',
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        Row(
          children: [
            Text(
              'Sort by: ',
              style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'Best Match',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 14, color: AppTheme.primaryGreen),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // View toggles
            const Icon(Icons.list, color: AppTheme.primaryGreen, size: 20),
            const SizedBox(width: 8),
            Icon(Icons.grid_view_outlined, color: AppTheme.secondaryGrey.withAlpha(128), size: 18),
          ],
        ),
      ],
    );
  }

  // --- CANDIDATES LIST VIEW ---
  Widget _buildCandidatesList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _mockCandidates.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final candidate = _mockCandidates[index];
        return _buildMatchCard(candidate);
      },
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> candidate) {
    String imageLink;
    switch (candidate['img']) {
      case 'aisha':
        imageLink = _aishaPhoto;
        break;
      case 'yusuf':
        imageLink = _yusufPhoto;
        break;
      case 'maryam':
        imageLink = _maryamPhoto;
        break;
      default:
        imageLink = _abdullahiPhoto;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Photo with overlays
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 100,
                  height: 120,
                  child: Image.network(
                    imageLink,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(color: Colors.grey[200]),
                  ),
                ),
              ),
              // Top Left status badge
              Positioned(
                left: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: candidate['statusBg'],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    candidate['statusBadge'],
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Top Right Heart
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(76),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, color: Colors.white, size: 12),
                ),
              ),
              // Bottom left verified badge on image
              Positioned(
                left: 6,
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(128),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check, color: Color(0xFF10B981), size: 8),
                      const SizedBox(width: 2),
                      Text(
                        'Verified',
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Middle Details Block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      candidate['name'],
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Color(0xFF10B981), size: 14),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${candidate['age']} years  •  ${candidate['hijri']}',
                  style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey),
                ),
                const SizedBox(height: 8),
                _buildCardDetailRow(Icons.location_on_outlined, candidate['state']),
                const SizedBox(height: 3),
                _buildCardDetailRow(Icons.school_outlined, candidate['job']),
                const SizedBox(height: 3),
                _buildCardDetailRow(Icons.brightness_3_outlined, '${candidate['madhab']}  •  ${candidate['practice']}'),
                const SizedBox(height: 8),
                // Tags Row
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _buildCapsuleTag(candidate['height'], const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
                    _buildCapsuleTag(candidate['marital'], const Color(0xFFFFEBEE), const Color(0xFFC62828)),
                    _buildCapsuleTag(candidate['specialTag'], candidate['specialTagBg'], candidate['specialTagColor']),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Right Actions block
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Compatibility Score
                  Container(
                    width: 38,
                    height: 38,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: candidate['compatibilityVal'],
                          strokeWidth: 2,
                          backgroundColor: Colors.transparent,
                          color: const Color(0xFF10B981),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              candidate['compatibility'],
                              style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                            ),
                            Text(
                              'Comp.',
                              style: GoogleFonts.inter(fontSize: 5, color: AppTheme.secondaryGrey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.more_vert, color: AppTheme.secondaryGrey, size: 18),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (candidate['name'] == 'Aisha Usman') {
                    context.push('/profile');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Profile for ${candidate['name']} is mocked. Directing to Aisha Usman\'s profile.', style: GoogleFonts.inter()),
                        action: SnackBarAction(
                          label: 'View',
                          onPressed: () => context.push('/profile'),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF042415),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(76, 28),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Text('View Profile', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 6),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.darkCharcoal,
                  side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                  minimumSize: const Size(76, 28),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite_border, size: 8, color: AppTheme.darkCharcoal),
                    const SizedBox(width: 3),
                    Text('Save', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 11, color: AppTheme.primaryGreen),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 9, color: AppTheme.darkCharcoal),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCapsuleTag(String label, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: textCol),
      ),
    );
  }

  // --- PAGINATION CONTROLS ---
  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.secondaryGrey),
          onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
        ),
        const SizedBox(width: 8),
        _buildPageNumber(1),
        const SizedBox(width: 8),
        _buildPageNumber(2),
        const SizedBox(width: 8),
        _buildPageNumber(3),
        const SizedBox(width: 8),
        Text('...', style: GoogleFonts.inter(color: AppTheme.secondaryGrey, fontSize: 12)),
        const SizedBox(width: 8),
        _buildPageNumber(9),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppTheme.secondaryGrey),
          onPressed: _currentPage < 9 ? () => setState(() => _currentPage++) : null,
        ),
      ],
    );
  }

  Widget _buildPageNumber(int page) {
    bool isActive = _currentPage == page;
    return GestureDetector(
      onTap: () => setState(() => _currentPage = page),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF042415) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$page',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.white : AppTheme.darkCharcoal,
            ),
          ),
        ),
      ),
    );
  }

  // --- TA'ARUF TIPS CARD ---
  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(8), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF042415),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_stories_outlined,
              color: AppTheme.accentGold,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips for a Successful Ta\'aruf',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTipSubItem(Icons.verified_outlined, 'Be sincere'),
                    _buildTipSubItem(Icons.people_outline, 'Involve Wali'),
                    _buildTipSubItem(Icons.chat_bubble_outline, 'Respect boundaries'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: AppTheme.secondaryGrey, size: 20),
        ],
      ),
    );
  }

  Widget _buildTipSubItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 10, color: AppTheme.primaryGreen),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
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
          _buildNavItem(Icons.favorite, 'Matches', 1), // Matches selected
          _buildWaliChatButton(),
          _buildNavItem(Icons.supervisor_account_outlined, 'Counseling', 2),
          _buildNavItem(Icons.person_outline, 'Profile', 3),
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
        } else if (index == 3) {
          context.push('/profile');
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
