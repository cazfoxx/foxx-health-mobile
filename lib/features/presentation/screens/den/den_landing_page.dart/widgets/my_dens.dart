import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/explore_den_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class MyDens extends StatelessWidget {
   final Future<List<CommunityDenModel>> _futureMyden;
  const MyDens({super.key, required Future<List<CommunityDenModel>> futureMyden})
      : _futureMyden = futureMyden;

  @override
  Widget build(BuildContext context) {
        return Container(
          color: Colors.white.withOpacity(0.45),
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
                style: AppHeadingTextStyles.h3.copyWith(
                  color: AppColors.primary01,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to explore dens
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExploreDenScreen()),
                  );
                },
                child: Text(
                  'Explore dens',
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                      color: AppColors.amethystViolet, // Purple color
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal Scrolling Den Categories
          SizedBox(
            height: 120,
            child: FutureBuilder(
                future: _futureMyden,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {}

                  final  myDens = snapshot.data!;

                  if (myDens.isEmpty) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ExploreDenScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                child: Center(
                                  // Use the custom SVG icon defined in DenIcons class
                                  child: SvgPicture.asset(
                                    "assets/svg/dens/explore_dens_icon.svg", // Fallback to default if null
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Explore dens",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: myDens.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 82,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child:
                              // to do fetch from api.
                              DenTopicCard(den: myDens[index]),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
 
  }
}