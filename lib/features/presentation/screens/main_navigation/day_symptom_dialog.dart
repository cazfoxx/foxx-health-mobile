import 'package:flutter/material.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';
import 'package:foxxhealth/features/presentation/screens/main_navigation/main_navigation_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaySymptomsDialog extends StatefulWidget {
  final List<String> symptoms;
  final DateTime date;

  const DaySymptomsDialog({
    Key? key,
    required this.symptoms,
    required this.date,
  }) : super(key: key);

  @override
  State<DaySymptomsDialog> createState() => _DaySymptomsDialogState();
}

class _DaySymptomsDialogState extends State<DaySymptomsDialog> {
  // Selection map: symptom name → selected/unselected
  late Map<String, bool> _selectedMap;

  @override
  void initState() {
    super.initState();
    _selectedMap = {for (var s in widget.symptoms) s: false};
  }

  //symptom colors map
  final Map<int, Color> symptomColors = {
    0: AppColors.insightPurple,
    1: AppColors.insightTeal,
    2: AppColors.insightCoralPink,
    3: AppColors.insightMintGreen,
    4: AppColors.insightYellow,
    5: AppColors.insightCoolNavy,
    6: AppColors.insightOliveGreen,
    7: AppColors.insightGray,
    8: AppColors.insightIceBlue,
    9: AppColors.insightDarkRed,
    10: AppColors.insightOrange,
    11: AppColors.mauve,
    12: AppColors.insightEmerald,
    13: AppColors.insightPeachPastel,
    14: AppColors.insightLakeBlue,
    15: AppColors.insightHotPink,
    16: AppColors.insightRed,
    17: AppColors.insightLimeGreen,
    18: AppColors.insightCamelBrown,
    19: AppColors.insightBrightBlue,
    20: AppColors.insightMintGreen,
    21: AppColors.insightBrown,
    22: AppColors.insightBubblegumPink,
    23: AppColors.insightPineGreen,
    24: AppColors.insightColumbiaBlue,
    25: AppColors.insightNeonGreen,
    26: AppColors.insightBrightCayan,
    27: AppColors.foxxWhite,
    28: AppColors.insightSageGreen,
    29: AppColors.insightMustard
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.gray100, // dimmed background for "dialog" effect
      body: Center(
        child: Container(
          height: 1200,
          width: 600,
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gradient header
              Container(
                height: 44,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.86, -0.5),
                    end: Alignment(0.86, 0.5),
                    colors: [
                      Color(0xFFE9D3FF),
                      Color(0xFFFFE5AA),
                    ],
                    stops: [0.0022, 0.9528],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                alignment: Alignment.center,
              ),

              // Body
              Expanded(
                child: widget.symptoms.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text("No symptoms recorded"),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                "${DateFormat.MMMM().format(widget.date)} ${widget.date.day}",
                                style: const TextStyle(
                                  color: Color(0xFF3E3D48),
                                  fontSize: 20,
                                  fontFamily: 'Merriweather',
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Symptoms list
                            Expanded(
                              child: ListView.separated(
                                itemCount: widget.symptoms.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (context, index) {
                                  final symptom = widget.symptoms[index];
                                  final isChecked =
                                      _selectedMap[symptom] ?? false;
                                  // pick color by index, fallback to gray if > 29
                                  final color = index < 30
                                      ? symptomColors[index]
                                      : symptomColors[index - 30];

                                  return ListTile(
                                    leading: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    title: Text(
                                      symptom,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedMap[symptom] = !isChecked;
                                        });
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TrackerTab(),
                                          ),
                                        );
                                      },
                                      child: Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                              color: Colors.transparent),
                                          child: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: AppColors.amethyst,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
