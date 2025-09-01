import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';

class DenScreen extends StatefulWidget {
  const DenScreen({Key? key}) : super(key: key);

  @override
  State<DenScreen> createState() => _DenScreenState();
}

class _DenScreenState extends State<DenScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<String> _filterOptions = [
    'All',
    'Posts',
    'Comments',
    'Bookmarks',
    'Likes',
  ];

  final List<Map<String, dynamic>> _samplePosts = [
    {
      'id': '1',
      'userName': 'AppleS@uace',
      'userAvatar': 'assets/images/cat_avatar.png',
      'pronouns': 'she/her',
      'postedIn': 'Autoimmune Den',
      'content': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      'hashtags': ['#AutoImmune', '#Gut'],
      'likes': 32,
      'comments': 8,
      'timestamp': '2 hours ago',
      'type': 'post',
    },
    {
      'id': '2',
      'userName': 'AppleS@uace',
      'userAvatar': 'assets/images/cat_avatar.png',
      'pronouns': 'she/her',
      'postedIn': 'Heart Health',
      'content': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      'hashtags': ['#HeartHealth', '#Wellness'],
      'likes': 32,
      'comments': 8,
      'timestamp': '4 hours ago',
      'type': 'post',
    },
    {
      'id': '3',
      'userName': 'HealthWarrior',
      'userAvatar': 'assets/images/cat_avatar.png',
      'pronouns': 'they/them',
      'postedIn': 'Mental Health',
      'content': 'Just wanted to share my experience with managing anxiety through meditation. It\'s been a game-changer for me!',
      'hashtags': ['#MentalHealth', '#Meditation', '#Anxiety'],
      'likes': 45,
      'comments': 12,
      'timestamp': '1 day ago',
      'type': 'post',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filterOptions.length, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredPosts {
    if (_searchQuery.isEmpty) {
      return _samplePosts;
    }
    return _samplePosts
        .where((post) =>
            post['userName'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            post['content'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            post['postedIn'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (post['hashtags'] as List<String>).any((tag) =>
                tag.toLowerCase().contains(_searchQuery.toLowerCase())))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Top Navigation Bar with Search
              _buildTopNavigationBar(),
              
              // Profile Card
              _buildProfileCard(),
              
              // Tab Bar
              _buildTabBar(),
              
              // Content Area
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPostsTab(),
                    _buildCommentsTab(),
                    _buildBookmarksTab(),
                    _buildLikesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Color(0xffE0CDFA), AppColors.amethystViolet],
          radius: 10,
        ),
      ),
      child: Row(
        children: [
          // Back Button
          FoxxBackButton(),
          
          // Search Bar
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.gray200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Icon(
                    Icons.search,
                    color: AppColors.amethyst,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search in The Den...',
                        hintStyle: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.gray400,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppOSTextStyles.osMd.copyWith(
                        color: AppColors.primary01,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(16.0),
      decoration: AppColors.glassCardDecoration,
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.amethyst.withOpacity(0.2),
            ),
            child: Icon(
              Icons.pets,
              color: AppColors.amethyst,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AppleS@uace',
                      style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                        color: AppColors.primary01,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'she/her',
                      style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                        color: AppColors.davysGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Community Member',
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                    color: AppColors.davysGray,
                  ),
                ),
              ],
            ),
          ),
          
          // Settings Icon
          Icon(
            Icons.settings,
            color: AppColors.amethyst,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.amethyst,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.primary01,
        labelStyle: AppOSTextStyles.osSmSemiboldLabel,
        unselectedLabelStyle: AppOSTextStyles.osSmSemiboldLabel,
        tabs: _filterOptions.map((filter) => Tab(text: filter)).toList(),
      ),
    );
  }

  Widget _buildPostsTab() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.builder(
        itemCount: _filteredPosts.length,
        itemBuilder: (context, index) {
          final post = _filteredPosts[index];
          return _buildPostCard(post);
        },
      ),
    );
  }

  Widget _buildCommentsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.comment,
            size: 64,
            color: AppColors.amethyst.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No comments yet',
            style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
              color: AppColors.davysGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark,
            size: 64,
            color: AppColors.amethyst.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No bookmarks yet',
            style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
              color: AppColors.davysGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: 64,
            color: AppColors.amethyst.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No liked posts yet',
            style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
              color: AppColors.davysGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: AppColors.glassCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posted in section
          Row(
            children: [
              Text(
                'Posted in ',
                style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                  color: AppColors.davysGray,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to specific den
                },
                child: Text(
                  post['postedIn'],
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                    color: AppColors.amethyst,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // User info
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.amethyst.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.pets,
                  color: AppColors.amethyst,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post['userName'],
                          style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                            color: AppColors.primary01,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          post['pronouns'],
                          style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                            color: AppColors.davysGray,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      post['timestamp'],
                      style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                        color: AppColors.davysGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Post content
          Text(
            post['content'],
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 8),
          
          // Hashtags
          Wrap(
            spacing: 8,
            children: (post['hashtags'] as List<String>).map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.amethyst.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                                  child: Text(
                    tag,
                    style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                      color: AppColors.amethyst,
                    ),
                  ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          
          // Interaction buttons
          Row(
            children: [
              // Like button
              Row(
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: AppColors.amethyst,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post['likes']}',
                    style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                      color: AppColors.primary01,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              
              // Comment button
              Row(
                children: [
                  Icon(
                    Icons.comment_outlined,
                    color: AppColors.amethyst,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post['comments']}',
                    style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                      color: AppColors.primary01,
                    ),
                  ),
                ],
              ),
              
              Spacer(),
              
              // Action buttons
              Text(
                'Delete',
                style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                  color: AppColors.davysGray,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.bookmark_border,
                color: AppColors.amethyst,
                size: 20,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.share,
                color: AppColors.amethyst,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
