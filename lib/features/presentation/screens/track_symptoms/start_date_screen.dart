import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/select_symptoms_screen.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/widgets/start_date_body_widget.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class StartDateScreen extends StatefulWidget {
  const StartDateScreen({Key? key}) : super(key: key);

  @override
  State<StartDateScreen> createState() => _StartDateScreenState();
}

class _StartDateScreenState extends State<StartDateScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Start date',
      subtitle: 'When do you remember your symptoms first starting?',
      progress: 0.2,
      appbarTitle: 'Track Symptoms',
      appbarTrailing: '',
      customSubtile: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text('Why we ask:', style: AppTextStyles.body2OpenSans),
          const SizedBox(height: 4),
          Text(
              'This will help you recognize how long you\'ll been feeling this way',
              style: AppTextStyles.body2OpenSans
                  .copyWith(color: Colors.grey[600])),
        ],
      ),
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SelectSymptomsScreen(),
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StartDateBodyWidget(
          selectedDate: selectedDate,
          onDateSelected: (date) {
            setState(() {
              selectedDate = date;
            });
          },
        ),
      ),
    );
  }
}
