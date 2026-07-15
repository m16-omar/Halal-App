import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class DailyReminderScreen extends StatefulWidget {
  const DailyReminderScreen({super.key});

  @override
  State<DailyReminderScreen> createState() => _DailyReminderScreenState();
}

class _DailyReminderScreenState extends State<DailyReminderScreen> {
  int _selectedCategory = 0; // 0: Qur'an, 1: Hadith, 2: Dua, 3: Reminder, 4: Akhlaq
  bool _notificationsEnabled = true;

  // Categories list
  final List<Map<String, dynamic>> _categories = [
    {'title': 'Qur\'an', 'icon': Icons.menu_book, 'count': 42, 'activeColor': const Color(0xFF042415)},
    {'title': 'Hadith', 'icon': Icons.mosque_outlined, 'count': 36, 'activeColor': const Color(0xFF1565C0)},
    {'title': 'Dua', 'icon': Icons.back_hand_outlined, 'count': 28, 'activeColor': const Color(0xFFC62828)},
    {'title': 'Reminder', 'icon': Icons.notifications_active_outlined, 'count': 52, 'activeColor': const Color(0xFFEF6C00)},
    {'title': 'Akhlaq', 'icon': Icons.eco_outlined, 'count': 31, 'activeColor': const Color(0xFF00695C)},
  ];

  // Reminders list partitioned by category index
  final Map<int, List<Map<String, dynamic>>> _remindersByCategory = {
    0: [
      {
        'title': 'Indeed, with hardship comes ease.',
        'author': 'Surah Ash-Sharh (94:6)',
        'date': 'May 12, 2026 • 4 Dhul-Qi\'dah 1447 AH',
        'icon': Icons.menu_book,
        'iconColor': const Color(0xFF042415),
        'bg': const Color(0xFFE8F5E9),
      },
      {
        'title': 'And put your trust in Allah, and sufficient is Allah as Disposer of affairs.',
        'author': 'Surah Al-Ahzab (33:3)',
        'date': 'May 10, 2026 • 2 Dhul-Qi\'dah 1447 AH',
        'icon': Icons.menu_book,
        'iconColor': const Color(0xFF042415),
        'bg': const Color(0xFFE8F5E9),
      },
    ],
    1: [
      {
        'title': 'The best among you are those who learn the Qur\'an and teach it.',
        'author': 'Sahih Bukhari (5027)',
        'date': 'May 11, 2026 • 3 Dhul-Qi\'dah 1447 AH',
        'icon': Icons.lightbulb_outline,
        'iconColor': const Color(0xFFD4AF37),
        'bg': const Color(0xFFFFFDE7),
      },
    ],
    2: [
      {
        'title': 'Our Lord, give us in this world [that which is] good and in the Hereafter [that which is] good and protect us from the punishment of the Fire.',
        'author': 'Surah Al-Baqarah (2:201)',
        'date': 'May 09, 2026 • 1 Dhul-Qi\'dah 1447 AH',
        'icon': Icons.back_hand_outlined,
        'iconColor': const Color(0xFFC62828),
        'bg': const Color(0xFFFFEBEE),
      },
    ],
    3: [
      {
        'title': 'Perform prayer at the two ends of the day and in the early hours of the night.',
        'author': 'Surah Hud (11:114)',
        'date': 'May 08, 2026 • 30 Shawwal 1447 AH',
        'icon': Icons.access_time,
        'iconColor': const Color(0xFFEF6C00),
        'bg': const Color(0xFFFFF3E0),
      },
    ],
    4: [
      {
        'title': 'The most complete of believers in faith is the one with the best character.',
        'author': 'Sunan Tirmidhi (1162)',
        'date': 'May 07, 2026 • 29 Shawwal 1447 AH',
        'icon': Icons.eco_outlined,
        'iconColor': const Color(0xFF00695C),
        'bg': const Color(0xFFE0F2F1),
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayedReminders = _remindersByCategory[_selectedCategory] ?? [];

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
        title: Text(
          'Daily Islamic Reminder',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkCharcoal,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: AppTheme.darkCharcoal, size: 18),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Reminder Card
                  _buildTodayReminderCard(),
                  const SizedBox(height: 20),
                  // Reflection Card
                  _buildReflectionCard(),
                  const SizedBox(height: 24),
                  // Categories Section
                  _buildCategoriesSection(),
                  const SizedBox(height: 24),
                  // Previous Reminders Section
                  _buildPreviousRemindersSection(displayedReminders),
                  const SizedBox(height: 24),
                  // Notification Switch Card
                  _buildNotificationSwitchCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Custom Bottom Navigation Bar
          const CustomBottomNav(currentIndex: 0),
        ],
      ),
    );
  }

  // 1. TODAY'S REMINDER HERO CONTAINER
  Widget _buildTodayReminderCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF042415), Color(0xFF073822)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Mosque Graphic
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Opacity(
              opacity: 0.15,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                child: Image.network(
                  'https://images.unsplash.com/photo-1542838132-92c53300491e?w=300&auto=format&fit=crop&q=80',
                  fit: BoxFit.cover,
                  width: 150,
                ),
              ),
            ),
          ),
          // Crescent Moon and Stars Overlay mockup
          Positioned(
            right: 20,
            top: 24,
            child: Column(
              children: [
                const Icon(Icons.nightlight_round, color: AppTheme.accentGold, size: 40),
                const SizedBox(height: 20),
                Icon(Icons.light, color: AppTheme.accentGold.withOpacity(0.8), size: 30),
              ],
            ),
          ),
          // Text Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.calendar_today_outlined, color: AppTheme.accentGold, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Reminder',
                          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'May 13, 2026 • 5 Dhul-Qi\'dah 1447 AH',
                          style: GoogleFonts.inter(fontSize: 8, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Gold Quotation mark
                Text(
                  '“ ”',
                  style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.accentGold, height: 0.6),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    'And remember Allah abundantly so that you may be successful.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '— Surah Al-Jumu\'ah (62:10)',
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[300], fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. REFLECTION CARD
  Widget _buildReflectionCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: AppTheme.primaryGreen, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reflection',
                  style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
                const SizedBox(height: 2),
                Text(
                  'Take a moment to reflect on how you can remember Allah more in your daily life.',
                  style: GoogleFonts.inter(fontSize: 9, color: AppTheme.secondaryGrey, height: 1.3),
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

  // 3. CATEGORIES SECTION
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View All',
                style: GoogleFonts.inter(fontSize: 10, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              bool isSelected = _selectedCategory == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = index),
                child: Container(
                  width: 72,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? cat['activeColor'] : const Color(0xFFF9FAF6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[200]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        cat['icon'],
                        color: isSelected ? Colors.white : AppTheme.darkCharcoal,
                        size: 20,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat['title'],
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppTheme.darkCharcoal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey[300]!,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${cat['count']}',
                          style: GoogleFonts.inter(
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppTheme.secondaryGrey,
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
    );
  }

  // 4. PREVIOUS REMINDERS
  Widget _buildPreviousRemindersSection(List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Previous Reminders',
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View All',
                style: GoogleFonts.inter(fontSize: 10, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAF6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No previous reminders in this category.',
                style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final rem = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: rem['bg'],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(rem['icon'], color: rem['iconColor'], size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rem['title'],
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            rem['author'],
                            style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 8, color: Colors.grey[400]),
                              const SizedBox(width: 4),
                              Text(
                                rem['date'],
                                style: GoogleFonts.inter(fontSize: 7, color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: AppTheme.secondaryGrey, size: 18),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  // 5. NOTIFICATION SWITCH CARD
  Widget _buildNotificationSwitchCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAF6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_active, color: AppTheme.primaryGreen, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Reminder Notification',
                  style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
                const SizedBox(height: 2),
                Text(
                  'Get reminded every day with inspiring Islamic reminders.',
                  style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_notificationsEnabled ? 'Daily reminder notifications enabled' : 'Daily reminder notifications disabled'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            activeColor: Colors.white,
            activeTrackColor: AppTheme.primaryGreen,
            inactiveThumbColor: Colors.grey[300],
            inactiveTrackColor: Colors.grey[200],
          ),
        ],
      ),
    );
  }
}
