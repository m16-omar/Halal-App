import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_theme.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  String? _selectedRole;

  void _onRoleSelected(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _onContinue() {
    if (_selectedRole == 'seeker') {
      context.push('/seeker-setup');
    } else {
      String roleName = _selectedRole == 'wali' ? 'Wali (Guardian)' : 'Imam / Counselor';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$roleName portal is currently in mock state. Directing to seeker setup for testing.',
            style: GoogleFonts.inter(),
          ),
          action: SnackBarAction(
            label: 'Proceed',
            onPressed: () {
              context.push('/seeker-setup');
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkCharcoal),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is your role?',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 28,
                          color: AppTheme.primaryGreen,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select the role that represents your purpose on the platform today.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.secondaryGrey,
                        ),
                  ),
                  const SizedBox(height: 32),
                  _buildRoleCard(
                    context: context,
                    roleId: 'seeker',
                    title: 'I am a Seeker (Groom/Bride)',
                    description: 'I want to create a marriage profile and discover compatible candidates guided by Quran & Sunnah.',
                    icon: Icons.person_search_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildRoleCard(
                    context: context,
                    roleId: 'wali',
                    title: 'I am a Wali (Guardian)',
                    description: 'I want to supervise, chaperone, and support my ward/daughter in her matrimonial search.',
                    icon: Icons.supervisor_account_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildRoleCard(
                    context: context,
                    roleId: 'imam',
                    title: 'I am an Imam / Counselor',
                    description: 'I am a mosque leader verifying applicant references and conducting premarital counseling.',
                    icon: Icons.mosque_outlined,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ElevatedButton(
                  onPressed: _selectedRole != null ? _onContinue : null,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String roleId,
    required String title,
    required String description,
    required IconData icon,
  }) {
    bool isSelected = _selectedRole == roleId;
    return GestureDetector(
      onTap: () => _onRoleSelected(roleId),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen.withAlpha(20) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.secondaryGrey.withAlpha(51),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryGreen : AppTheme.softCream,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.primaryGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.darkCharcoal,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryGrey,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
