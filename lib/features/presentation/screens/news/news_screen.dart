import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/news/news_article_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'interest_selection_screen.dart';
import 'saved_items_screen.dart';
import 'following_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<String> _allInterests = [
    'Hormones',
    'Vitamin',
    'Cancer',
    'Mental Health',
    'Diabetes',
    'Nutritions',
    'Autoimmunes Diseases',
    'Vaccination',
    'Cardiovascular Diseases',
    'Blood Disorder',
    'Allergies',
  ];
  Set<String> _selectedInterests = {'Hormones', 'Mental Health'};
  bool _showInterestScreen = true;

  @override
  void initState() {
    super.initState();
    // _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenInterest = prefs.getBool('hasSeenInterest') ?? false;
    setState(() {
      _showInterestScreen = !hasSeenInterest;
    });
  }

  Future<void> _saveInterests() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenInterest', true);
    setState(() {
      _showInterestScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('News',style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: _showInterestScreen
          ? InterestSelectionScreen(
              allInterests: _allInterests,
              selectedInterests: _selectedInterests,
              onInterestToggle: (interest) {
                setState(() {
                  if (_selectedInterests.contains(interest)) {
                    _selectedInterests.remove(interest);
                  } else {
                    _selectedInterests.add(interest);
                  }
                });
              },
              onSave: _saveInterests,
            )
          : _buildNewsFeed(),
    );
  }

  Widget _buildNewsFeed() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.amethystViolet.withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.bookmark_border, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedItemsScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star_border, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FollowingScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Top News',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.amethystViolet,
                fontSize: 24,
              ),
            ),
          ),
          _buildFeaturedNewsCard(),
          _buildCompactNewsCard(),
          _buildCompactNewsCard(),
        ],
      ),
    );
  }

  Widget _buildFeaturedNewsCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsArticleScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WebMD (source logo)',
                    style: AppTextStyles.body2OpenSans
                        .copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet consectetur. Sapien viverra ullamcorper semper cursus tellus.',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 12),
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

  Widget _buildCompactNewsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey[200],
              child: Icon(
                Icons.image,
                size: 30,
                color: Colors.grey[400],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WebMD (source logo)',
                  style:
                      AppTextStyles.body2OpenSans.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Nisi accumsan viverra fussc',
                  style: AppTextStyles.heading3.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined,
                        size: 16, color: AppColors.amethystViolet),
                    const SizedBox(width: 16),
                    Icon(Icons.bookmark_border,
                        size: 16, color: AppColors.amethystViolet),
                    const SizedBox(width: 16),
                    Icon(Icons.chat_bubble_outline,
                        size: 16, color: AppColors.amethystViolet),
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
    );
  }
}
