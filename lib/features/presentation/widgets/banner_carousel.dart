import 'package:flutter/material.dart';
import 'package:foxxhealth/features/data/models/banner_model.dart';
import 'package:foxxhealth/features/presentation/screens/premiumScreen/premium_overlay.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerData> banners;
  final Function(BannerData)? onBannerTap;

  const BannerCarousel({
    Key? key,
    required this.banners,
    this.onBannerTap,
  }) : super(key: key);

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: (){
         showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height*0.9,
            decoration: BoxDecoration(
              color: AppColors.amethystViolet.withOpacity(0.97),
            ),
            child: PremiumOverlay(),
          ),
        );
      },
      child: Column(
        children: [
          // Banner content
          SizedBox(
            height: 120,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.banners.length,
              itemBuilder: (context, index) {
                return _buildBannerCard(widget.banners[index]);
              },
            ),
          ),
          const SizedBox(height: 12),
          
          // Page indicators
          if (widget.banners.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.banners.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == _currentPage 
                        ? AppColors.amethystViolet 
                        : AppColors.gray400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(BannerData banner) {
    return GestureDetector(
      onTap: () => widget.onBannerTap?.call(banner),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppColors.glassCardDecoration,
      

        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getBannerIcon(banner.type),
                  color: AppColors.amethystViolet,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    banner.subtitle,
                    style: AppTextStyles.captionOpenSans.copyWith(
                      color: AppColors.amethystViolet,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              
              ],
            ),
            const SizedBox(height: 8),
            Text(
              banner.title,
              style: AppOSTextStyles.osMdSemiboldBody.copyWith(
      
      
              ),
            ),
            if (banner.message != null) ...[
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  banner.message!,
                    style: AppOSTextStyles.osMd.copyWith(
                    color: AppColors.davysGray,
                
                  ),
                
      
                ),
              ),
            ],
            if (banner.questionText != null) ...[
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  banner.questionText!,
                  style: AppOSTextStyles.osMd.copyWith(
                  color: AppColors.davysGray,
                ),
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getBannerIcon(String type) {
    switch (type) {
      case 'upsell':
        return Icons.star;
      case 'get_to_know_me':
        return Icons.psychology;
      case 'welcome':
        return Icons.celebration;
      default:
        return Icons.info;
    }
  }
}
