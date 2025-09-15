import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Foxxbackground extends StatelessWidget {
   Foxxbackground({super.key, required this.child, this.height});
  final Widget child;
   double? height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: height ?? double.infinity,
          child: SvgPicture.asset('assets/svg/revamp/app_background.svg',fit: BoxFit.cover,)
        ),
        child
      ]
    );
  }
}