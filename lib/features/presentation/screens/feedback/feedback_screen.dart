import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/feedback/feedback_cubit.dart';
import 'package:foxxhealth/core/services/analytics_service.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final Map<String, bool> features = {
    'Check List': false,
    'Track Symptoms': false,
    'Share Check List': false,
    'Personal Health Guide': false,
    'Health News': false,
    'Appointment Tracker': false,
  };

  bool showTextInput = false;
  final TextEditingController _textController = TextEditingController();
  final _analytics = AnalyticsService();

  @override
  void dispose() {
    _textController.dispose();
    _logScreenView();
    super.dispose();
  }

  Future<void> _logScreenView() async {
    await _analytics.logScreenView(
      screenName: 'FeedbackScreen',
      screenClass: 'FeedbackScreen',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeedbackCubit(),
      child: BlocConsumer<FeedbackCubit, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackSuccess) {
            setState(() {
              showTextInput = false;
            });
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text('Thank you!'),
                content: Text('Thanks for taking the time to tell us your thoughts. It means a lot to us!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).maybePop();
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            );
          } 
        },
        builder: (context, state) {
          final feedbackCubit = context.read<FeedbackCubit>();
          return Scaffold(
            appBar: AppBar(
              title: Text('End of Appointment Feedback', style: AppTextStyles.heading3),
              backgroundColor: Colors.white,
            ),
            body: Column(
              children: [
                Container(
                  color: AppColors.lightViolet,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          showTextInput ? 'Why are you using FOXX?' : 'Favorites',
                          style: AppTextStyles.heading2.copyWith(
                            color: AppColors.amethystViolet,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          showTextInput
                              ? 'Is there something in particular getting you off coming back more often? Select the main reason that keeps you away.'
                              : 'What\'s your favorite part of FoXX? If you love a few parts equally, select them all!',
                          style: AppTextStyles.body2OpenSans,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: showTextInput
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: TextField(
                              controller: _textController,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText:
                                    'If you have anymore to share, please add it below.',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: features.length,
                          itemBuilder: (context, index) {
                            String key = features.keys.elementAt(index);
                            return Container(
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: CheckboxListTile(
                                value: features[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    features[key] = value ?? false;
                                  });
                                },
                                title:
                                    Text(key, style: AppTextStyles.body2OpenSans),
                                activeColor: AppColors.amethystViolet,
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: state is FeedbackLoading
                        ? null
                        : () {
                            if (showTextInput) {
                              // Collect text and send feedback
                              feedbackCubit.setFeedbackText(_textController.text);
                              feedbackCubit.createFeedback();
                            } else {
                              // Collect selected features and go to text input
                              final selected = features.entries
                                  .where((e) => e.value)
                                  .map((e) => e.key)
                                  .toList();
                              feedbackCubit.setSelectedFeedback(selected);
                              setState(() => showTextInput = true);
                            }
                          },
                    child: state is FeedbackLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(showTextInput ? 'Submit' : 'Next',
                            style: AppTextStyles.bodyOpenSans
                                .copyWith(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amethystViolet,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
