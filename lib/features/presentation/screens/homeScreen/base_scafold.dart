import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/widgets/add_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class BaseScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget body;
  final Function(int) onTap;
  final PreferredSizeWidget? appBar;

  const BaseScaffold({
    Key? key,
    required this.currentIndex,
    required this.body,
    required this.onTap,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return AddBottomSheet();
              },
            );
          } else {
            onTap(index);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset('assets/svg/home/home_solid_icon.svg'),
            icon: SvgPicture.asset('assets/svg/home/home_icon.svg'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset('assets/svg/home/news_solid.svg'),
            icon: SvgPicture.asset('assets/svg/home/news_icon.svg'),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              width: 70,
              decoration: BoxDecoration(
                color: AppColors.amethystViolet,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            activeIcon:
                SvgPicture.asset('assets/svg/home/health_icon_navigation.svg'),
            icon: SvgPicture.asset('assets/svg/home/health_icon.svg'),
            label: 'Symptom',
          ),
          BottomNavigationBarItem(
            activeIcon:
                SvgPicture.asset('assets/svg/home/feedback_solid_icon.svg'),
            icon: SvgPicture.asset('assets/svg/home/feedback_icon.svg'),
            label: 'Feedback',
          ),
        ],
      ),
    );
  }
}
