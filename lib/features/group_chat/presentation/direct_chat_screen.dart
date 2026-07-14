import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class DirectChatScreen extends StatefulWidget {
  final Map<String, dynamic>? candidateData;

  const DirectChatScreen({super.key, this.candidateData});

  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {
  late Map<String, dynamic> candidate;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showSafetyBanner = true;

  late List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    // Default to Aisha Usman if no dynamic data is passed
    candidate = widget.candidateData ?? {
      'name': 'Aisha Usman',
      'img': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80',
    };

    _messages = [
      {
        'sender': 'them',
        'text': 'Assalamu alaikum,\nThank you for accepting my request.\nI\'d love to get to know you better, In sha Allah.',
        'time': '9:30 AM',
        'reaction': null,
      },
      {
        'sender': 'me',
        'text': 'Wa alaikum assalam warahmatullah,\nThank you too. I\'m happy we matched.\nIt\'s nice to meet you, In sha Allah.',
        'time': '9:33 AM',
        'reaction': null,
      },
      {
        'sender': 'them',
        'text': 'Alhamdulillah.\nCan you tell me more about yourself\nand what you\'re looking for?',
        'time': '9:36 AM',
        'reaction': null,
      },
      {
        'sender': 'me',
        'text': 'Sure, I\'m looking for a God-fearing partner\nto build a peaceful and happy home with.\nWhat about you?',
        'time': '9:38 AM',
        'reaction': null,
      },
      {
        'sender': 'them',
        'text': 'That\'s beautiful, Masha Allah.\nI\'m also looking for the same.\nLet\'s get to know each other better, In sha Allah.',
        'time': '9:40 AM',
        'reaction': '❤️',
      },
      {
        'sender': 'me',
        'text': 'Ameen 🤲',
        'time': '9:41 AM',
        'reaction': null,
      },
    ];
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMsgText = _messageController.text;
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

    setState(() {
      _messages.add({
        'sender': 'me',
        'text': newMsgText,
        'time': timeStr,
        'reaction': null,
      });
      _messageController.clear();
    });

    _scrollToBottom();

    // Trigger mock auto-reply for interactivity
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'them',
            'text': 'Barakallahu feekum. May Allah make our intentions pure and guide us to what is best.',
            'time': timeStr,
            'reaction': null,
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String imageLink = candidate['img'] ?? 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80';

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
        title: Row(
          children: [
            // Avatar
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageLink,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            // Name details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        candidate['name'] ?? 'Aisha Usman',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkCharcoal,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, size: 12, color: Color(0xFF10B981)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Online',
                    style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF10B981), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
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
              icon: const Icon(Icons.shield_outlined, color: AppTheme.darkCharcoal, size: 16),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: IconButton(
              icon: const Icon(Icons.phone_outlined, color: AppTheme.darkCharcoal, size: 16),
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
              icon: const Icon(Icons.more_horiz, color: AppTheme.darkCharcoal, size: 16),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Safety Banner
          if (_showSafetyBanner) _buildSafetyBanner(),
          // Feed Chat messages
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAF6),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildDateSeparator('Today');
                  }
                  final msg = _messages[index - 1];
                  return _buildMessageBubble(msg, imageLink);
                },
              ),
            ),
          ),
          // Composer row
          _buildMessageComposer(),
          // Custom Bottom Navigation Bar
          const CustomBottomNav(currentIndex: 1),
        ],
      ),
    );
  }

  // 1. SAFETY BANNER
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(fontSize: 10, color: AppTheme.darkCharcoal, height: 1.4),
                    children: [
                      const TextSpan(text: 'Remember to keep the conversation respectful. ', style: TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: 'Our community guidelines help us build a safe space for everyone. '),
                      TextSpan(
                        text: 'Learn more',
                        style: GoogleFonts.inter(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ],
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

  // 2. DATE SEPARATOR
  Widget _buildDateSeparator(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[200], thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 9, color: AppTheme.secondaryGrey, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[200], thickness: 1)),
        ],
      ),
    );
  }

  // 3. MESSAGE BUBBLE
  Widget _buildMessageBubble(Map<String, dynamic> msg, String avatarUrl) {
    bool isMe = msg['sender'] == 'me';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side avatar for other sender
          if (!isMe) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                avatarUrl,
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
          ],
          // Bubble details
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFFE8F5E9) : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                          bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        msg['text'],
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.darkCharcoal,
                          height: 1.4,
                        ),
                      ),
                    ),
                    // Message bubble Emoji Reaction
                    if (msg['reaction'] != null)
                      Positioned(
                        bottom: -10,
                        right: isMe ? null : -8,
                        left: isMe ? -8 : null,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3),
                            ],
                          ),
                          child: Text(
                            msg['reaction'],
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                // Time & Status indicator row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg['time'],
                      style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.done_all, size: 10, color: Color(0xFF10B981)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4. MESSAGE INPUT COMPOSER
  Widget _buildMessageComposer() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Emoji, Input text box, Attachment & Voice
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAF6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sentiment_satisfied_alt_outlined, color: AppTheme.secondaryGrey, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.inter(fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: AppTheme.secondaryGrey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.image_outlined, color: AppTheme.secondaryGrey, size: 20),
                  const SizedBox(width: 10),
                  const Icon(Icons.mic_none_outlined, color: AppTheme.secondaryGrey, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send Button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF042415),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
