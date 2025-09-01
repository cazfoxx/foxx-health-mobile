import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Foxxbackground extends StatelessWidget {
  const Foxxbackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: SvgPicture.asset('assets/svg/revamp/app_background.svg',fit: BoxFit.cover,)
        ),
        child
      ]
    );
  }
}