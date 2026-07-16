import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';

class MatchDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? candidateData;

  const MatchDetailScreen({super.key, this.candidateData});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> with SingleTickerProviderStateMixin {
  late Map<String, dynamic> candidate;
  bool _isLiked = false;
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Profile',
    'Gallery',
    'Lifestyle',
    'Family',
    'Preferences',
    'Compatibility'
  ];

  @override
  void initState() {
    super.initState();
    candidate = widget.candidateData ?? {
      'name': 'Aisha Usman',
      'age': '37',
      'state': 'Niger State',
      'job': 'Teacher',
    };
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
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Seeker Profile',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.red : AppTheme.darkCharcoal,
            ),
            onPressed: () {
              setState(() {
                _isLiked = !_isLiked;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isLiked ? 'Added to favorites!' : 'Removed from favorites!'),
                  backgroundColor: AppTheme.primaryGreen,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppTheme.darkCharcoal),
            onPressed: () => _showMoreOptionsBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Horizontal Tab Bar
          _buildTabBar(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          // 2. Tab Views
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  _buildTabContent(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildStickyBottomBar(),
    );
  }

  // --- HORIZONTAL TAB BAR ---
  Widget _buildTabBar() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedTabIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: isSelected
                    ? const Border(
                        bottom: BorderSide(color: AppTheme.primaryGreen, width: 2),
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  children: [
                    _getTabIcon(index, isSelected),
                    const SizedBox(width: 6),
                    Text(
                      _tabs[index],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? AppTheme.primaryGreen : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getTabIcon(int index, bool isSelected) {
    final color = isSelected ? AppTheme.primaryGreen : Colors.grey[500];
    const size = 16.0;
    switch (index) {
      case 0:
        return Icon(Icons.person_outline, color: color, size: size);
      case 1:
        return Icon(Icons.image_outlined, color: color, size: size);
      case 2:
        return Icon(Icons.star_outline, color: color, size: size);
      case 3:
        return Icon(Icons.roofing_outlined, color: color, size: size);
      case 4:
        return Icon(Icons.tune_outlined, color: color, size: size);
      case 5:
        return Icon(Icons.handshake_outlined, color: color, size: size);
      default:
        return Icon(Icons.info_outline, color: color, size: size);
    }
  }

  // --- TAB ROUTING CONTENT ---
  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildProfileTabContent();
      case 1:
        return _buildGalleryTabContent();
      default:
        return _buildProfileTabContent();
    }
  }

  // --- TAB 1: PROFILE TAB CONTENT ---
  Widget _buildProfileTabContent() {
    return Column(
      children: [
        // Card 1: Verified & Trusted
        _buildVerifiedCard(),
        const SizedBox(height: 16),

        // Card 2: Personality & Interests Side-by-side
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildPersonalityCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildInterestsCard()),
          ],
        ),
        const SizedBox(height: 16),

        // Card 3: Family Background & Marriage Readiness
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildFamilyBackgroundCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildMarriageReadinessCard()),
          ],
        ),
        const SizedBox(height: 16),

        // Card 4: About My Ideal Spouse
        _buildAboutIdealSpouseCard(),
        const SizedBox(height: 16),

        // Card 5: Preferred Location (With Map of Nigeria)
        _buildPreferredLocationCard(),
        const SizedBox(height: 16),

        // Card 6: Surah Al-Furqan Quranic Quote Box
        _buildQuranQuoteCard(),
        const SizedBox(height: 16),

        // Card 7: Safety Tip
        _buildSafetyTipCard(),
      ],
    );
  }

  // --- 1. VERIFIED CARD ---
  Widget _buildVerifiedCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_user, color: Color(0xFF2E7D32), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verified & Trusted',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This profile has been verified to ensure a safe and trusted matchmaking experience.',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Verification Checklist
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckItem('Identity Verified'),
              _buildCheckItem('Phone Verified'),
              _buildCheckItem('NIN Verified'),
              _buildCheckItem('Profile Reviewed'),
              _buildCheckItem('Wali Verified'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 12),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 9, color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // --- 2. PERSONALITY CARD ---
  Widget _buildPersonalityCard() {
    final tags = ['Honest', 'Introverted', 'Clean', 'Patient', 'Calm', 'Respectful', 'God-fearing', 'Family-oriented'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_emotions_outlined, color: AppTheme.primaryGreen, size: 18),
              const SizedBox(width: 8),
              Text(
                'Personality',
                style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.map((t) => _buildTagChip(t)).toList(),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text('View More', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                const SizedBox(width: 2),
                const Icon(Icons.chevron_right, size: 12, color: AppTheme.primaryGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. INTERESTS CARD ---
  Widget _buildInterestsCard() {
    final tags = ['Reading', 'Qur\'an', 'Islamic Lectures', 'Teaching', 'Cooking', 'Travel', 'Gardening', 'Nasheed'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite_border, color: AppTheme.primaryGreen, size: 18),
              const SizedBox(width: 8),
              Text(
                'Interests',
                style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.map((t) => _buildTagChip(t)).toList(),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text('View More', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                const SizedBox(width: 2),
                const Icon(Icons.chevron_right, size: 12, color: AppTheme.primaryGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAF6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 9, color: Colors.grey[700], fontWeight: FontWeight.w500),
      ),
    );
  }

  // --- 4. FAMILY BACKGROUND CARD ---
  Widget _buildFamilyBackgroundCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_outline, color: AppTheme.primaryGreen, size: 18),
              const SizedBox(width: 8),
              Text(
                'Family Background',
                style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Family Type', 'Nuclear Family'),
          _buildDetailRow('Parents', 'Both Alive'),
          _buildDetailRow('Siblings', '3 (2 Sisters, 1 Bro)'),
          _buildDetailRow('Birth Order', '2nd'),
          _buildDetailRow('Guardian/Wali', 'Available'),
        ],
      ),
    );
  }

  // --- 5. MARRIAGE READINESS CARD ---
  Widget _buildMarriageReadinessCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.handshake_outlined, color: AppTheme.primaryGreen, size: 18),
              const SizedBox(width: 8),
              Text(
                'Marriage Readiness',
                style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Ready to Marry', 'Immediately'),
          _buildDetailRow('Willing to Reloc.', 'Yes'),
          _buildDetailRow('Open to LDR', 'Yes'),
          _buildDetailRow('Family Involv.', 'Yes'),
          _buildDetailRow('Visa/Passport', 'Available'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 9, color: Colors.grey[500])),
          Text(val, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal)),
        ],
      ),
    );
  }

  // --- 6. ABOUT MY IDEAL SPOUSE CARD ---
  Widget _buildAboutIdealSpouseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: AppTheme.secondaryGrey, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                'About My Ideal Spouse',
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'I seek a trustworthy, practicing Muslim who observes his prayers consistently and earns a halal livelihood. He should be responsible, caring toward his family, and committed to building a peaceful home based on Islamic values, mutual respect, and compassion.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- 7. PREFERRED LOCATION CARD ---
  Widget _buildPreferredLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: AppTheme.secondaryGrey, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Preferred Location',
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Abuja, Suleja, Kaduna, or Nasarawa.',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Stylized mini map image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: const Color(0xFFF0FDF4),
              height: 80,
              width: 100,
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.map_outlined, color: AppTheme.primaryGreen.withOpacity(0.15), size: 64),
                  ),
                  const Positioned(
                    top: 24,
                    left: 44,
                    child: Icon(Icons.location_on, color: AppTheme.primaryGreen, size: 14),
                  ),
                  const Positioned(
                    top: 48,
                    left: 28,
                    child: Icon(Icons.location_on, color: Color(0xFFD4AF37), size: 12),
                  ),
                  const Positioned(
                    top: 40,
                    left: 60,
                    child: Icon(Icons.location_on, color: AppTheme.primaryGreen, size: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 8. QURANIC QUOTE CARD ---
  Widget _buildQuranQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBF7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.format_quote, color: AppTheme.primaryGreen, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                    height: 1.8,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
                Text(
                  '“Our Lord! Grant us from among our spouses and offspring comfort to our eyes and make us leaders for the righteous.”',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[800],
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '– Surah Al-Furqan (25:74)',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: AppTheme.secondaryGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 9. SAFETY TIP CARD ---
  Widget _buildSafetyTipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAF6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppTheme.primaryGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Safety Tip: Always keep your conversations within the platform. Never send money or share personal contact details until you are comfortable.',
              style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[700], height: 1.4),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  // --- GALLERY TAB CONTENT ---
  Widget _buildGalleryTabContent() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&auto=format&fit=crop&q=80',
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  // --- STICKY BOTTOM ACTION BAR ---
  Widget _buildStickyBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Interest request sent!'),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.favorite, size: 18),
                label: Text(
                  'Express Interest',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push('/direct-chat', extra: candidate);
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: Text(
                  'Request Supervised Chat',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGreen,
                  side: const BorderSide(color: AppTheme.primaryGreen),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- BOTTOM SHEET OPTIONS ---
  void _showMoreOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.report_problem_outlined, color: Colors.red),
                title: Text('Report Seeker', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report submitted to admin.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: AppTheme.darkCharcoal),
                title: Text('Block Seeker', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Seeker blocked.'),
                      backgroundColor: AppTheme.darkCharcoal,
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
}
