import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';

class HeightInputScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final Function(Map<String, dynamic>)? onDataUpdate;
  final List<OnboardingQuestion>? questions;
  final Map<String, dynamic>? currentValue; // ✅ Previously entered height

  const HeightInputScreen({
    super.key,
    this.onNext,
    this.onDataUpdate,
    this.questions,
    this.currentValue,
  });

  @override
  State<HeightInputScreen> createState() => _HeightInputScreenState();
}

class _HeightInputScreenState extends State<HeightInputScreen> {
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();

  late final FocusNode _feetFocusNode;
  late final FocusNode _inchesFocusNode;

  @override
  void initState() {
    super.initState();
    _feetFocusNode = FocusNode();
    _inchesFocusNode = FocusNode();
    // ✅ Restore previous input if available
    if (widget.currentValue != null) {
      final feet = widget.currentValue!['feet']?.toString() ?? '';
      final inches = widget.currentValue!['inches']?.toString() ?? '';
      _feetController.text = feet;
      _inchesController.text = inches;
    }

    // Auto-focus feet field when screen loads
    Future.delayed(Duration.zero, () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_feetFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _feetController.dispose();
    _inchesController.dispose();
    _feetFocusNode.dispose();
    _inchesFocusNode.dispose();
    super.dispose();
  }

  bool hasTextInput() {
    return _feetController.text.isNotEmpty || _inchesController.text.isNotEmpty;
  }

  Map<String, dynamic>? getHeight() {
    if (_feetController.text.isEmpty) return null;
    final feet = int.tryParse(_feetController.text);
    final inches = int.tryParse(_inchesController.text) ?? 0;
    if (feet == null) return null;
    return {'feet': feet, 'inches': inches};
  }

  @override
  Widget build(BuildContext context) {
    final heightQuestion =
        OnboardingCubit().getQuestionByType(widget.questions ?? [], 'HEIGHT');

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.textBoxHorizontalWidget,
          0,
          AppSpacing.textBoxHorizontalWidget,
          AppSpacing.s24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnboardingQuestionHeader(
              questions: widget.questions ?? const [],
              questionType: 'HEIGHT',
              questionOverride:
                  heightQuestion == null ? 'How tall are you?' : null,
              descriptionOverride: heightQuestion == null
                  ? 'Your height helps us interpret symptom trends and offer more accurate support for your body.'
                  : null,
            ),

            const SizedBox(height: 12), // optional gap

            // 🧍‍♀️ Height Input Row
            Row(
              children: [
                Expanded(
                  child: FoxxTextField(
                    controller: _feetController,
                    focusNode: _feetFocusNode,
                    hintText: '0',
                    size: FoxxTextFieldSize.singleLine,
                    unitLabel: 'ft',
                    numericOnly: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    showClearButton: false,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FoxxTextField(
                    controller: _inchesController,
                    focusNode: _inchesFocusNode,
                    hintText: '0',
                    size: FoxxTextFieldSize.singleLine,
                    unitLabel: 'in',
                    numericOnly: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    showClearButton: false,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: FoxxNextButton(
                isEnabled: hasTextInput(),
                onPressed: () {
                  final height = getHeight();
                  if (height != null) {
                    widget.onDataUpdate?.call(height);
                  }
                  FocusScope.of(context).unfocus();
                  widget.onNext?.call();
                },
                text: 'Next',
              ),
            ),
          ],
        ),
      ),
    );
  }
}