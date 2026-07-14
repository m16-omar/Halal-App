import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _selectedFilter = 0; // 0: All, 1: Unread, 2: Matches, 3: Groups
  bool _showSafetyBanner = true;

  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'Aisha Usman',
      'lastMsg': 'Assalamu alaikum, how are you?',
      'time': '9:40 AM',
      'unread': 2,
      'isOnline': true,
      'isVerified': true,
      'isGroup': false,
      'img': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Yusuf Ahmad',
      'lastMsg': 'Jazakillahu khair for your message.',
      'time': '9:15 AM',
      'unread': 1,
      'isOnline': true,
      'isVerified': false,
      'isGroup': false,
      'img': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Fatima Bello',
      'lastMsg': 'That sounds great, In sha Allah.',
      'time': 'Yesterday',
      'unread': 0,
      'isOnline': false,
      'isVerified': true,
      'isGroup': false,
      'isPinned': true,
      'img': 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Ibrahim Musa',
      'lastMsg': 'Can we continue this later?',
      'time': 'Yesterday',
      'unread': 3,
      'isOnline': false,
      'isVerified': false,
      'isGroup': false,
      'img': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Zainab Lawal',
      'lastMsg': 'I\'ve sent you a picture.',
      'time': 'May 12',
      'unread': 0,
      'isOnline': false,
      'isVerified': false,
      'isGroup': false,
      'isPinned': true,
      'img': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Marriage Guidance Group',
      'lastMsg': 'Amina Yusuf: Jazakillahu khair everyone',
      'time': 'May 8',
      'unread': 12,
      'isOnline': false,
      'isVerified': false,
      'isGroup': true,
      'img': 'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Maryam Abdullahi',
      'lastMsg': 'Wa alaikum assalam',
      'time': 'May 7',
      'unread': 0,
      'isOnline': false,
      'isVerified': false,
      'isGroup': false,
      'img': 'https://images.unsplash.com/photo-1589156280159-27698a70f29e?w=500&auto=format&fit=crop&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter chats dynamically based on tab selection
    List<Map<String, dynamic>> filteredChats = _chats;
    if (_selectedFilter == 1) {
      filteredChats = _chats.where((c) => c['unread'] > 0).toList();
    } else if (_selectedFilter == 2) {
      filteredChats = _chats.where((c) => !c['isGroup']).toList();
    } else if (_selectedFilter == 3) {
      filteredChats = _chats.where((c) => c['isGroup']).toList();
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
              'Messages',
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
                  'Chat with your matches',
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
              icon: const Icon(Icons.more_horiz, color: AppTheme.darkCharcoal, size: 18),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs Bar
          _buildFilterTabsRow(),
          // Safety Banner
          if (_showSafetyBanner) _buildSafetyBanner(),
          // Chats List View
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAF6),
              child: filteredChats.isEmpty
                  ? Center(
                      child: Text(
                        'No messages found',
                        style: GoogleFonts.inter(fontSize: 12, color: AppTheme.secondaryGrey),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: filteredChats.length,
                      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[100]),
                      itemBuilder: (context, index) {
                        final chat = filteredChats[index];
                        return _buildChatListItem(chat);
                      },
                    ),
            ),
          ),
          // Custom Bottom Navigation Bar
          const CustomBottomNav(currentIndex: 1),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF042415),
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit_note),
      ),
    );
  }

  // 1. FILTER TABS ROW
  Widget _buildFilterTabsRow() {
    final List<Map<String, dynamic>> filters = [
      {'label': 'All', 'count': 8},
      {'label': 'Unread', 'count': 4},
      {'label': 'Matches', 'count': null},
      {'label': 'Groups', 'count': null},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: List.generate(filters.length, (index) {
          bool isSelected = _selectedFilter == index;
          final f = filters[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF042415) : Colors.white,
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
                      color: isSelected ? Colors.white : AppTheme.secondaryGrey,
                    ),
                  ),
                  if (f['count'] != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${f['count']}',
                        style: GoogleFonts.inter(
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFF042415) : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // 2. SAFETY BANNER
  Widget _buildSafetyBanner() {
    return Container(
      color: const Color(0xFFF4F6F0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_outlined, color: Color(0xFF1B5E20), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 10, color: AppTheme.darkCharcoal, height: 1.4),
                children: [
                  const TextSpan(text: 'Keep conversations respectful. ', style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: 'Our community guidelines help us build a safe and respectful space for everyone. '),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _showSafetyBanner = false),
            child: const Icon(Icons.close, size: 16, color: AppTheme.secondaryGrey),
          ),
        ],
      ),
    );
  }

  // 3. CHAT LIST ITEM
  Widget _buildChatListItem(Map<String, dynamic> chat) {
    bool hasUnread = chat['unread'] > 0;
    bool isPinned = chat['isPinned'] ?? false;

    return ListTile(
      onTap: () {
        context.push('/direct-chat', extra: chat);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.network(
              chat['img'],
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          if (chat['isOnline'])
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Text(
            chat['name'],
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
              color: AppTheme.darkCharcoal,
            ),
          ),
          if (chat['isVerified']) ...[
            const SizedBox(width: 4),
            const Icon(Icons.verified, size: 12, color: Color(0xFF10B981)),
          ],
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          chat['lastMsg'],
          style: GoogleFonts.inter(
            fontSize: 10,
            color: hasUnread ? AppTheme.darkCharcoal : AppTheme.secondaryGrey,
            fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat['time'],
            style: GoogleFonts.inter(
              fontSize: 8,
              color: hasUnread ? AppTheme.primaryGreen : AppTheme.secondaryGrey,
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPinned) ...[
                const Icon(Icons.push_pin, size: 10, color: AppTheme.secondaryGrey),
                const SizedBox(width: 4),
              ],
              if (hasUnread)
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color(0xFF042415),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${chat['unread']}',
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
