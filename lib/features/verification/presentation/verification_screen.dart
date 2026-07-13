import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_theme.dart';
import '../../authentication/presentation/auth_provider.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  bool _idUploaded = false;
  bool _selfieCaptured = false;
  final _mosqueRefController = TextEditingController();

  void _onUploadID() {
    setState(() {
      _idUploaded = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ID Document uploaded successfully.', style: GoogleFonts.inter()),
      ),
    );
  }

  void _onCaptureSelfie() {
    setState(() {
      _selfieCaptured = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selfie captured successfully.', style: GoogleFonts.inter()),
      ),
    );
  }

  Future<void> _onSubmit() async {
    final currentUser = ref.read(authProvider).user;
    if (currentUser != null && currentUser.id > 0) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryGreen,
          ),
        ),
      );

      final success = await ref.read(authProvider.notifier).submitVerification(
        seekerId: currentUser.id,
      );

      if (mounted) {
        Navigator.of(context).pop();
        if (success) {
          context.go('/home');
        } else {
          final error = ref.read(authProvider).errorMessage ?? 'Verification submission failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error, style: GoogleFonts.inter()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _mosqueRefController.dispose();
    super.dispose();
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified_user_outlined, color: AppTheme.accentGold, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Trust & Safety',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Identity Verification',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 28,
                          color: AppTheme.primaryGreen,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'To reduce fake profiles and protect the community, we verify identities before matchmaking starts.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.secondaryGrey,
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: 32),
                  _buildUploadCard(
                    title: 'Government-Issued ID',
                    subtitle: 'Upload NIN, Driver\'s License, or Passport',
                    isDone: _idUploaded,
                    onTap: _onUploadID,
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildUploadCard(
                    title: 'Live Selfie Capture',
                    subtitle: 'Match facial details with your ID card photo',
                    isDone: _selfieCaptured,
                    onTap: _onCaptureSelfie,
                    icon: Icons.face_retouching_natural_outlined,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Mosque Verification Reference (Optional)',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mosqueRefController,
                    decoration: const InputDecoration(
                      labelText: 'Registered Mosque Name / Imam Reference',
                      hintText: 'e.g. Minna Central Mosque',
                      prefixIcon: Icon(Icons.mosque_outlined),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: (_idUploaded && _selfieCaptured) ? _onSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_idUploaded && _selfieCaptured) ? AppTheme.accentGold : AppTheme.secondaryGrey.withAlpha(76),
                  foregroundColor: (_idUploaded && _selfieCaptured) ? AppTheme.primaryGreen : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: (_idUploaded && _selfieCaptured) ? AppTheme.primaryGreen : Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Submit Verification',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required bool isDone,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDone ? AppTheme.primaryGreen.withAlpha(20) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone ? AppTheme.primaryGreen : AppTheme.secondaryGrey.withAlpha(51),
            width: isDone ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDone ? AppTheme.primaryGreen : AppTheme.softCream,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDone ? Colors.white : AppTheme.primaryGreen,
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
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkCharcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.secondaryGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isDone ? Icons.check_circle : Icons.add_a_photo_outlined,
              color: isDone ? AppTheme.primaryGreen : AppTheme.secondaryGrey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
