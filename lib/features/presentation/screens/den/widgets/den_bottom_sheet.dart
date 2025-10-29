import 'package:flutter/material.dart';

class DenBottomSheet extends StatelessWidget {
  final double gradientContainerHeight;
  final Widget? header;
  final Widget?footer;
  final Widget? body;

  const DenBottomSheet({
    super.key,
    this.gradientContainerHeight = 44,
    this.header,
    this.body,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(44)),
          // gradient: LinearGradient(
          //   colors: [Color(0xFFF7EAFB), Color(0xFFF5F2FF)],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDragHandleArea(),
            if (header != null) header!,
            if (body != null) body!,
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandleArea() {
    return Container(
      height: gradientContainerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFE5AA),
            Color(0xFFE9D3FF),
          ],
        ),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 48,
          height: 3,
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
