import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double _firstOperand = 0;
  String _operator = '';
  bool _shouldReset = false;

  void _onDigit(String digit) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_display == '0' || _shouldReset) {
        _display = digit;
        _shouldReset = false;
      } else if (_display.length < 12) {
        _display += digit;
      }
    });
  }

  void _onDecimal() {
    HapticFeedback.selectionClick();
    if (_shouldReset) {
      setState(() {
        _display = '0.';
        _shouldReset = false;
      });
      return;
    }
    if (!_display.contains('.')) {
      setState(() => _display += '.');
    }
  }

  void _onOperator(String op) {
    HapticFeedback.lightImpact();
    setState(() {
      _firstOperand = double.tryParse(_display) ?? 0;
      _operator = op;
      _expression = '$_display $op';
      _shouldReset = true;
    });
  }

  void _onEquals() {
    HapticFeedback.mediumImpact();
    if (_operator.isEmpty) return;
    final second = double.tryParse(_display) ?? 0;
    double result = 0;

    setState(() {
      switch (_operator) {
        case '+':
          result = _firstOperand + second;
          break;
        case '\u2212':
          result = _firstOperand - second;
          break;
        case '\u00D7':
          result = _firstOperand * second;
          break;
        case '\u00F7':
          if (second == 0) {
            _display = '\u221E \u2014 nice try.';
            _expression = '';
            _operator = '';
            _shouldReset = true;
            return;
          }
          result = _firstOperand / second;
          break;
      }

      if (result == result.toInt().toDouble()) {
        _display = result.toInt().toString();
      } else {
        _display = result.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      }
      _expression = '';
      _operator = '';
      _shouldReset = true;
    });
  }

  void _onClear() {
    HapticFeedback.heavyImpact();
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = 0;
      _operator = '';
      _shouldReset = false;
    });
  }

  void _onBackspace() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _onPercent() {
    HapticFeedback.selectionClick();
    final val = double.tryParse(_display) ?? 0;
    setState(() {
      final result = val / 100;
      _display = result.toString();
      _shouldReset = true;
    });
  }

  void _onNegate() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else if (_display != '0') {
        _display = '-$_display';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Label
            Text(
              'CALC.NOIR',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.darkOnSurfaceDim.withOpacity(0.3),
                letterSpacing: 6,
              ),
            ).animate().fadeIn(duration: 600.ms),
            const Spacer(),
            // Display
            _buildDisplay(),
            const SizedBox(height: 24),
            // Button grid
            _buildButtonGrid(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_expression.isNotEmpty)
            Text(
              _expression,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                color: AppColors.darkOnSurfaceDim.withOpacity(0.4),
              ),
            ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _display,
              key: ValueKey(_display),
              textAlign: TextAlign.right,
              maxLines: 1,
              style: GoogleFonts.jetBrainsMono(
                fontSize: _display.length > 8 ? 36 : 52,
                fontWeight: FontWeight.w300,
                color: AppColors.darkOnSurface,
                letterSpacing: -1,
                shadows: [
                  Shadow(
                    color: AppColors.darkAccent.withOpacity(0.15),
                    blurRadius: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildButtonGrid() {
    final buttons = [
      ['C', '\u00B1', '%', '\u00F7'],
      ['7', '8', '9', '\u00D7'],
      ['4', '5', '6', '\u2212'],
      ['1', '2', '3', '+'],
      ['\u232B', '0', '.', '='],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: buttons.asMap().entries.map((entry) {
          final rowIndex = entry.key;
          final row = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: row.asMap().entries.map((btnEntry) {
                final colIndex = btnEntry.key;
                final label = btnEntry.value;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _CalcButton(
                      label: label,
                      isOperator: _isOperator(label),
                      isEquals: label == '=',
                      isFunction: _isFunction(label),
                      onTap: () => _handleButton(label),
                    ),
                  ).animate().fadeIn(
                        duration: 400.ms,
                        delay: Duration(
                            milliseconds: (rowIndex * 4 + colIndex) * 30),
                      ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isOperator(String label) =>
      ['\u00F7', '\u00D7', '\u2212', '+'].contains(label);
  bool _isFunction(String label) => ['C', '\u00B1', '%', '\u232B'].contains(label);

  void _handleButton(String label) {
    switch (label) {
      case 'C':
        _onClear();
        break;
      case '\u00B1':
        _onNegate();
        break;
      case '%':
        _onPercent();
        break;
      case '\u232B':
        _onBackspace();
        break;
      case '.':
        _onDecimal();
        break;
      case '=':
        _onEquals();
        break;
      case '+':
      case '\u2212':
      case '\u00D7':
      case '\u00F7':
        _onOperator(label);
        break;
      default:
        _onDigit(label);
    }
  }
}

class _CalcButton extends StatefulWidget {
  final String label;
  final bool isOperator;
  final bool isEquals;
  final bool isFunction;
  final VoidCallback onTap;

  const _CalcButton({
    required this.label,
    required this.onTap,
    this.isOperator = false,
    this.isEquals = false,
    this.isFunction = false,
  });

  @override
  State<_CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<_CalcButton> {
  bool _pressed = false;

  Color get _bgColor {
    if (widget.isEquals) return AppColors.darkAccent;
    if (widget.isOperator) return AppColors.darkAccent.withOpacity(0.12);
    if (widget.isFunction) return const Color(0xFF1E1E1E);
    return const Color(0xFF161616);
  }

  Color get _textColor {
    if (widget.isEquals) return Colors.white;
    if (widget.isOperator) return AppColors.darkAccent;
    if (widget.isFunction) return AppColors.darkOnSurfaceDim;
    return AppColors.darkOnSurface;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 64,
          decoration: BoxDecoration(
            color: _pressed ? _bgColor.withOpacity(0.7) : _bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: widget.isEquals ? 24 : 20,
              fontWeight:
                  widget.isEquals ? FontWeight.w700 : FontWeight.w400,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }
}
