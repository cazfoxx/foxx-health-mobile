import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DenScreen extends StatefulWidget {
  const DenScreen({Key? key}) : super(key: key);

  @override
  State<DenScreen> createState() => _DenScreenState();
}

class _DenScreenState extends State<DenScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _selectedFilter = 'My feeds';
  String _searchQuery = '';

  final List<String> _filterOptions = [
    'My feeds',
    'My bookmarks',
  ];

  final List<Map<String, dynamic>> _denCategories = [
    {
      'name': 'Heart Health',
      'icon': Icons.favorite,
      'color': Color(0xFFE0CDFA),
    },
    {
      'name': 'Respiratory Health',
      'icon': Icons.air,
      'color': Color(0xFFE0CDFA),
    },
    {
      'name': 'Patient Advocacy',
      'icon': Icons.person_add,
      'color': Color(0xFFE0CDFA),
    },
    {
      'name': 'Fertility Den',
      'icon': Icons.favorite,
      'color': Color(0xFFE0CDFA),
    },
    {
      'name': 'Mental Health',
      'icon': Icons.psychology,
      'color': Color(0xFFE0CDFA),
    },
  ];

  final List<Map<String, dynamic>> _samplePosts = [
    {
      'id': '1',
      'userName': 'GS777',
      'userAvatar': 'assets/images/cat_avatar.png',
      'pronouns': 'she/her',
      'postedIn': 'Autoimmune Den',
      'content': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris ni aliqui...',
      'hashtags': ['#Autoimmune', '#Gut'],
      'likes': 32,
      'comments': 8,
      'timestamp': '2 hours ago',
      'type': 'post',
      'isTruncated': true,
    },
    {
      'id': '2',
      'userName': 'MapleSyrup',
      'userAvatar': 'assets/images/cat_avatar.png',
      'pronouns': 'she/her',
      'postedIn': 'Heart Health',
      'content': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      'hashtags': ['#Autoimmue', '#Gut'],
      'likes': 32,
      'comments': 8,
      'timestamp': '4 hours ago',
      'type': 'post',
      'isTruncated': false,
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
        backgroundColor: Colors.transparent,// Light beige background
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section with Search Bar
                _buildHeaderSection(),
                
                // My Dens Section
                _buildMyDensSection(),
                
                // Navigation Tabs
                _buildNavigationTabs(),
                
                // Content Area
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFeedsTab(),
                      _buildBookmarksTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(

      child: Column(
        children: [
          // Search Bar
          Container(
            color: Color(0xFFE0CDFA), // Light purple background
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Color(0xFF9B7EDE), // Purple icon
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
                        hintText: 'Search',
                        hintStyle: AppOSTextStyles.osMd.copyWith(
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppOSTextStyles.osMd.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Welcome Message
          Container(

            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Den',
                  style: AppHeadingTextStyles.h2.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A safe & anonymous space to discuss women\'s health',
                  style: AppOSTextStyles.osMd.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyDensSection() {
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // My Dens Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My dens',
                style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to explore dens
                },
                child: Text(
                  'Explore dens',
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                    color: Color(0xFF9B7EDE), // Purple color
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Horizontal Scrolling Den Categories
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _denCategories.length,
              itemBuilder: (context, index) {
                final category = _denCategories[index];
                return Container(
                  // width: 70,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: category['color'],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category['icon'],
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'],
                        style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTabs() {
    return Container(

      child: Row(
        children: _filterOptions.map((filter) {
          final isActive = _selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
                _tabController.animateTo(_filterOptions.indexOf(filter));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: isActive
                      ? Border(
                          bottom: BorderSide(
                            color: Color(0xFF9B7EDE), // Purple underline
                            width: 2,
                          ),
                        )
                      : null,
                ),
                child: Text(
                  filter,
                  textAlign: TextAlign.center,
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: isActive ? Colors.black : Colors.grey[600],
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeedsTab() {
    return Container(
// Beige background
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        itemCount: _filteredPosts.length,
        itemBuilder: (context, index) {
          final post = _filteredPosts[index];
          return _buildPostCard(post);
        },
      ),
    );
  }

  Widget _buildBookmarksTab() {
    return Container(
      color: Color(0xFFF5F5F5), // Beige background
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark,
              size: 64,
              color: Color(0xFF9B7EDE).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No bookmarks yet',
              style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posted in section
          Row(
            children: [
              Text(
                'Posted in ',
                style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to specific den
                },
                child: Text(
                  post['postedIn'],
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                    color: Color(0xFF9B7EDE), // Purple color
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
                  color: Colors.grey[200],
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  post['userName'],
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Post content
          Text(
            post['content'],
            style: AppOSTextStyles.osMd.copyWith(
              color: Colors.black,
              height: 1.4,
            ),
          ),
          if (post['isTruncated'] == true) ...[
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                // Show full content
              },
              child: Text(
                'More',
                style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                  color: Color(0xFF9B7EDE), // Purple color
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          
          // Hashtags
          Wrap(
            spacing: 8,
            children: (post['hashtags'] as List<String>).map((tag) {
              return Text(
                tag,
                style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                  color: Color(0xFF9B7EDE), // Purple color
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
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post['likes']}',
                    style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                      color: Colors.black,
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
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post['comments']}',
                    style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              
              Spacer(),
              
              // Action buttons
              Icon(
                Icons.bookmark_border,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.share,
                color: Colors.grey[600],
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
