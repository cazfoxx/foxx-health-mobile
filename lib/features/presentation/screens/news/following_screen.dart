import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Following',
          style: AppTextStyles.heading3.copyWith(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Topics',
              style: AppTextStyles.heading3,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildTopicItem('Vitamins'),
                _buildTopicItem('Hormones'),
                _buildTopicItem('Cancer'),
                _buildTopicItem('Diabetes'),
                _buildTopicItem('Mental Health'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicItem(String topic) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            topic,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(Icons.add_circle_outline, color: AppColors.amethystViolet),
        ],
      ),
    );
  }
}