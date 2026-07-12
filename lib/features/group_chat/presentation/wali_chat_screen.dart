import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';

class WaliChatScreen extends ConsumerStatefulWidget {
  const WaliChatScreen({super.key});

  @override
  ConsumerState<WaliChatScreen> createState() => _WaliChatScreenState();
}

class _WaliChatScreenState extends ConsumerState<WaliChatScreen> {
  int _currentIndex = 4; // Special Wali Chat selected
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock avatar URLs
  final String _yusufAvatar = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80';
  final String _aishaAvatar = 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80';
  final String _waliAvatar = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF6),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSupervisionCard(),
                      const SizedBox(height: 12),
                      _buildQuoteAndProgressRow(),
                      const SizedBox(height: 20),
                      _buildChatFeedSection(),
                      const SizedBox(height: 16),
                      _buildStartConversationPrompts(),
                      const SizedBox(height: 16),
                      _buildInputComposer(),
                      const SizedBox(height: 20),
                      _buildActionsFooterSection(),
                    ],
                  ),
                ),
              ),
            ),
            _buildCustomBottomNav(),
          ],
        ),
      ),
    );
  }

  // --- HEADER SECTION ---
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.darkCharcoal, size: 24),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 4),
          // Overlapping avatars
          SizedBox(
            width: 55,
            height: 32,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(_yusufAvatar),
                  ),
                ),
                Positioned(
                  left: 14,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(_aishaAvatar),
                  ),
                ),
                Positioned(
                  left: 28,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(_waliAvatar),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ta\'aruf Conversation',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkCharcoal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Supervised by Wali',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppTheme.secondaryGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Active',
                            style: GoogleFonts.inter(fontSize: 7, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people_outline, size: 7, color: AppTheme.secondaryGrey),
                          const SizedBox(width: 4),
                          Text(
                            '3 Members',
                            style: GoogleFonts.inter(fontSize: 7, fontWeight: FontWeight.bold, color: AppTheme.secondaryGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
                icon: const Icon(Icons.phone_outlined, color: AppTheme.darkCharcoal, size: 20),
                onPressed: () {},
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
                icon: const Icon(Icons.videocam_outlined, color: AppTheme.darkCharcoal, size: 20),
                onPressed: () {},
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
                icon: const Icon(Icons.more_vert, color: AppTheme.darkCharcoal, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SUPERVISION PARTICIPANTS CARD ---
  Widget _buildSupervisionCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(8), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Yusuf, Aisha, Wali Profiles
          Expanded(
            flex: 13,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildParticipantColumn(_yusufAvatar, 'Yusuf Ahmad', '28 years', 'Groom', const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
                _buildParticipantColumn(_aishaAvatar, 'Aisha Usman', '22 years', 'Bride', const Color(0xFFFFEBEE), const Color(0xFFC62828)),
                _buildParticipantColumn(_waliAvatar, 'Haji Usman Ahmad', 'Wali (Father)', 'Wali', const Color(0xFFF3E5F5), const Color(0xFF6A1B9A)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const VerticalDivider(width: 1, thickness: 1),
          const SizedBox(width: 8),
          // Conversation Rules
          Expanded(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.security_outlined, size: 12, color: AppTheme.primaryGreen),
                    const SizedBox(width: 4),
                    Text(
                      'Conversation Rules',
                      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildRuleItem('Be respectful & sincere'),
                _buildRuleItem('No private contact'),
                _buildRuleItem('Discuss with intention'),
                _buildRuleItem('Keep family informed'),
                _buildRuleItem('Allah is always watching'),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'View Full Guidelines',
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right, color: AppTheme.primaryGreen, size: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantColumn(String avatarUrl, String name, String subtitle, String role, Color roleBg, Color roleColor) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          name.split(' ')[0], // First name only to prevent wrapping
          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
          textAlign: TextAlign.center,
        ),
        Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: roleBg,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            role,
            style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: roleColor),
          ),
        ),
      ],
    );
  }

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          const Icon(Icons.check, size: 8, color: Color(0xFF10B981)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              rule,
              style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // --- PROPHET QUOTE & PROGRESS STEPPER ---
  Widget _buildQuoteAndProgressRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prophet Quote card
        Expanded(
          flex: 11,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mosque_outlined, color: Color(0xFF2E7D32), size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember the purpose of ta\'aruf is to build a righteous and peaceful home in the sake of Allah.',
                        style: GoogleFonts.inter(fontSize: 8, color: AppTheme.darkCharcoal, height: 1.3, fontStyle: FontStyle.italic),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '– Prophet Muhammad (ﷺ)',
                        style: GoogleFonts.inter(fontSize: 7, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Progress Stepper card
        Expanded(
          flex: 9,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withAlpha(8), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Conversation Progress',
                      style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                    const Icon(Icons.info_outline, size: 10, color: AppTheme.secondaryGrey),
                  ],
                ),
                // Custom Linear Stepper
                Row(
                  children: [
                    _buildStepperNode('Interest', true, true),
                    _buildStepperLine(true),
                    _buildStepperNode('Conversation', true, true),
                    _buildStepperLine(false),
                    _buildStepperNode('Meeting', false, false),
                    _buildStepperLine(false),
                    _buildStepperNode('Decision', false, false),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepperNode(String label, bool isCompleted, bool isActive) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? const Color(0xFF10B981) : Colors.white,
            border: Border.all(
              color: isCompleted ? const Color(0xFF10B981) : Colors.black12,
              width: 1.5,
            ),
          ),
          child: isCompleted
              ? const Center(child: Icon(Icons.check, size: 8, color: Colors.white))
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 6,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppTheme.darkCharcoal : AppTheme.secondaryGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepperLine(bool isActive) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 2,
        color: isActive ? const Color(0xFF10B981) : Colors.black12,
      ),
    );
  }

  // --- CHAT FEED SECTION ---
  Widget _buildChatFeedSection() {
    return Column(
      children: [
        // Date Stamp
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Today, 15 May 2026',
            style: GoogleFonts.inter(fontSize: 9, color: AppTheme.secondaryGrey, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        // Message 1 (Wali, Left)
        _buildChatBubble(
          avatarUrl: _waliAvatar,
          senderName: 'Haji Usman Ahmad (Wali)',
          messageText: 'Assalamu alaikum wa rahmatullah. Let us use this platform to get to know each other better with sincerity and respect. May Allah guide us to what is best.',
          time: '10:30 AM',
          bubbleBg: const Color(0xFFF4F6F9),
          titleColor: const Color(0xFF6A1B9A),
          isMe: false,
        ),
        const SizedBox(height: 12),
        // Message 2 (Groom, Right)
        _buildChatBubble(
          avatarUrl: _yusufAvatar,
          senderName: 'Yusuf Ahmad (Groom)',
          messageText: 'Wa alaikum assalam wa rahmatullah. Thank you Uncle. I pray Allah makes this a means of good for both our families.',
          time: '10:32 AM',
          bubbleBg: const Color(0xFFE8F5E9),
          titleColor: const Color(0xFF2E7D32),
          isMe: true,
          checkColor: const Color(0xFF2E7D32),
        ),
        const SizedBox(height: 12),
        // Message 3 (Bride, Right/Other)
        _buildChatBubble(
          avatarUrl: _aishaAvatar,
          senderName: 'Aisha Usman (Bride)',
          messageText: 'Wa alaikum assalam wa rahmatullah. Ameen. I appreciate this opportunity and I pray Allah guides us to what is good.',
          time: '10:34 AM',
          bubbleBg: const Color(0xFFFFEBEE),
          titleColor: const Color(0xFFC62828),
          isMe: true,
          checkColor: const Color(0xFFC62828),
        ),
        const SizedBox(height: 12),
        // Message 4 (Wali, Left)
        _buildChatBubble(
          avatarUrl: _waliAvatar,
          senderName: 'Haji Usman Ahmad (Wali)',
          messageText: 'Alhamdulillah. Please feel free to share about your background, family, goals and what you value in marriage.',
          time: '10:36 AM',
          bubbleBg: const Color(0xFFF4F6F9),
          titleColor: const Color(0xFF6A1B9A),
          isMe: false,
        ),
      ],
    );
  }

  Widget _buildChatBubble({
    required String avatarUrl,
    required String senderName,
    required String messageText,
    required String time,
    required Color bubbleBg,
    required Color titleColor,
    required bool isMe,
    Color? checkColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe) ...[
          CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 260),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bubbleBg,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  senderName,
                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: titleColor),
                ),
                const SizedBox(height: 4),
                Text(
                  messageText,
                  style: GoogleFonts.inter(fontSize: 11, color: AppTheme.darkCharcoal, height: 1.3),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Spacer(),
                    Text(
                      time,
                      style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                    ),
                    if (isMe && checkColor != null) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.done_all, size: 10, color: checkColor),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isMe) ...[
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ],
      ],
    );
  }

  // --- START A MEANINGFUL CONVERSATION ROW ---
  Widget _buildStartConversationPrompts() {
    final List<Map<String, dynamic>> prompts = [
      {'label': 'Share your goals for marriage', 'icon': Icons.track_changes_outlined},
      {'label': 'Tell us about your family', 'icon': Icons.family_restroom_outlined},
      {'label': 'What are your hobbies?', 'icon': Icons.favorite_border},
      {'label': 'What do you value most in a spouse?', 'icon': Icons.grade_outlined},
      {'label': 'How do you spend your free time?', 'icon': Icons.hourglass_empty},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start a meaningful conversation',
          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: prompts.map((prompt) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black.withAlpha(8), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(prompt['icon'], size: 12, color: AppTheme.primaryGreen),
                    const SizedBox(width: 6),
                    Text(
                      prompt['label'],
                      style: GoogleFonts.inter(fontSize: 9, color: AppTheme.darkCharcoal),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // --- INPUT COMPOSER ---
  Widget _buildInputComposer() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF1F3F0),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: AppTheme.darkCharcoal, size: 20),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F0),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: GoogleFonts.inter(fontSize: 12, color: AppTheme.secondaryGrey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(bottom: 4),
                        ),
                      ),
                    ),
                    const Icon(Icons.mic_none_outlined, color: AppTheme.secondaryGrey, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF042415),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Message sent under Wali supervision.', style: GoogleFonts.inter()),
                        backgroundColor: AppTheme.primaryGreen,
                      ),
                    );
                    _messageController.clear();
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 10, color: AppTheme.secondaryGrey),
            const SizedBox(width: 4),
            Text(
              'This is a supervised conversation. Messages are visible to all members.',
              style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
            ),
          ],
        ),
      ],
    );
  }

  // --- ACTIONS FOOTER (Meeting & Resources) ---
  Widget _buildActionsFooterSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Supervised Meeting Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            height: 128,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withAlpha(8), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppTheme.primaryGreen),
                    const SizedBox(width: 6),
                    Text(
                      'Next Step',
                      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.secondaryGrey),
                    ),
                  ],
                ),
                Text(
                  'Propose a Supervised Meeting',
                  style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
                Text(
                  'If you both agree, request a meeting with your families.',
                  style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey, height: 1.3),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push('/propose-meeting');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF042415),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Propose Meeting', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, size: 10, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Resources Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            height: 128,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withAlpha(8), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Resources',
                      style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                    Text(
                      'View all',
                      style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                    ),
                  ],
                ),
                _buildResourceRow(Icons.menu_book_outlined, 'How to have a successful Ta\'aruf', 'Read Article'),
                const Divider(height: 1),
                _buildResourceRow(Icons.favorite_border, 'Du\'a for a blessed marriage', 'Read Du\'a'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResourceRow(IconData icon, String title, String actionText) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppTheme.primaryGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                actionText,
                style: GoogleFonts.inter(fontSize: 7, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, size: 12, color: AppTheme.secondaryGrey),
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
          _buildNavItem(Icons.favorite_border, 'Matches', 1),
          _buildWaliChatButton(), // Highlighted Wali Chat selected
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
        } else if (index == 1) {
          context.push('/matches');
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
    // Green/gold active indicator state
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = 4;
        });
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
                color: const Color(0xFF0F3E22), // Highlighted deep green matching active
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD4AF37), width: 2), // Gold border for active
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
                color: Color(0xFFD4AF37), // Gold icon
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
