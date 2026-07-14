import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class MatchDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? candidateData;

  const MatchDetailScreen({super.key, this.candidateData});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  late Map<String, dynamic> candidate;
  bool _isLiked = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Default to Aisha Usman if no dynamic data is passed
    candidate = widget.candidateData ?? {
      'name': 'Aisha Usman',
      'age': '22',
      'state': 'Ilorin, Kwara State',
      'dob': '15 Safar 1446 AH',
      'nationality': 'Nigerian',
      'ethnicity': 'Hausa',
      'language': 'Hausa, English',
      'education': 'Undergraduate',
      'educationDetail': 'Undergraduate – Biology',
      'university': 'University of Ilorin',
      'profession': 'Student',
      'compatibility': '92%',
      'quote': 'I believe in building a marriage that is based on faith, love, respect and good communication.',
      'about': "I'm a simple, God-fearing and family-oriented person. I enjoy learning new things, reading and spending quality time with loved ones.",
      'religiosity': 'Very Religious',
      'diet': 'Halal',
      'prayer': '5 times a day',
      'eduImportance': 'Very Important',
      'hijab': 'Always',
      'children': 'Insha Allah',
      'smoke': 'No',
      'islamicValues': 'Very Important',
      'familyType': 'Nuclear',
      'fatherJob': 'Business',
      'motherJob': 'Teacher',
      'siblings': '3 (2 Sisters, 1 Brother)',
      'status': 'Online',
      'img': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF6),
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
            Row(
              children: [
                Text(
                  candidate['name'] ?? 'Aisha Usman',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.verified, size: 14, color: Color(0xFF10B981)),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  '${candidate['age'] ?? '22'} years • ${candidate['state'] ?? 'Ilorin, Kwara State'}',
                  style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
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
                      const SizedBox(width: 3),
                      Text(
                        candidate['status'] ?? 'Online',
                        style: GoogleFonts.inter(
                          fontSize: 6,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: IconButton(
              icon: const Icon(Icons.ios_share, color: AppTheme.darkCharcoal, size: 18),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: IconButton(
              icon: const Icon(Icons.more_horiz, color: AppTheme.darkCharcoal, size: 18),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCoverSection(),
                  const SizedBox(height: 16),
                  _buildActionButtonsRow(),
                  const SizedBox(height: 20),
                  _buildAboutAndCompatibilityRow(),
                  const SizedBox(height: 24),
                  _buildBasicInformationSection(),
                  const SizedBox(height: 24),
                  _buildLifestyleValuesSection(),
                  const SizedBox(height: 24),
                  _buildFamilyBackgroundSection(),
                  const SizedBox(height: 24),
                  _buildPartnerPreferencesSection(),
                  const SizedBox(height: 24),
                  _buildMakeDuaBanner(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const CustomBottomNav(currentIndex: 1),
        ],
      ),
    );
  }

  // 1. PROFILE COVER SECTION (Photo + Quote/Details side-by-side)
  Widget _buildProfileCoverSection() {
    String imageLink = candidate['img'] ?? _aishaPhotoLink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column - Big Photo
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageLink,
                width: 155,
                height: 215,
                fit: BoxFit.cover,
              ),
            ),
            // Photos Count Badge
            Positioned(
              left: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.photo_library_outlined, color: Colors.white, size: 10),
                    const SizedBox(width: 4),
                    Text(
                      '5 Photos',
                      style: GoogleFonts.inter(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        // Right column - Quote & Key Badges & Brief Detail Items
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_quote, color: AppTheme.primaryGreen, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      candidate['quote'] ?? 'I believe in building a marriage that is based on faith, love, respect and good communication.',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppTheme.darkCharcoal,
                        fontStyle: FontStyle.italic,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Pill badges
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  _buildStatusPill('Practicing Muslim', const Color(0xFFE8F5E9), const Color(0xFF2E7D32), Icons.circle, iconSize: 4),
                  _buildStatusPill('Sunni', const Color(0xFFF3E8FF), const Color(0xFF6B21A8), Icons.nightlight_round),
                  _buildStatusPill('Hijab', const Color(0xFFFFE4E6), const Color(0xFF9F1239), Icons.face),
                ],
              ),
              const SizedBox(height: 12),
              // Major highlights
              _buildBriefRow(Icons.school_outlined, candidate['educationDetail'] ?? 'Undergraduate – Biology', subtitle: candidate['university'] ?? 'University of Ilorin'),
              const SizedBox(height: 8),
              _buildBriefRow(Icons.straighten, "5'4\" • Average Build"),
              const SizedBox(height: 8),
              _buildBriefRow(Icons.favorite_border, 'Never Married'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusPill(String text, Color bg, Color textCol, IconData icon, {double iconSize = 10}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: textCol),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(fontSize: 8, color: textCol, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBriefRow(IconData icon, String title, {String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppTheme.secondaryGrey),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. ACTION BUTTONS ROW
  Widget _buildActionButtonsRow() {
    return Row(
      children: [
        // Like Button
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() => _isLiked = !_isLiked);
            },
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              size: 14,
              color: Colors.white,
            ),
            label: Text(
              _isLiked ? 'Liked' : 'Like',
              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF042415),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Send Message
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: () {
              context.push('/direct-chat', extra: candidate);
            },
            icon: const Icon(Icons.chat_bubble_outline, size: 14, color: Color(0xFF042415)),
            label: Text(
              'Send Message',
              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF042415)),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF042415)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Add to Favorites
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
            },
            icon: Icon(
              _isFavorite ? Icons.bookmark : Icons.bookmark_border,
              size: 14,
              color: AppTheme.secondaryGrey,
            ),
            label: Text(
              _isFavorite ? 'Favorited' : 'Add to Favorites',
              style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.secondaryGrey),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // More Button
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: IconButton(
            icon: const Icon(Icons.more_horiz, size: 16, color: AppTheme.secondaryGrey),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // 3. ABOUT HER & COMPATIBILITY ROW
  Widget _buildAboutAndCompatibilityRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // About Her Section
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Her',
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
                const SizedBox(height: 8),
                Text(
                  candidate['about'] ?? "I'm a simple, God-fearing and family-oriented person. I enjoy learning new things, reading and spending quality time with loved ones.",
                  style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey, height: 1.4),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'Read More',
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.keyboard_arrow_down, size: 12, color: AppTheme.primaryGreen),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Compatibility Score Widget
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Compatibility Score',
                      style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.info_outline, size: 10, color: AppTheme.secondaryGrey),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 55,
                  height: 55,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircularProgressIndicator(
                        value: 0.92,
                        strokeWidth: 4,
                        backgroundColor: Color(0xFFECEFF1),
                        color: Color(0xFF10B981),
                      ),
                      Text(
                        candidate['compatibility'] ?? '92%',
                        style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 10, color: Color(0xFF10B981)),
                    const SizedBox(width: 4),
                    Text(
                      'Excellent Match',
                      style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View Details >',
                    style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 4. BASIC INFORMATION SECTION
  Widget _buildBasicInformationSection() {
    final List<Map<String, dynamic>> basicInfo = [
      {'label': 'Age', 'val': '${candidate['age'] ?? '22'} years', 'icon': Icons.person_outline, 'color': const Color(0xFFFEE2E2), 'iconColor': const Color(0xFFEF4444)},
      {'label': 'Date of Birth', 'val': candidate['dob'] ?? '15 Safar 1446 AH', 'icon': Icons.calendar_today_outlined, 'color': const Color(0xFFFEF3C7), 'iconColor': const Color(0xFFF59E0B)},
      {'label': 'Location', 'val': candidate['state'] ?? 'Ilorin, Kwara', 'icon': Icons.location_on_outlined, 'color': const Color(0xFFD1FAE5), 'iconColor': const Color(0xFF10B981)},
      {'label': 'Nationality', 'val': candidate['nationality'] ?? 'Nigerian', 'icon': Icons.public, 'color': const Color(0xFFDBEAFE), 'iconColor': const Color(0xFF3B82F6)},
      {'label': 'Ethnicity', 'val': candidate['ethnicity'] ?? 'Hausa', 'icon': Icons.star_border, 'color': const Color(0xFFF3E8FF), 'iconColor': const Color(0xFFA855F7)},
      {'label': 'Language', 'val': candidate['language'] ?? 'Hausa, English', 'icon': Icons.translate, 'color': const Color(0xFFFFE4E6), 'iconColor': const Color(0xFFF43F5E)},
      {'label': 'Education', 'val': candidate['education'] ?? 'Undergraduate', 'icon': Icons.school_outlined, 'color': const Color(0xFFE0F2F1), 'iconColor': const Color(0xFF009688)},
      {'label': 'Profession', 'val': candidate['profession'] ?? 'Student', 'icon': Icons.work_outline, 'color': const Color(0xFFECEFF1), 'iconColor': const Color(0xFF607D8B)},
    ];

    return _buildSectionContainer(
      title: 'Basic Information',
      child: _buildInfoGrid(basicInfo),
    );
  }

  // 5. LIFESTYLE & VALUES SECTION
  Widget _buildLifestyleValuesSection() {
    final List<Map<String, dynamic>> lifestyleInfo = [
      {'label': 'Religiosity', 'val': candidate['religiosity'] ?? 'Very Religious', 'icon': Icons.favorite_outline, 'color': const Color(0xFFFFEAEA), 'iconColor': const Color(0xFFE11D48)},
      {'label': 'Diet', 'val': candidate['diet'] ?? 'Halal', 'icon': Icons.check_circle_outline, 'color': const Color(0xFFE8F5E9), 'iconColor': const Color(0xFF15803D)},
      {'label': 'Prayer', 'val': candidate['prayer'] ?? '5 times a day', 'icon': Icons.access_time, 'color': const Color(0xFFFFF7ED), 'iconColor': const Color(0xFFC2410C)},
      {'label': 'Education Importance', 'val': candidate['eduImportance'] ?? 'Very Important', 'icon': Icons.school_outlined, 'color': const Color(0xFFEFF6FF), 'iconColor': const Color(0xFF1D4ED8)},
      {'label': 'Hijab', 'val': candidate['hijab'] ?? 'Always', 'icon': Icons.face_retouching_natural, 'color': const Color(0xFFFAF5FF), 'iconColor': const Color(0xFF7E22CE)},
      {'label': 'Children', 'val': candidate['children'] ?? 'Insha Allah', 'icon': Icons.people_outline, 'color': const Color(0xFFECFDF5), 'iconColor': const Color(0xFF047857)},
      {'label': 'Smoke', 'val': candidate['smoke'] ?? 'No', 'icon': Icons.smoke_free, 'color': const Color(0xFFFFF1F2), 'iconColor': const Color(0xFFBE123C)},
      {'label': 'Islamic Values', 'val': candidate['islamicValues'] ?? 'Very Important', 'icon': Icons.shield_outlined, 'color': const Color(0xFFF8FAFC), 'iconColor': const Color(0xFF475569)},
    ];

    return _buildSectionContainer(
      title: 'Lifestyle & Values',
      child: _buildInfoGrid(lifestyleInfo),
    );
  }

  // 6. FAMILY BACKGROUND SECTION
  Widget _buildFamilyBackgroundSection() {
    final List<Map<String, dynamic>> familyInfo = [
      {'label': 'Family Type', 'val': candidate['familyType'] ?? 'Nuclear', 'icon': Icons.group_outlined, 'color': const Color(0xFFEFF6FF), 'iconColor': const Color(0xFF2563EB)},
      {'label': "Father's Occupation", 'val': candidate['fatherJob'] ?? 'Business', 'icon': Icons.work_outline, 'color': const Color(0xFFECFDF5), 'iconColor': const Color(0xFF059669)},
      {'label': "Mother's Occupation", 'val': candidate['motherJob'] ?? 'Teacher', 'icon': Icons.badge_outlined, 'color': const Color(0xFFFDF2F8), 'iconColor': const Color(0xFFDB2777)},
      {'label': 'Siblings', 'val': candidate['siblings'] ?? '3 (2 Sisters, 1 Brother)', 'icon': Icons.nature_people_outlined, 'color': const Color(0xFFFEF3C7), 'iconColor': const Color(0xFFD97706)},
    ];

    return _buildSectionContainer(
      title: 'About Her Family',
      child: _buildInfoGrid(familyInfo),
    );
  }

  // 7. PARTNER PREFERENCES SECTION
  Widget _buildPartnerPreferencesSection() {
    final List<Map<String, dynamic>> prefs = [
      {'label': 'Age Range', 'val': '24 - 30', 'icon': Icons.swap_horiz},
      {'label': 'Religiosity', 'val': 'Religious', 'icon': Icons.favorite_border},
      {'label': 'Education', 'val': 'Undergraduate or above', 'icon': Icons.school_outlined},
      {'label': 'Location', 'val': 'Open to relocate', 'icon': Icons.map_outlined},
      {'label': 'Marital Status', 'val': 'Never Married', 'icon': Icons.favorite_outline},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "What She's Looking For",
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
              Text(
                'View All',
                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 65,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: prefs.length,
            itemBuilder: (context, index) {
              final pref = prefs[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF9FAF6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(pref['icon'], size: 14, color: AppTheme.primaryGreen),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            pref['label'],
                            style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            pref['val'],
                            style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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

  // 8. MAKE DU'A FOOTER BANNER
  Widget _buildMakeDuaBanner() {
    return Container(
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
            child: const Icon(Icons.volunteer_activism_outlined, color: Color(0xFF7C3AED), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Make Du'a",
                  style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF5B21B6)),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ask Allah to guide you to what is best for you in this search.',
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
            ),
            child: Row(
              children: [
                Text(
                  "Make Du'a",
                  style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_forward_ios, size: 8, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- REUSABLE LAYOUT HELPERS ---
  Widget _buildSectionContainer({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
              Text(
                'View All',
                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildInfoGrid(List<Map<String, dynamic>> items) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: i + 2 < items.length ? 12.0 : 0.0),
            child: Row(
              children: [
                Expanded(child: _buildInfoTile(items[i])),
                if (i + 1 < items.length) ...[
                  const SizedBox(width: 12),
                  Expanded(child: _buildInfoTile(items[i + 1])),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfoTile(Map<String, dynamic> item) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: item['color'],
            shape: BoxShape.circle,
          ),
          child: Icon(item['icon'], size: 14, color: item['iconColor']),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['label'],
                style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
              ),
              const SizedBox(height: 1),
              Text(
                item['val'],
                style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _aishaPhotoLink() => 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80';
}
