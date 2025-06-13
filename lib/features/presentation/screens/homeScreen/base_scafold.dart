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
            activeIcon: SvgPicture.asset('assets/svg/home/home_solid_icon.svg',
            color: AppColors.amethystViolet,),
            icon: SvgPicture.asset('assets/svg/home/home_icon.svg',
            color: AppColors.amethystViolet,),
            label: 'Home',
            
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset('assets/svg/home/news_solid.svg',
            color: AppColors.amethystViolet,),
            icon: SvgPicture.asset('assets/svg/home/news_icon.svg',
            color: AppColors.amethystViolet,),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 10,bottom: 0),
              padding: const EdgeInsets.only(top: 7,bottom: 7),
              width: 70,
              decoration: BoxDecoration(
                color: AppColors.amethystViolet,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon:
                SvgPicture.asset('assets/svg/home/health_icon_navigation.svg',
                color: AppColors.amethystViolet,
                ),
            icon: SvgPicture.asset('assets/svg/home/health_icon.svg',
            color: AppColors.amethystViolet,),
            label: 'Symptom',
          ),
          BottomNavigationBarItem(
            activeIcon:
                SvgPicture.asset('assets/svg/home/feedback_solid_icon.svg',
                color: AppColors.amethystViolet,),
            icon: SvgPicture.asset('assets/svg/home/feedback_icon.svg',
            color: AppColors.amethystViolet,),
            label: 'Feedback',
          ),
        ],
      ),
    );
  }
}
