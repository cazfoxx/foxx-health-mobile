import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class NewsArticleScreen extends StatefulWidget {
  const NewsArticleScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NewsArticleScreen> createState() => _NewsArticleScreenState();
}

class _NewsArticleScreenState extends State<NewsArticleScreen> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'WebMD (source logo)',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isFollowing = !isFollowing;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isFollowing ? Colors.grey : AppColors.amethystViolet,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isFollowing ? 'Following' : 'Follow',
                style: TextStyle(
                  color: isFollowing ? Colors.grey : AppColors.amethystViolet,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              color: AppColors.amethystViolet.withOpacity(0.2),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What can you do on marketplace',
                    style: AppTextStyles.heading2.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.image,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'pro side effects',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Lorem ipsum dolor sit amet consectetur. Feugiat fames tortor tristique facilisis cursus consectetur bibendum ut. Volutpat posuere sollicitudin commodo eu. Amet donec in non tortor aliquam suspendisse. Cras in ac nisl maecenas sagittis rhoncus. Erat nulla elementum aenean imperdiet. Pretium et venenatis viverra cursus. Nec odio blandit augue ac scelerisque mauris felis ac aenean. Ultrices arcu tellus mattis lorem volutpat vitae. Ac eget dictum ut quam mattis velit.',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined,
                          size: 20, color: AppColors.amethystViolet),
                      const SizedBox(width: 16),
                      Icon(Icons.bookmark_border,
                          size: 20, color: AppColors.amethystViolet),
                      const SizedBox(width: 16),
                      Icon(Icons.chat_bubble_outline,
                          size: 20, color: AppColors.amethystViolet),
                      const SizedBox(width: 4),
                      Text('8',
                          style: TextStyle(color: AppColors.amethystViolet)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
