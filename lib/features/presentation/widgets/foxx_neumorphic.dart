import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';

/// Neumorphic-style card with selectable and pressed states.
/// Default: glassReplacement (white 45%)
/// Selected: sunglow
/// Pressed: ombre10
/// No shadow, no border
class FoxxNeumorphicCard extends StatefulWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? horizontalPadding;
  final double? verticalPadding;

  const FoxxNeumorphicCard({
    super.key,
    required this.child,
    this.isSelected = false,
    this.onTap,
    this.horizontalPadding,
    this.verticalPadding,
  });

  @override
  State<FoxxNeumorphicCard> createState() => _FoxxNeumorphicCardState();
}

class _FoxxNeumorphicCardState extends State<FoxxNeumorphicCard> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) => setState(() => _isPressed = true);
  void _handleTapUp(TapUpDetails details) => setState(() => _isPressed = false);
  void _handleTapCancel() => setState(() => _isPressed = false);

  Color get _backgroundColor {
    if (_isPressed) return AppColors.ombre10;
    if (widget.isSelected) return AppColors.sunglow;
    return AppColors.glassReplacement;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding ?? AppSpacing.s16,
          vertical: widget.verticalPadding ?? AppSpacing.s12,
        ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(AppSpacing.s16),
        ),
        child: widget.child,
      ),
    );
  }
}