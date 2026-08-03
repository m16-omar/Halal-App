import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class CounselingScreen extends ConsumerStatefulWidget {
  const CounselingScreen({super.key});

  @override
  ConsumerState<CounselingScreen> createState() => _CounselingScreenState();
}

class _CounselingScreenState extends ConsumerState<CounselingScreen> {
  final TextEditingController _searchController = TextEditingController();
  late PageController _versePageController;
  Timer? _verseCarouselTimer;
  int _selectedVersePage = 0;
  String? _selectedCategory;

  final List<Map<String, String>> _ayahs = [
    {
      'text': '"And among His signs is that He created for you from yourselves spouses that you may find tranquility in them."',
      'reference': '— Qur\'an 30:21',
    },
    {
      'text': '"They (your wives) are a clothing/garment for you, and you are a clothing/garment for them."',
      'reference': '— Qur\'an 2:187',
    },
    {
      'text': '"He is the One Who created you from a single soul, and made from it its mate so he may find comfort in her."',
      'reference': '— Qur\'an 7:189',
    },
    {
      'text': '"Our Lord, grant us from among our wives and offspring comfort to our eyes and make us an example for the righteous."',
      'reference': '— Qur\'an 25:74',
    },
    {
      'text': '"And Allah has made for you from yourselves mates, and has made for you from your mates children and grandchildren."',
      'reference': '— Qur\'an 16:72',
    },
  ];

  @override
  void initState() {
    super.initState();
    _versePageController = PageController(initialPage: 0);
    _startVerseCarouselTimer();
  }

  void _startVerseCarouselTimer() {
    _verseCarouselTimer?.cancel();
    _verseCarouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_versePageController.hasClients) {
        int nextPage = _selectedVersePage + 1;
        if (nextPage >= _ayahs.length) {
          nextPage = 0;
        }
        _versePageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _verseCarouselTimer?.cancel();
    _versePageController.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            // Right Quran Verse sliding text
            Expanded(
              child: SizedBox(
                height: 85,
                child: PageView.builder(
                  controller: _versePageController,
                  itemCount: _ayahs.length,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedVersePage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final ayah = _ayahs[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ayah['text']!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B5E20),
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ayah['reference']!,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF558B2F),
                              ),
                            ),
                            // Carousel Indicator dots
                            Row(
                              children: List.generate(_ayahs.length, (dotIndex) {
                                bool isSelected = _selectedVersePage == dotIndex;
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  width: isSelected ? 10 : 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: isSelected
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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- GET GUIDANCE SECTION ---
  void _showAskScholarBottomSheet() {
    final TextEditingController questionController = TextEditingController();
    String selectedTopic = 'Marriage Rights';
    
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
                    'Ask a Scholar',
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
                'Select Topic',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCharcoal,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedTopic,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.topic_outlined),
                ),
                items: [
                  'Marriage Rights',
                  'Wali Consent',
                  'Mahr & Dowry',
                  'Resolving Conflict',
                  'Islamic Custom & Culture',
                  'Other'
                ].map((topic) => DropdownMenuItem(
                  value: topic,
                  child: Text(topic, style: GoogleFonts.inter(fontSize: 14)),
                )).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() {
                      selectedTopic = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Your Question',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCharcoal,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: questionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Write your question here in detail... (e.g. Is it mandatory for a Wali to meet the groom face-to-face?)',
                  alignLabelWithHint: true,
                ),
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
                    final q = questionController.text.trim();
                    if (q.isEmpty) return;
                    Navigator.pop(context);
                    
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Row(
                          children: [
                            const Icon(Icons.check_circle, color: AppTheme.primaryGreen),
                            const SizedBox(width: 8),
                            Text('Question Submitted', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        content: Text(
                          'Your question regarding "$selectedTopic" has been successfully sent to our panel of verified Islamic scholars.\n\nYou will receive a notification as soon as a scholar responds (typically within 24 hours).',
                          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.darkCharcoal, height: 1.4),
                        ),
                        actions: [
                          TextButton(
                            child: Text('OK', style: GoogleFonts.inter(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Submit to Scholar',
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

  void _showPreMaritalGuidanceBottomSheet() {
    final List<Map<String, dynamic>> checklist = [
      {
        'title': 'Understand the Islamic Purpose of Marriage',
        'desc': 'Study the Qur\'an verses on sakinah (tranquility), mawaddah (love), and rahmah (mercy).',
        'done': true,
      },
      {
        'title': 'Review Rights & Duties in Marriage',
        'desc': 'Ensure clear understanding of the mutual obligations of husbands and wives under Islamic law.',
        'done': false,
      },
      {
        'title': 'Discuss Expectations with Wali',
        'desc': 'Arrange a checklist of topics to discuss transparently with the Wali present.',
        'done': false,
      },
      {
        'title': 'Draft the Marriage Contract (Nikah)',
        'desc': 'Explore essential clauses, conditions, and custom agreements to include in the contract.',
        'done': false,
      },
      {
        'title': 'Financial Preparation & Mahr',
        'desc': 'Align on the Mahr (dowry) value and study Islamic guidelines on family budgeting.',
        'done': false,
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF9FAF6),
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
                    'Pre-Marital Preparation',
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
                'Essential Steps Checklist',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCharcoal,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: checklist.length,
                  itemBuilder: (context, index) {
                    final item = checklist[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black.withOpacity(0.03)),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          leading: Checkbox(
                            value: item['done'],
                            activeColor: AppTheme.primaryGreen,
                            onChanged: (val) {
                              setModalState(() {
                                item['done'] = val;
                              });
                            },
                          ),
                          title: Text(
                            item['title'],
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCharcoal,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                              child: Text(
                                item['desc'],
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppTheme.secondaryGrey,
                                  height: 1.4,
                                ),
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
          ),
        ),
      ),
    );
  }

  Widget _buildGetGuidanceSection() {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Articles',
        'sub': 'Islamic insights\n& advice',
        'icon': Icons.menu_book_outlined,
        'type': 'article',
      },
      {
        'title': 'Video Lessons',
        'sub': 'Learn from\nscholars',
        'icon': Icons.play_circle_outline,
        'type': 'video',
      },
      {
        'title': 'Audio Talks',
        'sub': 'Listen to\nreminders',
        'icon': Icons.headset_outlined,
        'type': 'audio',
      },
      {
        'title': 'Ask a Scholar',
        'sub': 'Get answers to\nyour questions',
        'icon': Icons.chat_bubble_outline,
        'type': 'scholar',
      },
      {
        'title': 'Pre-Marital Guidance',
        'sub': 'Prepare for a\nblessed home',
        'icon': Icons.people_outline,
        'type': 'guidance',
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
                onTap: () {
                  setState(() {
                    _selectedCategory = null;
                  });
                },
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
              final catType = cat['type'] as String;
              final isSelected = _selectedCategory == catType;

              return GestureDetector(
                onTap: () {
                  if (catType == 'scholar') {
                    _showAskScholarBottomSheet();
                  } else if (catType == 'guidance') {
                    _showPreMaritalGuidanceBottomSheet();
                  } else {
                    setState(() {
                      if (_selectedCategory == catType) {
                        _selectedCategory = null;
                      } else {
                        _selectedCategory = catType;
                      }
                    });
                  }
                },
                child: Container(
                  width: 115,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryGreen.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryGreen : Colors.black.withOpacity(0.04),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        cat['icon'],
                        color: isSelected ? AppTheme.primaryGreen : AppTheme.primaryGreen.withOpacity(0.8),
                        size: 24,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat['title'],
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
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

  void _showAllResourcesBottomSheet() {
    final List<Map<String, String>> allResources = [
      {
        'title': 'Building a Strong Islamic Marriage',
        'sub': 'Key principles every couple should know before and after marriage.',
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
      {
        'title': 'Managing Conflicts Islamically',
        'sub': 'Practical tips from Quranic guidance on conflict resolution.',
        'tag': 'Article',
        'duration': '06:20',
        'type': 'article',
      },
      {
        'title': 'The Prophet\'s (SAW) Marital Life',
        'sub': 'Lessons from the household of the Prophet Muhammad.',
        'tag': 'Video',
        'duration': '22:15',
        'type': 'video',
      },
      {
        'title': 'Mahr and Marriage Contracts',
        'sub': 'Understanding the rules of dowry and Nikah conditions.',
        'tag': 'Audio',
        'duration': '14:40',
        'type': 'audio',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF9FAF6),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Counseling Resources',
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
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: allResources.length,
                  itemBuilder: (context, index) {
                    final res = allResources[index];
                    IconData tagIcon = Icons.play_circle_outline;
                    Color tagColor = const Color(0xFF673AB7);
                    if (res['type'] == 'article') {
                      tagIcon = Icons.description_outlined;
                      tagColor = const Color(0xFF2E7D32);
                    } else if (res['type'] == 'audio') {
                      tagIcon = Icons.headset_outlined;
                      tagColor = const Color(0xFFEF6C00);
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: Row(
                              children: [
                                Icon(tagIcon, color: tagColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    res['title']!,
                                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            content: Text(
                              '${res['sub']}\n\nThis is a simulation of the full lesson content (${res['tag']} - ${res['duration']}). Premium members get unlimited access to all counseling curriculum resources.',
                              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.darkCharcoal, height: 1.4),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Close', style: GoogleFonts.inter(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black.withOpacity(0.03)),
                        ),
                        child: Row(
                          children: [
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
                          ],
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

    final filteredResources = _selectedCategory == null
        ? resources
        : resources.where((r) => r['type'] == _selectedCategory).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedCategory == null
                    ? 'Recommended for You'
                    : '${_selectedCategory![0].toUpperCase()}${_selectedCategory!.substring(1)} Resources',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCharcoal,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_selectedCategory != null) {
                    setState(() {
                      _selectedCategory = null;
                    });
                  } else {
                    _showAllResourcesBottomSheet();
                  }
                },
                child: Text(
                  _selectedCategory != null ? 'Clear Filter' : 'View all >',
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
        if (filteredResources.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'No resources found in this category yet.',
                style: GoogleFonts.inter(color: AppTheme.secondaryGrey),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: filteredResources.length,
            itemBuilder: (context, index) {
              final res = filteredResources[index];
              IconData tagIcon = Icons.play_circle_outline;
              Color tagColor = const Color(0xFF673AB7);
              if (res['type'] == 'article') {
                tagIcon = Icons.description_outlined;
                tagColor = const Color(0xFF2E7D32);
              } else if (res['type'] == 'audio') {
                tagIcon = Icons.headset_outlined;
                tagColor = const Color(0xFFEF6C00);
              }

              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Row(
                        children: [
                          Icon(tagIcon, color: tagColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              res['title']!,
                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      content: Text(
                        '${res['sub']}\n\nThis is a simulation of the full lesson content (${res['tag']} - ${res['duration']}). Premium members get unlimited access to all counseling curriculum resources.',
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.darkCharcoal, height: 1.4),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Close', style: GoogleFonts.inter(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black.withOpacity(0.03)),
                  ),
                  child: Row(
                    children: [
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
