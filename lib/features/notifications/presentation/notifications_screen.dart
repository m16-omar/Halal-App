import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0; // 0: All, 1: Matches, 2: Messages, 3: System

  final List<Map<String, dynamic>> _newNotifications = [
    {
      'id': 1,
      'type': 'match',
      'title': 'New Match',
      'desc': 'You and Aisha Usman have liked each other. Start a conversation now!',
      'time': '2m ago',
      'avatar': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80',
      'icon': Icons.favorite_border,
      'color': const Color(0xFFFFE4E6),
      'iconColor': const Color(0xFF9F1239),
    },
    {
      'id': 2,
      'type': 'message',
      'title': 'New Message',
      'desc': 'Aisha Usman sent you a message.',
      'time': '5m ago',
      'avatar': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80',
      'icon': Icons.chat_bubble_outline,
      'color': const Color(0xFFE8F5E9),
      'iconColor': const Color(0xFF2E7D32),
    },
    {
      'id': 3,
      'type': 'match',
      'title': 'New Connection Request',
      'desc': 'Yusuf Ahmad sent you a connection request.',
      'time': '10m ago',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80',
      'icon': Icons.person_add_outlined,
      'color': const Color(0xFFF3E8FF),
      'iconColor': const Color(0xFF6B21A8),
    },
    {
      'id': 4,
      'type': 'system',
      'title': 'Profile Viewed',
      'desc': 'Fatima Bello viewed your profile.',
      'time': '15m ago',
      'avatar': 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=500&auto=format&fit=crop&q=80',
      'icon': Icons.star_border,
      'color': const Color(0xFFFEF3C7),
      'iconColor': const Color(0xFFD97706),
    },
  ];

  final List<Map<String, dynamic>> _earlierNotifications = [
    {
      'id': 5,
      'type': 'system',
      'title': 'Safety Reminder',
      'desc': 'Please remember to keep conversations respectful and follow our community guidelines.',
      'time': '1h ago',
      'isUnread': true,
      'icon': Icons.shield_outlined,
      'color': const Color(0xFFEFF6FF),
      'iconColor': const Color(0xFF1D4ED8),
    },
    {
      'id': 6,
      'type': 'system',
      'title': 'Upcoming Session Reminder',
      'desc': 'You have a counseling session with Amina Yusuf tomorrow at 4:00 PM.',
      'time': '2h ago',
      'isUnread': true,
      'icon': Icons.calendar_today_outlined,
      'color': const Color(0xFFE8F5E9),
      'iconColor': const Color(0xFF047857),
    },
    {
      'id': 7,
      'type': 'system',
      'title': 'Ramadan Special',
      'desc': 'Complete your profile to get better matches during this blessed month.',
      'time': '1 day ago',
      'isUnread': true,
      'icon': Icons.card_giftcard,
      'color': const Color(0xFFFFE4E6),
      'iconColor': const Color(0xFFBE123C),
    },
    {
      'id': 8,
      'type': 'system',
      'title': 'New Feature',
      'desc': 'You can now send voice messages! Try it out in your chats.',
      'time': '2 days ago',
      'isUnread': true,
      'icon': Icons.campaign_outlined,
      'color': const Color(0xFFFEF3C7),
      'iconColor': const Color(0xFFD97706),
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var n in _newNotifications) {
        n['isUnread'] = false;
      }
      for (var n in _earlierNotifications) {
        n['isUnread'] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic Filter
    List<Map<String, dynamic>> filteredNew = _newNotifications;
    List<Map<String, dynamic>> filteredEarlier = _earlierNotifications;

    if (_selectedFilter == 1) {
      filteredNew = _newNotifications.where((n) => n['type'] == 'match').toList();
      filteredEarlier = _earlierNotifications.where((n) => n['type'] == 'match').toList();
    } else if (_selectedFilter == 2) {
      filteredNew = _newNotifications.where((n) => n['type'] == 'message').toList();
      filteredEarlier = _earlierNotifications.where((n) => n['type'] == 'message').toList();
    } else if (_selectedFilter == 3) {
      filteredNew = _newNotifications.where((n) => n['type'] == 'system').toList();
      filteredEarlier = _earlierNotifications.where((n) => n['type'] == 'system').toList();
    }

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
              'Notifications',
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
                  'Stay updated with what matters',
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
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: AppTheme.darkCharcoal, size: 18),
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
              icon: const Icon(Icons.settings, color: AppTheme.darkCharcoal, size: 18),
              onPressed: () => context.push('/settings'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Dynamic Filter Tabs Bar
          _buildFilterTabsRow(),
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAF6),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  // New Section
                  if (filteredNew.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'New',
                            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                          ),
                          GestureDetector(
                            onTap: _markAllAsRead,
                            child: Text(
                              'Mark all as read',
                              style: GoogleFonts.inter(fontSize: 11, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredNew.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationItem(filteredNew[index]);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Earlier Section
                  if (filteredEarlier.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Text(
                        'Earlier',
                        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredEarlier.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationItem(filteredEarlier[index]);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Custom Bottom Navigation Bar
          const CustomBottomNav(currentIndex: 4), // Notifications (usually Profile is index 4, which is a perfect placement)
        ],
      ),
    );
  }

  // 1. FILTER TABS ROW
  Widget _buildFilterTabsRow() {
    final List<Map<String, dynamic>> filters = [
      {'label': 'All', 'count': 12},
      {'label': 'Matches', 'count': 4},
      {'label': 'Messages', 'count': 5},
      {'label': 'System', 'count': 3},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(filters.length, (index) {
          bool isSelected = _selectedFilter == index;
          final f = filters[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    f['label'],
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppTheme.primaryGreen : AppTheme.secondaryGrey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryGreen : const Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${f['count']}',
                      style: GoogleFonts.inter(
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  // 2. NOTIFICATION LIST ITEM
  Widget _buildNotificationItem(Map<String, dynamic> item) {
    bool isUnread = item['isUnread'] ?? true;
    bool hasAvatar = item['avatar'] != null;

    return Container(
      color: isUnread ? const Color(0xFFF4F6F0).withOpacity(0.3) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unread green indicator dot
          if (isUnread) ...[
            Container(
              margin: const EdgeInsets.only(top: 14, right: 6),
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
            ),
          ] else ...[
            const SizedBox(width: 11),
          ],
          // Left Icon in colored circle
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item['color'],
              shape: BoxShape.circle,
            ),
            child: Icon(item['icon'], size: 16, color: item['iconColor']),
          ),
          const SizedBox(width: 12),
          // Middle text details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item['desc'],
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: AppTheme.secondaryGrey,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['time'],
                  style: GoogleFonts.inter(fontSize: 8, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Right Avatar or arrow chevron
          if (hasAvatar) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                item['avatar'],
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 6),
          ],
          const Icon(Icons.chevron_right, size: 14, color: AppTheme.secondaryGrey),
        ],
      ),
    );
  }
}
