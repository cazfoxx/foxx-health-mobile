import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'compare_symptoms_bottom_sheet.dart';

class SymptomInsightsScreen extends StatefulWidget {
  final Symptom symptom;
  
  const SymptomInsightsScreen({
    Key? key,
    required this.symptom,
  }) : super(key: key);

  @override
  State<SymptomInsightsScreen> createState() => _SymptomInsightsScreenState();
}

class _SymptomInsightsScreenState extends State<SymptomInsightsScreen> {
  bool isLineChart = true;
  List<String> selectedSymptoms = [];
  
  // Available symptoms for comparison
  final List<String> availableSymptoms = [
    'Cramps', 'Fatigue', 'Sleep', 'Back Pain', 'Nausea', 
    'Dizziness', 'Anxiety', 'Depression', 'Insomnia'
  ];
  
  // Sample data for the charts
  final List<ChartData> chartData = [
    ChartData(month: 'Feb', headache: 1, cramps: 1, fatigue: 2, backPain: 1, sleep: 2, nausea: 1, dizziness: 1, anxiety: 2, depression: 1, insomnia: 2),
    ChartData(month: 'Mar', headache: 3, cramps: 2, fatigue: 3, backPain: 3, sleep: 1, nausea: 2, dizziness: 2, anxiety: 3, depression: 2, insomnia: 1),
    ChartData(month: 'Apr', headache: 2, cramps: 1, fatigue: 2, backPain: 1, sleep: 2, nausea: 1, dizziness: 1, anxiety: 2, depression: 1, insomnia: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Chart Section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Chart Toggle
                      _buildChartToggle(),
                      const SizedBox(height: 20),
                      
                      // Chart
                      _buildChart(),
                      const SizedBox(height: 20),
                      
                      // Legend
                      _buildLegend(),
                      const SizedBox(height: 20),
                      
                      // Compare Button
                      _buildCompareButton(),
                      const SizedBox(height: 30),
                      
                      // Insights Section
                      _buildInsightsSection(),
                      const SizedBox(height: 20),
                      
                      // Care Section
                      _buildCareSection(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
         FoxxBackButton(
          onPressed: () => Navigator.of(context).pop(),
         ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.symptom.name,
              style: AppOSTextStyles.osXlSemibold.copyWith(
                color: AppColors.primary01,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildChartToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface01.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isLineChart = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isLineChart ? AppColors.surface01 : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.show_chart,
                      color: isLineChart ? AppColors.primary01 : AppColors.gray600,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isLineChart = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isLineChart ? AppColors.surface01 : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      color: !isLineChart ? AppColors.primary01 : AppColors.gray600,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: AppColors.glassCardDecoration,
      child: isLineChart ? _buildLineChart() : _buildBarChart(),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.gray200,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  color: AppColors.gray600,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = const Text('Feb', style: style);
                    break;
                  case 1:
                    text = const Text('Mar', style: style);
                    break;
                  case 2:
                    text = const Text('Apr', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: text,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  color: AppColors.gray600,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                String text;
                switch (value.toInt()) {
                  case 1:
                    text = 'Mild';
                    break;
                  case 2:
                    text = 'Moderate';
                    break;
                  case 3:
                    text = 'Severe';
                    break;
                  default:
                    text = '';
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(text, style: style),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppColors.gray200),
        ),
        minX: 0,
        maxX: 2,
        minY: 0,
        maxY: 4,
        lineBarsData: _buildLineChartData(),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 4,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  color: AppColors.gray600,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = const Text('Feb', style: style);
                    break;
                  case 1:
                    text = const Text('Mar', style: style);
                    break;
                  case 2:
                    text = const Text('Apr', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: text,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  color: AppColors.gray600,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                String text;
                switch (value.toInt()) {
                  case 1:
                    text = 'Mild';
                    break;
                  case 2:
                    text = 'Moderate';
                    break;
                  case 3:
                    text = 'Severe';
                    break;
                  default:
                    text = '';
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(text, style: style),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppColors.gray200),
        ),
        barGroups: _buildBarChartData(),
      ),
    );
  }

  Widget _buildLegend() {
    List<Widget> legendItems = [
      _buildLegendItem(const Color(0xFF805EC9), widget.symptom.name),
    ];
    
    // Add selected symptoms to legend
    for (String symptom in selectedSymptoms) {
      Color color = _getSymptomColor(symptom);
      legendItems.add(_buildLegendItem(color, symptom));
    }
    
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: legendItems,
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
            color: AppColors.primary01,
          ),
        ),
      ],
    );
  }

  Widget _buildCompareButton() {
    return GestureDetector(
      onTap: _showCompareBottomSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryTint50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '+ Compare with other symptoms',
          style: AppOSTextStyles.osMdSemiboldBody.copyWith(
            color: AppColors.primaryTint,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildInsightsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppColors.glassCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Understand your ${widget.symptom.name} patterns',
            style: AppOSTextStyles.osLgSemibold.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Your anxiety ratings are consistently highest in the evening. Here\'s why that might be happening, and how to prepare',
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            'When you get under 6 hours of sleep, your mood scores drop by 15% the following day.',
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            'Your next high-fatigue day is predicted around July 23rd based on recent patterns',
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6, right: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryTint,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.primary01,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCareSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppColors.glassCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.symptom.name} Care',
            style: AppOSTextStyles.osLgSemibold.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You should consider speaking with your healthcare provider if your ${widget.symptom.name}:',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          _buildCareItem('Are usually severe or intense'),
          const SizedBox(height: 12),
          _buildCareItem('Last longer than 2 to 3 days'),
          const SizedBox(height: 12),
          _buildCareItem('Occur with other symptoms, such as fever, weakness, nausea, bleeding, or changes in bowel habits.'),
        ],
      ),
    );
  }

  Widget _buildCareItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6, right: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryTint,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.primary01,
            ),
          ),
        ),
      ],
    );
  }

  void _showCompareBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CompareSymptomsBottomSheet(
        currentSymptom: widget.symptom.name,
        availableSymptoms: availableSymptoms,
        onApply: (symptoms) {
          setState(() {
            selectedSymptoms = symptoms;
          });
        },
      ),
    );
  }

  List<LineChartBarData> _buildLineChartData() {
    List<LineChartBarData> lineBars = [];
    
    // Always show the main symptom
    lineBars.add(LineChartBarData(
      spots: chartData.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), _getSymptomValue(e.value, widget.symptom.name).toDouble());
      }).toList(),
      isCurved: true,
      color: _getSymptomColor(widget.symptom.name),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
    ));
    
    // Add selected symptoms
    for (String symptom in selectedSymptoms) {
      lineBars.add(LineChartBarData(
        spots: chartData.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), _getSymptomValue(e.value, symptom).toDouble());
        }).toList(),
        isCurved: true,
        color: _getSymptomColor(symptom),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ));
    }
    
    return lineBars;
  }

  List<BarChartGroupData> _buildBarChartData() {
    List<BarChartGroupData> barGroups = [];
    
    for (int i = 0; i < chartData.length; i++) {
      List<BarChartRodData> barRods = [];
      
      // Always show the main symptom
      barRods.add(BarChartRodData(
        toY: _getSymptomValue(chartData[i], widget.symptom.name).toDouble(),
        color: _getSymptomColor(widget.symptom.name),
        width: selectedSymptoms.isNotEmpty ? 6 : 8,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ));
      
      // Add selected symptoms
      for (int j = 0; j < selectedSymptoms.length; j++) {
        barRods.add(BarChartRodData(
          toY: _getSymptomValue(chartData[i], selectedSymptoms[j]).toDouble(),
          color: _getSymptomColor(selectedSymptoms[j]),
          width: 6,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ));
      }
      
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: barRods,
      ));
    }
    
    return barGroups;
  }

  Color _getSymptomColor(String symptom) {
    final colorMap = {
      'Headaches': const Color(0xFF805EC9), // Purple
      'Cramps': const Color(0xFF20B2AA), // Teal
      'Fatigue': const Color(0xFFFFD700), // Yellow
      'Back Pain': const Color(0xFFDC143C), // Red
      'Sleep': const Color(0xFF4682B4), // Steel Blue
      'Nausea': const Color(0xFF32CD32), // Lime Green
      'Dizziness': const Color(0xFF9370DB), // Medium Purple
      'Anxiety': const Color(0xFFFF6347), // Tomato
      'Depression': const Color(0xFF2F4F4F), // Dark Slate Gray
      'Insomnia': const Color(0xFF4169E1), // Royal Blue
    };
    return colorMap[symptom] ?? AppColors.gray400;
  }

  int _getSymptomValue(ChartData data, String symptom) {
    switch (symptom) {
      case 'Headaches':
        return data.headache;
      case 'Cramps':
        return data.cramps;
      case 'Fatigue':
        return data.fatigue;
      case 'Back Pain':
        return data.backPain;
      case 'Sleep':
        return data.sleep;
      case 'Nausea':
        return data.nausea;
      case 'Dizziness':
        return data.dizziness;
      case 'Anxiety':
        return data.anxiety;
      case 'Depression':
        return data.depression;
      case 'Insomnia':
        return data.insomnia;
      default:
        return 1;
    }
  }
}

class ChartData {
  final String month;
  final int headache;
  final int cramps;
  final int fatigue;
  final int backPain;
  final int sleep;
  final int nausea;
  final int dizziness;
  final int anxiety;
  final int depression;
  final int insomnia;

  ChartData({
    required this.month,
    required this.headache,
    required this.cramps,
    required this.fatigue,
    required this.backPain,
    required this.sleep,
    required this.nausea,
    required this.dizziness,
    required this.anxiety,
    required this.depression,
    required this.insomnia,
  });
}
