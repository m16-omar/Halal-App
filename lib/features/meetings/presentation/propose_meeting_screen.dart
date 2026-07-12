import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';

class ProposeMeetingScreen extends ConsumerStatefulWidget {
  const ProposeMeetingScreen({super.key});

  @override
  ConsumerState<ProposeMeetingScreen> createState() => _ProposeMeetingScreenState();
}

class _ProposeMeetingScreenState extends ConsumerState<ProposeMeetingScreen> {
  int _currentIndex = 4; // Wali Chat active tab
  int _selectedPurpose = 0;
  int _selectedType = 0; // 0: Virtual, 1: In-Person
  final TextEditingController _notesController = TextEditingController();

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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildParticipantsProgressCard(),
                      const SizedBox(height: 20),
                      _buildMeetingPurposeSection(),
                      const SizedBox(height: 20),
                      _buildMeetingTypeSection(),
                      const SizedBox(height: 20),
                      _buildDateTimePickerSection(),
                      const SizedBox(height: 20),
                      _buildLocationSection(),
                      const SizedBox(height: 20),
                      _buildNotesSection(),
                      const SizedBox(height: 20),
                      _buildNextStepsAndReminderSection(),
                      const SizedBox(height: 20),
                      _buildSendRequestButton(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.darkCharcoal, size: 24),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Propose a Meeting',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkCharcoal,
                    ),
                  ),
                  Text(
                    'With Wali Supervision',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.secondaryGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Meeting Guidelines button
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFECB3), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu_book_outlined, size: 14, color: Color(0xFFB78103)),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meeting Guidelines',
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF8D6E63)),
                      ),
                      Text(
                        'Read before proposing',
                        style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right, size: 12, color: AppTheme.secondaryGrey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- PARTICIPANTS & PROGRESS CARD ---
  Widget _buildParticipantsProgressCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(8), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: User Connections Stepper
          Expanded(
            flex: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepperAvatar(_yusufAvatar, 'Yusuf Ahmad', 'Groom'),
                _buildStepperDottedLine(),
                _buildStepperAvatar(_aishaAvatar, 'Aisha Usman', 'Bride'),
                _buildStepperDottedLine(),
                _buildStepperAvatar(_waliAvatar, 'Haji Usman Ahmad', 'Wali (Father)'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const SizedBox(
            height: 50,
            child: VerticalDivider(width: 1, thickness: 1),
          ),
          const SizedBox(width: 8),
          // Right: Progress Stepper Summary
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conversation Progress',
                  style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: const LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Color(0xFFF1F3F0),
                    color: Color(0xFF10B981),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Step 2 of 4',
                  style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
                ),
                Text(
                  'Meeting',
                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperAvatar(String avatarUrl, String name, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(height: 4),
        Text(
          name.split(' ')[0],
          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F0),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildStepperDottedLine() {
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4, bottom: 20),
      width: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
          );
        }),
      ),
    );
  }

  // --- MEETING PURPOSE ---
  Widget _buildMeetingPurposeSection() {
    final List<Map<String, dynamic>> purposes = [
      {'title': 'Getting to know each other', 'subtitle': 'Discuss compatibility', 'icon': Icons.people_outline},
      {'title': 'Discuss marriage intention', 'subtitle': 'Discuss compatibility', 'icon': Icons.favorite_border}, // Matches screenshot
      {'title': 'Family introduction meeting', 'subtitle': 'Discuss compatibility', 'icon': Icons.group_add_outlined},
      {'title': 'Other', 'subtitle': '(Please specify)', 'icon': Icons.chat_bubble_outline},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meeting Purpose',
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        Text(
          'What is the purpose of this meeting?',
          style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: purposes.length,
          itemBuilder: (context, index) {
            bool isSelected = _selectedPurpose == index;
            final purpose = purposes[index];
            return GestureDetector(
              onTap: () => setState(() => _selectedPurpose = index),
              child: Container(
                padding: const EdgeInsets.all(12),
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryGreen : Colors.black12,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(purpose['icon'], size: 16, color: isSelected ? AppTheme.primaryGreen : AppTheme.secondaryGrey),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              purpose['title'],
                              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                            ),
                          ),
                          Text(
                            purpose['subtitle'],
                            style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryGreen : Colors.black26,
                          width: isSelected ? 3.5 : 1,
                        ),
                      ),
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

  // --- MEETING TYPE ---
  Widget _buildMeetingTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meeting Type',
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        Text(
          'Choose how you would like to meet',
          style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                index: 0,
                icon: Icons.videocam_outlined,
                title: 'Virtual Meeting',
                desc: 'Online video meeting\nvia secure platform',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeCard(
                index: 1,
                icon: Icons.people_outline,
                title: 'In-Person Meeting',
                desc: 'At a public place\nwith wali present',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Supervision Warning banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.security_outlined, size: 14, color: Color(0xFF2E7D32)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'All meetings are supervised by the Wali. Private meetings are not allowed.',
                  style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF2E7D32)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCard({required int index, required IconData icon, required String title, required String desc}) {
    bool isSelected = _selectedType == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 68,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.black12,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: isSelected ? AppTheme.primaryGreen : AppTheme.secondaryGrey),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                  ),
                  Text(
                    desc,
                    style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey, height: 1.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DATETIME SELECTOR ---
  Widget _buildDateTimePickerSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Preferred Date', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal)),
                  const SizedBox(height: 6),
                  _buildDropdownSelectCard(Icons.calendar_today_outlined, 'Select a date', 'Tue, 20 May 2026'),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Preferred Time', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal)),
                  const SizedBox(height: 6),
                  _buildDropdownSelectCard(Icons.access_time_outlined, 'Select a time', '04:00 PM'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildDropdownSelectCard(Icons.public, 'Time Zone', 'West Africa Time (WAT)'),
      ],
    );
  }

  Widget _buildDropdownSelectCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 7, color: AppTheme.secondaryGrey),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 14, color: AppTheme.secondaryGrey),
        ],
      ),
    );
  }

  // --- LOCATION SELECTOR (for in-person) ---
  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meeting Location (for in-person)',
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        Text(
          'Choose a public and appropriate location',
          style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
        ),
        const SizedBox(height: 10),
        _buildDropdownSelectCard(Icons.location_on_outlined, 'Select a location', 'City Central Mosque, Minna, Niger State'),
        const SizedBox(height: 8),
        // Recommended banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withAlpha(8), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                child: const Icon(Icons.mosque_outlined, color: Color(0xFF2E7D32), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Recommended places: Mosques, Islamic Centers, Community Centers, or other public places.',
                  style: GoogleFonts.inter(fontSize: 9, color: AppTheme.secondaryGrey, height: 1.3),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGreen,
                  side: const BorderSide(color: AppTheme.primaryGreen, width: 1),
                  minimumSize: const Size(120, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Text(
                  'View Recommendations',
                  style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- ADDITIONAL NOTES ---
  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Notes (Optional)',
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _notesController,
                maxLines: 3,
                maxLength: 250,
                decoration: InputDecoration(
                  hintText: 'Add any additional information...',
                  hintStyle: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryGrey),
                  border: InputBorder.none,
                  counterText: '', // Hide default counter
                ),
                onChanged: (text) => setState(() {}),
              ),
              Text(
                '${_notesController.text.length}/250',
                style: GoogleFonts.inter(fontSize: 9, color: AppTheme.secondaryGrey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- NEXT STEPS AND REMINDER ---
  Widget _buildNextStepsAndReminderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // What happens next
        Expanded(
          flex: 11,
          child: Container(
            padding: const EdgeInsets.all(12),
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withAlpha(8), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'What happens next?',
                  style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                ),
                _buildNextStepRow('Your Wali will review and approve the meeting.'),
                _buildNextStepRow('All participants will be notified.'),
                _buildNextStepRow('Meeting details will be confirmed.'),
                _buildNextStepRow('Remember to make du\'a for a blessed outcome.'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Islamic Reminder
        Expanded(
          flex: 9,
          child: Container(
            padding: const EdgeInsets.all(12),
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5F5).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFF7B1FA2), shape: BoxShape.circle),
                  child: const Icon(Icons.auto_stories_outlined, color: Colors.white, size: 12),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Islamic Reminder',
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF7B1FA2)),
                      ),
                      const SizedBox(height: 2),
                      Expanded(
                        child: Text(
                          '"And among His signs is that He created for you from yourselves spouses that you may find tranquility in them."',
                          style: GoogleFonts.inter(fontSize: 7, color: AppTheme.darkCharcoal, height: 1.3, fontStyle: FontStyle.italic),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '– Qur\'an 30:21',
                        style: GoogleFonts.inter(fontSize: 6, fontWeight: FontWeight.bold, color: AppTheme.secondaryGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextStepRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, size: 10, color: Color(0xFF10B981)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey, height: 1.2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // --- SEND MEETING REQUEST BUTTON ---
  Widget _buildSendRequestButton() {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Meeting request sent to your Wali for approval.', style: GoogleFonts.inter()),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        context.pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF042415),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                'Send Meeting Request',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Request will be sent to your Wali for approval',
            style: GoogleFonts.inter(fontSize: 9, color: Colors.white60),
          ),
        ],
      ),
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
                color: const Color(0xFF0F3E22),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD4AF37), width: 2),
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
                color: Color(0xFFD4AF37),
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
