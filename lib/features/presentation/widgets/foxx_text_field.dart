import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';

enum FoxxTextFieldState { defaultState, focus, typing, textEntered, error }
enum FoxxTextFieldBorder { borderLarge, borderDefault }
enum FoxxTextFieldSize { singleLine, multiLine }

class FoxxTextField extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final FoxxTextFieldState fieldState;
  final FoxxTextFieldBorder borderVariant;
  final FoxxTextFieldSize size;
  final TextEditingController? controller;
  final bool isPassword;
  final bool showHighlight; // system-controlled highlight for multi-line
  final List<Widget>? rightIcons;
  final ValueChanged<String>? onChanged;

  const FoxxTextField({
    Key? key,
    required this.hintText,
    this.errorText,
    this.fieldState = FoxxTextFieldState.defaultState,
    this.borderVariant = FoxxTextFieldBorder.borderLarge,
    this.size = FoxxTextFieldSize.singleLine,
    this.controller,
    this.isPassword = false,
    this.showHighlight = false,
    this.rightIcons,
    this.onChanged,
  }) : super(key: key);

  @override
  State<FoxxTextField> createState() => _FoxxTextFieldState();
}

class _FoxxTextFieldState extends State<FoxxTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  bool get isMultiline => widget.size == FoxxTextFieldSize.multiLine;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  Color getBorderColor() {
    switch (widget.fieldState) {
      case FoxxTextFieldState.focus:
      case FoxxTextFieldState.typing:
        return AppColors.mauve;
      case FoxxTextFieldState.error:
        return AppColors.darkRed;
      case FoxxTextFieldState.defaultState:
      case FoxxTextFieldState.textEntered:
      default:
        return AppColors.gray200;
    }
  }

  BorderRadius getBorderRadius() {
    switch (widget.borderVariant) {
      case FoxxTextFieldBorder.borderDefault:
        return AppRadius.brSm;
      case FoxxTextFieldBorder.borderLarge:
      default:
        return AppRadius.brMd;
    }
  }

  Color getTextColor() {
    switch (widget.fieldState) {
      case FoxxTextFieldState.typing:
      case FoxxTextFieldState.textEntered:
        return AppColors.textPrimary;
      case FoxxTextFieldState.error:
      case FoxxTextFieldState.defaultState:
      case FoxxTextFieldState.focus:
      default:
        return AppColors.textInputPlaceholder;
    }
  }

  void clearText() {
    _controller.clear();
    widget.onChanged?.call('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool showClearButton =
        widget.fieldState == FoxxTextFieldState.typing &&
        _controller.text.isNotEmpty;

    final double minHeight = widget.size == FoxxTextFieldSize.multiLine
        ? AppSpacing.s80
        : AppSpacing.s52;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(minHeight: minHeight),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.sm,
          ),
          decoration: ShapeDecoration(
            color: AppColors.grayWhite,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: getBorderColor()),
              borderRadius: getBorderRadius(),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Focus indicator bar
              if (widget.fieldState == FoxxTextFieldState.focus ||
                  widget.fieldState == FoxxTextFieldState.typing)
                Container(
                  width: AppSpacing.s2,
                  height: AppSpacing.s16,
                  decoration: BoxDecoration(
                    color: AppColors.amethyst,
                    borderRadius: BorderRadius.circular(AppSpacing.s2),
                  ),
                ),
              if (widget.fieldState == FoxxTextFieldState.focus ||
                  widget.fieldState == FoxxTextFieldState.typing)
                SizedBox(width: AppSpacing.s8),

              // TextField area
              Expanded(
                child: Stack(
                  children: [
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      cursorColor: AppColors.amethyst,
                      style: AppTypography.labelMd.copyWith(
                        color: getTextColor(),
                      ),
                      maxLines: isMultiline ? null : 1,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: AppTypography.labelMd.copyWith(
                          color: AppColors.textInputPlaceholder,
                        ),
                      ),
                      onChanged: widget.onChanged,
                    ),

                    // Highlight layer (system-controlled)
                    if (isMultiline && widget.showHighlight)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.gray200,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Right-side icons
              if (showClearButton)
                GestureDetector(
                  onTap: clearText,
                  child: SvgPicture.asset(
                    'assets/svg/icons/circle-x-20.svg',
                    width: AppSpacing.s20,
                    height: AppSpacing.s20,
                  ),
                ),
              if (widget.rightIcons != null) ...widget.rightIcons!,
            ],
          ),
        ),

        // Error text
        if (widget.fieldState == FoxxTextFieldState.error &&
            widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(
              top: AppSpacing.s4,
              left: AppSpacing.s8,
            ),
            child: Text(
              widget.errorText!,
              style: AppTypography.labelXsSemibold.copyWith(
                color: AppColors.darkRed,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
          ),
      ],
    );
  }
}