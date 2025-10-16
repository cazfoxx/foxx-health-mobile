import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';

enum FoxxTextFieldSize { singleLine, multiLine }

class FoxxTextField extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final FoxxTextFieldSize size;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool isPassword;
  final bool showHighlight;
  final bool showClearButton;
  final List<Widget>? rightIcons;
  final ValueChanged<String>? onChanged;
  final String? unitLabel;
  final TextInputType? keyboardType;
  final bool numericOnly;
  final List<TextInputFormatter>? inputFormatters;

  const FoxxTextField({
    Key? key,
    required this.hintText,
    this.errorText,
    this.size = FoxxTextFieldSize.singleLine,
    this.controller,
    this.focusNode,
    this.isPassword = false,
    this.showHighlight = false,
    this.showClearButton = true,
    this.rightIcons,
    this.onChanged,
    this.unitLabel,
    this.keyboardType,
    this.numericOnly = false,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<FoxxTextField> createState() => _FoxxTextFieldState();
}

class _FoxxTextFieldState extends State<FoxxTextField> {
  late FocusNode _internalFocusNode;
  late TextEditingController _controller;

  bool get isMultiline => widget.size == FoxxTextFieldSize.multiLine;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    _controller = widget.controller ?? TextEditingController();

    _focusNode.addListener(() {
      setState(() {}); // redraw on focus change
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _internalFocusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  Color getBorderColor() {
    if (widget.errorText != null) return AppColors.darkRed;
    if (_focusNode.hasFocus) return AppColors.mauve;
    return AppColors.gray200;
  }

  Color getTextColor() {
    if (widget.errorText != null) return AppColors.textError;
    if (_focusNode.hasFocus || _controller.text.isNotEmpty) {
      return AppColors.textPrimary;
    }
    return AppColors.textInputPlaceholder;
  }

  BorderRadius getBorderRadius() => BorderRadius.circular(16);

  void clearText() {
    _controller.clear();
    widget.onChanged?.call('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool canShowClearButton =
        widget.showClearButton && _controller.text.isNotEmpty && _focusNode.hasFocus;

    final double minHeight = isMultiline ? AppSpacing.s120 : AppSpacing.s52;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(minHeight: minHeight),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s20,
            vertical: AppSpacing.s16,
          ),
          decoration: ShapeDecoration(
            color: AppColors.grayWhite,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: getBorderColor()),
              borderRadius: getBorderRadius(),
            ),
          ),
          child: Row(
            crossAxisAlignment:
                isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      cursorColor: AppColors.amethyst,
                      style: AppTypography.labelMd.copyWith(color: getTextColor()),
                      maxLines: isMultiline ? null : 1,
                      obscureText: widget.isPassword,
                      keyboardType: widget.numericOnly
                          ? TextInputType.number
                          : widget.keyboardType ?? TextInputType.text,
                      inputFormatters: widget.numericOnly
                          ? [
                              FilteringTextInputFormatter.digitsOnly,
                              ...?widget.inputFormatters
                            ]
                          : widget.inputFormatters,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: AppTypography.labelMd.copyWith(
                          color: AppColors.textInputPlaceholder,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: widget.onChanged,
                    ),
                    if (isMultiline && widget.showHighlight)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColors.gray200, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              if (widget.unitLabel != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    widget.unitLabel!,
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

              if (canShowClearButton)
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

        // 4px vertical gap to error
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              widget.errorText!,
              style: AppTypography.labelSmSemibold.copyWith(
                color: AppColors.darkRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}