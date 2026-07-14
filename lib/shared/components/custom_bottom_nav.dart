import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      color: const Color(0xFF04140C),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _buildNavItem(
              context,
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
              'Home',
              0,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              context,
              currentIndex == 1 ? Icons.favorite : Icons.favorite_border,
              'Matches',
              1,
            ),
          ),
          Expanded(
            child: _buildWaliChatButton(context),
          ),
          Expanded(
            child: _buildNavItem(
              context,
              currentIndex == 3 ? Icons.supervisor_account : Icons.supervisor_account_outlined,
              'Counseling',
              3,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              context,
              currentIndex == 4 ? Icons.person : Icons.person_outline,
              'Profile',
              4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (isSelected) return;
        _navigate(context, index);
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
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
      ),
    );
  }

  Widget _buildWaliChatButton(BuildContext context) {
    bool isSelected = currentIndex == 2;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (isSelected) return;
        _navigate(context, 2);
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -6),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F3E22) : const Color(0xFFD4AF37),
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: const Color(0xFFD4AF37), width: 2) : null,
                  boxShadow: !isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFD4AF37).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
                ),
                child: Icon(
                  Icons.people_alt,
                  color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF04140C),
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
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/matches');
        break;
      case 2:
        context.go('/wali-chat');
        break;
      case 3:
        context.go('/counseling');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}
