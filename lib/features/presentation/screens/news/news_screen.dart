import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News', style: AppTextStyles.heading2),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Top News',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.amethystViolet,
                ),
              ),
            ),
            _buildNewsCard(),
            _buildTrendingDiscussions(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'assets/images/news_placeholder.jpg',
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WebMD (source logo)',
                    style: AppTextStyles.body2OpenSans.copyWith(color: Colors.grey)),
                SizedBox(height: 8),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Nisi accumsan viverra',
                  style: AppTextStyles.heading3,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.bookmark_border),
                    SizedBox(width: 8),
                    Text('8'),
                    Spacer(),
                    _buildResponseBadge('150 Responses'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingDiscussions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.amber.shade100,
          child: Row(
            children: [
              Text(
                'Trending Discussions',
                style: AppTextStyles.heading3,
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return _buildDiscussionItem();
          },
        ),
      ],
    );
  }

  Widget _buildDiscussionItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WebMD (source logo)',
              style: AppTextStyles.body2OpenSans.copyWith(color: Colors.grey)),
          SizedBox(height: 8),
          Text(
            'What can you do on marketplace',
            style: AppTextStyles.heading3,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.thumb_up_outlined),
              SizedBox(width: 8),
              Text('8'),
              Spacer(),
              _buildResponseBadge('1,430 Responses'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResponseBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.blue,
            child: Text('A', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          SizedBox(width: 4),
          Text(text, style: AppTextStyles.body2OpenSans),
        ],
      ),
    );
  }
}