import 'package:flutter/material.dart';
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
  bool showThankYou = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    showThankYou
                        ? 'Thank you!'
                        : (showTextInput
                            ? 'Why are you using FOXX?'
                            : 'Favorites'),
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.amethystViolet,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    showThankYou
                        ? 'Thanks for taking the time to tell us your thoughts. It means a lot to us!'
                        : (showTextInput
                            ? 'Is there something in particular getting you off coming back more often? Select the main reason that keeps you away.'
                            : 'What\'s your favorite part of FoXX? If you love a few parts equally, select them all!'),
                    style: AppTextStyles.body2OpenSans,
                  ),
                ],
              ),
            ),
          ),
          if (!showThankYou) ...[
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
                onPressed: () {
                  if (showTextInput) {
                    setState(() {
                      showThankYou = true;
                    });
                    // Future.delayed(Duration(seconds: 2), () {
                    //   Navigator.pop(context);
                    // });
                  } else {
                    setState(() => showTextInput = true);
                  }
                },
                child: Text(showTextInput ? 'Submit' : 'Next',
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
        ],
      ),
    );
  }
}
