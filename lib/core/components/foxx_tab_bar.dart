import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class FoxxTabBar extends StatelessWidget {
  final bool isPinned;
  final Color? pinnedBackGroundColor;
  final List<Tab> tabs;

  final TabController? tabController;
  const FoxxTabBar(
      {super.key,
      required this.tabController,
      this.isPinned = false,
      this.pinnedBackGroundColor,
      required this.tabs});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: isPinned
              ? (pinnedBackGroundColor ?? const Color(0xffFFE5AA))
              : Colors.transparent),
      child: TabBar(
        tabAlignment: TabAlignment.start,
        controller: tabController,
        padding:const EdgeInsets.symmetric(horizontal: 8),
        isScrollable: true, // Allows tabs to be wider than the screen if needed
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
        // 1. Text Colors
        labelColor: Colors.black,
        unselectedLabelColor:
            AppColors.secondaryTxt, // Darker grey for inactive tab text

        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Colors.black, // A deep purple/indigo color
            width: 2.0, // Thicker line
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,

        labelStyle:
            AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: AppTextStyles.heading3.copyWith(
            color: AppColors.secondaryTxt, fontWeight: FontWeight.bold),

        tabs: tabs,
      ),
    );
  }
}

// class CustomTabBar extends StatelessWidget {
//   final List<String> tabs;
//   final int selectedIndex;
//   final ValueChanged<int> onTabSelected;
//   final bool isPinned; // True when scrolled to top (used to change background)

//   const CustomTabBar({
//     super.key,
//     required this.tabs,
//     required this.selectedIndex,
//     required this.onTabSelected,
//     this.isPinned = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: isPinned ? Colors.white : Colors.transparent,
//         gradient: !isPinned
//             ? const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFFF7EEDC), Color(0xFFFDFBFF)],
//               )
//             : null,
//         boxShadow: isPinned
//             ? [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ]
//             : [],
//       ),
//       height: 46,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: tabs.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 18),
//         itemBuilder: (context, index) {
//           final isSelected = index == selectedIndex;
//           return GestureDetector(
//             onTap: () => onTabSelected(index),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   tabs[index],
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight:
//                         isSelected ? FontWeight.w600 : FontWeight.w400,
//                     color: Colors.black.withOpacity(0.75),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   height: 2,
//                   width: isSelected ? 28 : 0,
//                   color: isSelected
//                       ? Colors.black.withOpacity(0.7)
//                       : Colors.transparent,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

/// use this delegate to change tab bar backround
typedef PinnedChangedCallback = void Function(bool isPinned);

class CustomTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  // Reverting to 46.0 as originally intended for a fixed-height header
  final double minExtentValue;
  final double maxExtentValue;
  final PinnedChangedCallback onPinned;

  // IMPORTANT: The internal state needs to track the last reported pinned status.
  // This state persists across rebuilds of the delegate's build method.
  bool _wasPinned = false;

  CustomTabBarDelegate({
    required this.child,
    required this.onPinned,
    // Setting both to 46.0 means the header collapses instantly or not at all.
    this.minExtentValue = 46.0,
    this.maxExtentValue = 46.0,
  });

  @override
  double get minExtent => minExtentValue;

  @override
  double get maxExtent => maxExtentValue;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 1. Calculate the pinning threshold.
    // Since minExtent == maxExtent, the threshold is 0.0.
    // final double pinningThreshold = maxExtent - minExtent; // Not needed now

    // 2. Determine if it is currently pinned (not at the very top of the scroll view).
    // The header is pinned if shrinkOffset > 0. We use a small epsilon (0.0001)
    // for robust floating-point comparison to ensure 'isNowPinned' is false
    // only when shrinkOffset is effectively 0.0 (unpinned).
    final bool isNowPinned = shrinkOffset > 0.0001;

    // 3. Check for state change
    if (isNowPinned != _wasPinned) {
      // The state has changed, so update the internal flag and notify the parent.
      _wasPinned = isNowPinned;

      // Use addPostFrameCallback to ensure setState is called after the build
      // phase completes, preventing the 'parentDataDirty' assertion error.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only call the callback if the context is still mounted (widget is active).
        if (context.mounted) {
          onPinned(isNowPinned);
        }
      });
    }

    // 4. Return the child widget.
    return SizedBox.expand(child: child);
  }

  // Set shouldRebuild to true if any fields change that might affect layout,
  // but for a fixed delegate like this, false is acceptable for performance
  // if all parameters are final.
  @override
  bool shouldRebuild(covariant CustomTabBarDelegate oldDelegate) {
    // FIX: Returning true here ensures the build method is called
    // consistently on every scroll update, which is necessary for reliable
    // state change detection inside the build method.
    return true;
  }
}
