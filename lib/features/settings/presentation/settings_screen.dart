import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;
  bool _matchAlerts = true;
  String _profileVisibility = 'Matches Only';

  @override
  Widget build(BuildContext context) {
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
          'Settings',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkCharcoal,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAF6),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // 1. ACCOUNT SETTINGS
                  _buildSectionHeader('Account Settings'),
                  _buildSettingsTile(
                    Icons.person_outline,
                    'Edit Profile Information',
                    subtitle: 'Update basic, lifestyle & family details',
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    Icons.mail_outline,
                    'Email & Phone Number',
                    subtitle: 'manage your contact details',
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    Icons.verified_user_outlined,
                    'Verification Status',
                    trailingWidget: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                      ),
                      child: Text(
                        'Premium Verified',
                        style: GoogleFonts.inter(fontSize: 8, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. MATCH PREFERENCES
                  _buildSectionHeader('Match Preferences'),
                  _buildSettingsTile(
                    Icons.tune,
                    'Partner Preferences',
                    subtitle: 'Refine location, education, religiosity preferences',
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    Icons.location_on_outlined,
                    'Discovery Radius',
                    subtitle: 'Set maximum match distance filters',
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),

                  // 3. NOTIFICATIONS
                  _buildSectionHeader('Notification Preferences'),
                  _buildSwitchTile(
                    Icons.notifications_active_outlined,
                    'Push Notifications',
                    'Get instant updates for matches & chats',
                    _pushNotifications,
                    (val) => setState(() => _pushNotifications = val),
                  ),
                  _buildSwitchTile(
                    Icons.favorite_border,
                    'Match Alerts',
                    'Notify me when a new match is found',
                    _matchAlerts,
                    (val) => setState(() => _matchAlerts = val),
                  ),
                  _buildSwitchTile(
                    Icons.email_outlined,
                    'Email Alerts',
                    'Weekly match digests and newsletters',
                    _emailAlerts,
                    (val) => setState(() => _emailAlerts = val),
                  ),
                  const SizedBox(height: 20),

                  // 4. PRIVACY & SECURITY
                  _buildSectionHeader('Privacy & Security'),
                  _buildDropdownTile(
                    Icons.lock_outline,
                    'Profile Visibility',
                    'Control who can see your profile card',
                    _profileVisibility,
                    ['Public', 'Matches Only', 'Private'],
                    (val) {
                      if (val != null) {
                        setState(() => _profileVisibility = val);
                      }
                    },
                  ),
                  _buildSettingsTile(
                    Icons.block_outlined,
                    'Blocked Users',
                    subtitle: 'Manage blocked profiles list',
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    Icons.security_outlined,
                    'Change Password',
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),

                  // 5. HELP & LEGAL
                  _buildSectionHeader('Help & Support'),
                  _buildSettingsTile(Icons.help_outline, 'Help Center / FAQs', onTap: () {}),
                  _buildSettingsTile(Icons.description_outlined, 'Terms of Service', onTap: () {}),
                  _buildSettingsTile(Icons.policy_outlined, 'Privacy Policy', onTap: () {}),
                  _buildSettingsTile(
                    Icons.info_outline,
                    'About Nupe Halal Connect',
                    trailingWidget: Text(
                      'v1.0.0',
                      style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 6. DANGER ZONE
                  _buildSectionHeader('Danger Zone'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[100]!),
                    ),
                    child: ListTile(
                      onTap: () {
                        // Account deletion warning confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Account', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                            content: Text(
                              'Are you absolutely sure you want to delete your account? This action is irreversible and all your match history will be lost.',
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.go('/login');
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                      title: Text(
                        'Permanently Delete Account',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.red, size: 16),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          const CustomBottomNav(currentIndex: 4), // Profile Settings
        ],
      ),
    );
  }

  // BUILD SECTION HEADER
  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, top: 4.0),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: AppTheme.secondaryGrey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // STANDARD TILE
  Widget _buildSettingsTile(IconData icon, String title, {String? subtitle, Widget? trailingWidget, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        leading: Icon(icon, color: AppTheme.darkCharcoal, size: 18),
        title: Text(
          title,
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
              )
            : null,
        trailing: trailingWidget ?? const Icon(Icons.chevron_right, color: AppTheme.secondaryGrey, size: 16),
      ),
    );
  }

  // SWITCH TILE
  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: AppTheme.darkCharcoal, size: 18),
        title: Text(
          title,
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: AppTheme.primaryGreen,
          inactiveThumbColor: Colors.grey[300],
          inactiveTrackColor: Colors.grey[200],
        ),
      ),
    );
  }

  // DROPDOWN TILE
  Widget _buildDropdownTile(IconData icon, String title, String subtitle, String currentValue, List<String> options, ValueChanged<String?> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: AppTheme.darkCharcoal, size: 18),
        title: Text(
          title,
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 8, color: AppTheme.secondaryGrey),
        ),
        trailing: DropdownButton<String>(
          value: currentValue,
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.secondaryGrey),
          style: GoogleFonts.inter(fontSize: 10, color: AppTheme.darkCharcoal, fontWeight: FontWeight.bold),
          items: options.map((opt) {
            return DropdownMenuItem(
              value: opt,
              child: Text(opt),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
