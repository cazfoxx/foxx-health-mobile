import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_selectable_option_card.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';

class HealthConcernsScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  final Function(Set<String>)? onDataUpdate;

  /// ✅ Optional: restore previous selection
  final Set<String>? currentValue;

  const HealthConcernsScreen({
    super.key,
    this.onNext,
    this.questions = const [],
    this.onDataUpdate,
    this.currentValue,
  });

  @override
  State<HealthConcernsScreen> createState() => _HealthConcernsScreenState();
}

class _HealthConcernsScreenState extends State<HealthConcernsScreen> {
  /// ✅ Multi-select answers
  final Set<String> _selectedAnswers = {};

  /// ✅ Self-describe controller and visibility
  final TextEditingController _selfDescribeController = TextEditingController();
  bool _showSelfDescribeField = false;

  /// 🔹 Remember previous self-describe text even if deselected
  String _tempSelfDescribeText = '';

  @override
  void initState() {
    super.initState();

    // ✅ Restore previous selections if provided
    if (widget.currentValue != null && widget.currentValue!.isNotEmpty) {
      _selectedAnswers.addAll(widget.currentValue!);

      // Check if any self-describe option exists
      final selfDescribe = _selectedAnswers.firstWhere(
        (s) => _isOtherLabel(s) || !_healthConcerns.contains(s),
        orElse: () => '',
      );
      if (selfDescribe.isNotEmpty) {
        _showSelfDescribeField = true;
        _selfDescribeController.text = selfDescribe;
        _tempSelfDescribeText = selfDescribe; // ✅ remember it
      }
    }
  }

  /// ✅ Check if label represents "Other/self-describe"
  bool _isOtherLabel(String label) {
    final l = label.toLowerCase();
    return l.contains('other') || l.contains('self describe') || l.contains('self-describe');
  }

  /// ✅ Fetch choices from API with fallback; ensure self-describe available in fallback
  List<String> get _healthConcerns {
    final question = OnboardingCubit().getQuestionByType(widget.questions, 'HEALTH_CONCERNS');
    final choices = question?.choices;
    if (choices != null && choices.isNotEmpty) return choices;
    return [
      'Nothing urgent; I just want to understand my body better',
      'I\'m tired all the time and want to understand why',
      'I\'m trying to get pregnant, or thinking about it',
      'I\'m feeling off and don\'t know why',
      'My periods or cycle feel unpredictable or painful',
      'I\'m having pain or discomfort in a specific area',
      'I\'ve noticed changes in my skin, weight, or mood',
      'I want to track symptoms and catch patterns early',
      'I feel dismissed and want to feel taken seriously',
      'I\'ve been through a lot lately and it\'s affecting my health',
      'I\'m worried about something that runs in my family and want to get ahead of it',
      'Other',
    ];
  }

  /// ✅ Question and description with API-first fallback
  String get _question {
    final question = OnboardingCubit().getQuestionByType(widget.questions, 'HEALTH_CONCERNS');
    final text = question?.question?.trim() ?? '';
    return text.isEmpty ? 'What feels most important to talk about relating to your health?' : text;
  }

  String get _description {
    final question = OnboardingCubit().getQuestionByType(widget.questions, 'HEALTH_CONCERNS');
    final text = question?.description?.trim() ?? '';
    return text.isEmpty
        ? 'Select any areas that feel relevant right now — we’ll use this to personalize your experience.'
        : text;
  }

  /// ✅ Determines if Next button can be pressed
  /// - Normal selections are valid immediately
  /// - Self-describe is only valid if text is entered
  bool get _canProceed {
    final hasNormalSelection = _selectedAnswers.any((option) => !_isOtherLabel(option));
    final hasValidSelfDescribe =
        _selectedAnswers.any(_isOtherLabel) && _selfDescribeController.text.trim().isNotEmpty;
    return hasNormalSelection || hasValidSelfDescribe;
  }

  /// ✅ Multi-select toggle with self-describe handling
  void _toggleOption(String option) {
    setState(() {
      final isSelected = _selectedAnswers.contains(option);

      if (_isOtherLabel(option)) {
        if (isSelected) {
          _selectedAnswers.remove(option);
          _showSelfDescribeField = false;
          _tempSelfDescribeText = _selfDescribeController.text; // ✅ store temporarily
          _selfDescribeController.clear();
        } else {
          _selectedAnswers.add(option);
          _showSelfDescribeField = true;
          _selfDescribeController.text = _tempSelfDescribeText; // ✅ restore previous text
        }
        return;
      }

      if (isSelected) {
        _selectedAnswers.remove(option);
      } else {
        _selectedAnswers.add(option);
      }
    });
  }

  /// ✅ Build selectable option card
  Widget _buildAnswerOption(String option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: SelectableOptionCard(
        label: option,
        isSelected: _selectedAnswers.contains(option),
        isMultiSelect: true,
        onTap: () => _toggleOption(option),
      ),
    );
  }

  /// ✅ Self-describe text field (revealed when selected)
  Widget _buildSelfDescribeField() {
    return Visibility(
      visible: _showSelfDescribeField,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s16),
        child: FoxxTextField(
          controller: _selfDescribeController,
          hintText: 'Please specify',
          size: FoxxTextFieldSize.multiLine,
          onChanged: (_) => setState(() {}), // triggers _canProceed
        ),
      ),
    );
  }

  @override
  void dispose() {
    _selfDescribeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content (scroll handled by parent flow)
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.textBoxHorizontalWidget,
            0,
            AppSpacing.textBoxHorizontalWidget,
            AppSpacing.s80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OnboardingQuestionHeader(
                questions: widget.questions,
                questionType: 'HEALTH_CONCERNS',
                questionOverride: _question,
                descriptionOverride: _description,
              ),
              const SizedBox(height: AppSpacing.s12),
              ..._healthConcerns.map(_buildAnswerOption),
              _buildSelfDescribeField(),
            ],
          ),
        ),

        // Fixed bottom "Next" button
        Positioned(
          left: AppSpacing.textBoxHorizontalWidget,
          right: AppSpacing.textBoxHorizontalWidget,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          child: AnimatedOpacity(
            opacity: _canProceed ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !_canProceed,
              child: FoxxNextButton(
                text: 'Next',
                isEnabled: _canProceed,
                onPressed: () {
                  final selected = Set<String>.from(_selectedAnswers);
                  if (_selectedAnswers.any(_isOtherLabel) &&
                      _selfDescribeController.text.trim().isNotEmpty) {
                    selected.removeWhere(_isOtherLabel);
                    selected.add(_selfDescribeController.text.trim());
                  }

                  widget.onDataUpdate?.call(selected);
                  FocusScope.of(context).unfocus();
                  widget.onNext?.call();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}