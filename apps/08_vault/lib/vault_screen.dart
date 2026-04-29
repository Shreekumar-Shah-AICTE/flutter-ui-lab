import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:design_system/design_system.dart';

class VaultScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final bool isDark;
  final ValueChanged<bool> onThemeToggle;
  const VaultScreen({super.key, required this.prefs, required this.isDark, required this.onThemeToggle});
  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  late TextEditingController _nameCtrl;
  late bool _notifications;
  late String _language;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.prefs.getString('username') ?? '');
    _notifications = widget.prefs.getBool('notifications') ?? true;
    _language = widget.prefs.getString('language') ?? 'English';
  }

  void _saveName(String name) {
    widget.prefs.setString('username', name);
    setState(() {});
  }

  void _toggleNotifications(bool val) {
    HapticFeedback.selectionClick();
    setState(() => _notifications = val);
    widget.prefs.setBool('notifications', val);
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Clear All Data?', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: Text('This will reset all saved preferences.', style: GoogleFonts.plusJakartaSans()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              widget.prefs.clear();
              _nameCtrl.clear();
              setState(() { _notifications = true; _language = 'English'; });
              widget.onThemeToggle(false);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('All data cleared', style: GoogleFonts.plusJakartaSans()),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ));
            },
            child: Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _nameCtrl.text.isNotEmpty ? 'Hello, ${_nameCtrl.text}' : 'Hello, User';
    final isDark = widget.isDark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('VAULT', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: isDark ? AppColors.darkOnSurfaceDim : AppColors.onSurfaceDim, letterSpacing: 6))
                  .animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 4),
              Text(greeting, style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800))
                  .animate().fadeIn(duration: 400.ms, delay: 50.ms),
              const SizedBox(height: 4),
              Text('Your preferences are saved automatically.', style: GoogleFonts.plusJakartaSans(fontSize: 14, color: isDark ? AppColors.darkOnSurfaceDim : AppColors.onSurfaceDim))
                  .animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 28),

              _sectionLabel('Profile'),
              _buildTile(
                icon: Icons.person_outline_rounded,
                child: TextField(
                  controller: _nameCtrl,
                  onChanged: _saveName,
                  style: GoogleFonts.plusJakartaSans(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _sectionLabel('Appearance'),
              _buildTile(
                icon: Icons.dark_mode_rounded,
                title: 'Dark Mode',
                trailing: Switch(
                  value: isDark,
                  onChanged: (v) { HapticFeedback.selectionClick(); widget.onThemeToggle(v); },
                  activeColor: isDark ? AppColors.darkAccent : AppColors.accent,
                ),
              ),
              const SizedBox(height: 20),

              _sectionLabel('Preferences'),
              _buildTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                trailing: Switch(value: _notifications, onChanged: _toggleNotifications, activeColor: isDark ? AppColors.darkAccent : AppColors.accent),
              ),
              const SizedBox(height: 8),
              _buildTile(
                icon: Icons.language_rounded,
                title: 'Language',
                trailing: Text(_language, style: GoogleFonts.plusJakartaSans(fontSize: 14, color: isDark ? AppColors.darkOnSurfaceDim : AppColors.onSurfaceDim)),
              ),
              const SizedBox(height: 32),

              Center(
                child: TextButton.icon(
                  onPressed: _clearAll,
                  icon: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                  label: Text('Clear All Data', style: GoogleFonts.plusJakartaSans(color: AppColors.error, fontWeight: FontWeight.w500)),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(text, style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w500, color: widget.isDark ? AppColors.darkOnSurfaceDim : AppColors.onSurfaceDim, letterSpacing: 2)),
    );
  }

  Widget _buildTile({required IconData icon, String? title, Widget? child, Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkSurfaceAlt : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: widget.isDark ? AppColors.darkOnSurfaceDim : AppColors.onSurfaceDim),
          const SizedBox(width: 14),
          if (title != null) Expanded(child: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 15)))
          else if (child != null) Expanded(child: child),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
