import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _step = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _enrollCtrl = TextEditingController();
  String _branch = 'BCA';
  int _semester = 1;
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _enrollCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 2) {
      if (_formKey.currentState!.validate()) {
        setState(() => _step++);
      }
    } else {
      setState(() => _submitted = true);
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildSuccess();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ENROLL', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.onSurfaceDim, letterSpacing: 6))
                  .animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 4),
              Text('Student Registration', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.onSurface))
                  .animate().fadeIn(duration: 400.ms, delay: 50.ms),
              const SizedBox(height: 24),
              _buildProgressBar(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['Personal Info', 'Academic', 'Review'].asMap().entries.map((e) =>
                  Text(e.value, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: e.key == _step ? FontWeight.w600 : FontWeight.w400, color: e.key == _step ? AppColors.accent : AppColors.onSurfaceDim))
                ).toList(),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _step == 0 ? _buildStep1() : _step == 1 ? _buildStep2() : _buildStep3(),
                  ),
                ),
              ),
              Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _back,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: BorderSide(color: AppColors.border),
                        ),
                        child: Text('Back', style: GoogleFonts.plusJakartaSans(color: AppColors.onSurface)),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(_step == 2 ? 'Submit' : 'Continue'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 4,
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(2)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (_step + 1) / 3,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2)),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      key: const ValueKey('step1'),
      child: Column(
        children: [
          _field(_nameCtrl, 'Full Name', Icons.person_outline_rounded, validator: (v) => v!.isEmpty ? 'Name is required' : null),
          const SizedBox(height: 16),
          _field(_emailCtrl, 'Email Address', Icons.mail_outline_rounded, keyboard: TextInputType.emailAddress, validator: (v) {
            if (v!.isEmpty) return 'Email is required';
            if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
            return null;
          }),
          const SizedBox(height: 16),
          _field(_phoneCtrl, 'Phone Number', Icons.phone_outlined, keyboard: TextInputType.phone, validator: (v) {
            if (v!.isEmpty) return 'Phone is required';
            if (v.length < 10) return 'Enter a valid phone number';
            return null;
          }),
        ].asMap().entries.map((e) => e.value.animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: e.key * 80)).slideX(begin: 0.05)).toList(),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      key: const ValueKey('step2'),
      child: Column(
        children: [
          _field(_enrollCtrl, 'Enrollment Number', Icons.badge_outlined, validator: (v) => v!.isEmpty ? 'Enrollment number is required' : null)
              .animate().fadeIn(duration: 400.ms).slideX(begin: 0.05),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: DropdownButtonFormField<String>(
              value: _branch,
              decoration: const InputDecoration(border: InputBorder.none, labelText: 'Branch'),
              items: ['BCA', 'BBA', 'B.Com', 'B.Sc IT', 'MCA'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
              onChanged: (v) => setState(() => _branch = v!),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 80.ms).slideX(begin: 0.05),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                Icon(Icons.school_outlined, color: AppColors.onSurfaceDim, size: 20),
                const SizedBox(width: 12),
                Text('Semester', style: GoogleFonts.plusJakartaSans(fontSize: 15, color: AppColors.onSurfaceDim)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.remove_circle_outline, size: 22), onPressed: () { if (_semester > 1) setState(() => _semester--); }),
                Text('$_semester', style: GoogleFonts.jetBrainsMono(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.accent)),
                IconButton(icon: const Icon(Icons.add_circle_outline, size: 22), onPressed: () { if (_semester < 8) setState(() => _semester++); }),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 160.ms).slideX(begin: 0.05),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      key: const ValueKey('step3'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Review Your Details', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
            const SizedBox(height: 16),
            _reviewRow('Name', _nameCtrl.text),
            _reviewRow('Email', _emailCtrl.text),
            _reviewRow('Phone', _phoneCtrl.text),
            _reviewRow('Enrollment', _enrollCtrl.text),
            _reviewRow('Branch', _branch),
            _reviewRow('Semester', '$_semester'),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95)),
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.onSurfaceDim))),
          Expanded(child: Text(value.isEmpty ? '—' : value, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.onSurface))),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.check_rounded, size: 40, color: AppColors.success),
            ).animate().scale(begin: const Offset(0, 0), curve: Curves.elasticOut, duration: 800.ms),
            const SizedBox(height: 24),
            Text('Registration Complete!', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.onSurface))
                .animate().fadeIn(duration: 500.ms, delay: 300.ms),
            const SizedBox(height: 8),
            Text('Welcome, ${_nameCtrl.text}', style: GoogleFonts.plusJakartaSans(fontSize: 15, color: AppColors.onSurfaceDim))
                .animate().fadeIn(duration: 500.ms, delay: 400.ms),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => setState(() { _submitted = false; _step = 0; }),
              child: const Text('Register Another'),
            ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {TextInputType? keyboard, String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      validator: validator,
      style: GoogleFonts.plusJakartaSans(fontSize: 15),
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20)),
    );
  }
}
