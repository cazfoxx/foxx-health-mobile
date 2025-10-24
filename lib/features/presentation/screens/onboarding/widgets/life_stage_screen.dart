import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_selectable_option_card.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';

class LifeStageScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  final Function(String)? onDataUpdate;
  final String? currentValue; // ✅ Previously selected life stage
  final ValueChanged<bool>? onEligibilityChanged;

  const LifeStageScreen({
    super.key,
    this.onNext,
    this.questions = const [],
    this.onDataUpdate,
    this.currentValue,
    this.onEligibilityChanged,
  });

  @override
  State<LifeStageScreen> createState() => _LifeStageScreenState();
}

class _LifeStageScreenState extends State<LifeStageScreen> with AutomaticKeepAliveClientMixin {
  final Set<String> _selectedAnswers = {};
  final TextEditingController _selfDescribeController = TextEditingController();
  bool _showSelfDescribeField = false;
  String _tempSelfDescribeText = '';

  @override
  bool get wantKeepAlive => true;

  void _emitEligibility() {
    widget.onEligibilityChanged?.call(_canProceed);
  }

  @override
  void initState() {
    super.initState();

    // ✅ Restore from currentValue: match canonical option or treat as free text
    final cv = widget.currentValue?.trim();
    if (cv != null && cv.isNotEmpty) {
      final canonical = _lifeStages.firstWhere(
        (opt) => opt.toLowerCase().trim() == cv.toLowerCase(),
        orElse: () => '',
      );

      if (canonical.isNotEmpty) {
        _selectedAnswers.add(canonical);
        if (_isOtherLabel(canonical)) {
          _showSelfDescribeField = true; // don't prefill text for canonical "Other"
        }
      } else {
        // Free text → select "Other" and fill the field
        final otherLabel = _lifeStages.firstWhere(_isOtherLabel, orElse: () => 'Other');
        _selectedAnswers.add(otherLabel);
        _showSelfDescribeField = true;
        _selfDescribeController.text = cv;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final payload = _buildPayload();
      if (payload != null) widget.onDataUpdate?.call(payload);
      _emitEligibility();
    });
  }

  List<String> get _lifeStages {
    final question = OnboardingCubit()
        .getQuestionByType(widget.questions, 'CURRENT_STAGE_IN_LIFE');
    final cached = OnboardingCubit.cachedChoicesByType['CURRENT_STAGE_IN_LIFE'];
    final apiChoices = (question?.choices.isNotEmpty ?? false) ? question!.choices : (cached ?? []);

    return apiChoices.isNotEmpty
        ? apiChoices
        : [
            'Menstruating',
            'Trying to conceive',
            'Pregnant',
            'Postpartum',
            'Peri-menopause',
            'Menopause',
            'Post-menopausal',
            'Other',
          ];
  }

  String get _question {
    final question = OnboardingCubit()
        .getQuestionByType(widget.questions, 'CURRENT_STAGE_IN_LIFE');
    final text = question?.question?.trim() ?? '';
    return text.isEmpty ? 'What is your current life stage?' : text;
  }

  String get _description {
    final question = OnboardingCubit()
        .getQuestionByType(widget.questions, 'CURRENT_STAGE_IN_LIFE');
    final text = question?.description?.trim() ?? '';
    return text.isEmpty
        ? 'This helps us tailor guidance and content to your stage.'
        : text;
  }

  bool _isOtherLabel(String label) =>
      label.toLowerCase().contains('other') ||
      label.toLowerCase().contains('self');

  String? _buildPayload() {
    // Prefer a canonical selection; otherwise use "Other" text if valid
    final normal = _selectedAnswers.firstWhere(
      (a) => !_isOtherLabel(a),
      orElse: () => '',
    );
    if (normal.isNotEmpty) return normal;

    if (_selectedAnswers.any(_isOtherLabel)) {
      final txt = _selfDescribeController.text.trim();
      if (txt.isNotEmpty) return txt;
    }
    return null;
  }

  void _toggleOption(String label) {
    final isOther = _isOtherLabel(label);
    final isSelected = _selectedAnswers.contains(label);

    setState(() {
      if (isSelected) {
        _selectedAnswers.remove(label);
        if (isOther) {
          _showSelfDescribeField = false;
          // Preserve text instead of clearing, so it can be restored
          _tempSelfDescribeText = _selfDescribeController.text.trim();
        }
      } else {
        _selectedAnswers.add(label);
        if (isOther) {
          _showSelfDescribeField = true;
          if (_selfDescribeController.text.trim().isEmpty &&
              _tempSelfDescribeText.isNotEmpty) {
            _selfDescribeController.text = _tempSelfDescribeText;
          }
        }
      }
    });

    final payload = _buildPayload();
    if (payload != null) widget.onDataUpdate?.call(payload);
    _emitEligibility();
  }

  Widget _buildAnswerOption(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: SelectableOptionCard(
        label: label,
        isSelected: _selectedAnswers.contains(label),
        isMultiSelect: true,
        onTap: () => _toggleOption(label),
      ),
    );
  }

  Widget _buildSelfDescribeField() {
    return Visibility(
      visible: _showSelfDescribeField,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s16),
        child: FoxxTextField(
          controller: _selfDescribeController,
          hintText: 'Please specify',
          size: FoxxTextFieldSize.singleLine,
          onChanged: (_) {
            setState(() {});
            final payload = _buildPayload();
            if (payload != null) widget.onDataUpdate?.call(payload);
            _emitEligibility();
          },
        ),
      ),
    );
  }

  bool get _canProceed {
    final hasSelection = _selectedAnswers.isNotEmpty;
    final hasOtherText = _showSelfDescribeField &&
        _selfDescribeController.text.trim().isNotEmpty;
    return hasSelection || hasOtherText;
  }

  void _onNext() {
    final answers = <String>{
      ..._selectedAnswers.where((a) => !_isOtherLabel(a)),
    };

    if (_showSelfDescribeField) {
      final otherText = _selfDescribeController.text.trim();
      if (otherText.isNotEmpty) answers.add(otherText);
    }

    if (answers.isNotEmpty) {
      widget.onDataUpdate?.call(answers.first);
    }

    FocusScope.of(context).unfocus();
    widget.onNext?.call();
  }

  @override
  void dispose() {
    _selfDescribeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // keep-alive hook
    return Stack(
      children: [
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
                questionType: 'CURRENT_STAGE_IN_LIFE',
                questionOverride: _question,
                descriptionOverride: _description,
              ),
              ..._lifeStages.map(_buildAnswerOption),
              _buildSelfDescribeField(),
            ],
          ),
        ),

      ],
    );
  }
}