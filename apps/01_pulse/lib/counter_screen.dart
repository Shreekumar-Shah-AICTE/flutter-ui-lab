import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen>
    with TickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _pulseController;
  late AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  void _increment() {
    HapticFeedback.lightImpact();
    setState(() => _counter++);
    _pulseController.forward(from: 0);
    _ringController.forward(from: 0);
  }

  void _decrement() {
    if (_counter <= 0) return;
    HapticFeedback.lightImpact();
    setState(() => _counter--);
    _pulseController.forward(from: 0);
  }

  void _reset() {
    HapticFeedback.heavyImpact();
    setState(() => _counter = 0);
    _pulseController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_counter % 100) / 100.0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            // Header
            Text(
              'PULSE',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceDim,
                letterSpacing: 6,
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
            const SizedBox(height: 8),
            Text(
              'Counter',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: AppColors.onSurface,
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
            const Spacer(),
            // Neumorphic dial
            Center(
              child: _buildDial(progress),
            ),
            const Spacer(),
            // Controls
            _buildControls(),
            const SizedBox(height: 48),
            // Reset
            GestureDetector(
              onLongPress: _reset,
              child: Text(
                'LONG PRESS TO RESET',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurfaceDim.withOpacity(0.4),
                  letterSpacing: 3,
                ),
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDial(double progress) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 +
            0.05 *
                Curves.elasticOut
                    .transform(_pulseController.value);
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: AppTokens.neumorphicLight,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Progress ring
            SizedBox(
              width: 220,
              height: 220,
              child: AnimatedBuilder(
                animation: _ringController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ProgressRingPainter(
                      progress: progress,
                      color: AppColors.accent,
                      strokeWidth: 3,
                    ),
                  );
                },
              ),
            ),
            // Counter number
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    '$_counter',
                    key: ValueKey(_counter),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                      letterSpacing: -2,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(_counter % 100)}/100',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: AppColors.onSurfaceDim,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          curve: Curves.easeOutCubic,
          duration: 800.ms,
        );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NeumorphicButton(
          icon: Icons.remove_rounded,
          onPressed: _decrement,
          size: 64,
        ),
        const SizedBox(width: 48),
        _NeumorphicButton(
          icon: Icons.add_rounded,
          onPressed: _increment,
          size: 80,
          isPrimary: true,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2);
  }
}

class _NeumorphicButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final bool isPrimary;

  const _NeumorphicButton({
    required this.icon,
    required this.onPressed,
    this.size = 64,
    this.isPrimary = false,
  });

  @override
  State<_NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<_NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.isPrimary && !_isPressed
              ? AppColors.accent
              : AppColors.surface,
          shape: BoxShape.circle,
          boxShadow:
              _isPressed ? AppTokens.neumorphicPressed : AppTokens.neumorphicLight,
        ),
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Icon(
            widget.icon,
            size: widget.size * 0.4,
            color: widget.isPrimary && !_isPressed
                ? Colors.white
                : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final bgPaint = Paint()
      ..color = color.withOpacity(0.08)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0) {
      final fgPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) => builder(context, child);

  Animation<double> get animation => listenable as Animation<double>;
}
