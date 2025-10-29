import "package:flutter/material.dart";
import "package:foxxhealth/features/presentation/theme/app_colors.dart";

class ToggleBookmarkIcon extends StatefulWidget {
  final bool isBookMarked;
  final double? height;
  final double? width;
  final Color? color;
  final Future<void> Function() onToggle; // API call function

  const ToggleBookmarkIcon({
    super.key,
    required this.isBookMarked,
    required this.onToggle,
    this.height,
    this.width,
    this.color = Colors.white,
  });

  @override
  ToggleBookmarkIconState createState() => ToggleBookmarkIconState();
}

class ToggleBookmarkIconState extends State<ToggleBookmarkIcon> {
  late bool _isBookMarked;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isBookMarked = widget.isBookMarked;
  }

  Future<void> _handleToggle() async {
    if (_isLoading) return; // Prevent multiple taps

    setState(() {
      _isLoading = true;
      _isBookMarked = !_isBookMarked;
    });

    try {
      await widget.onToggle();
    } catch (e, stackTrace) {
      debugPrint("Error toggling library status: $e\n$stackTrace");
      // Revert state on failure
      setState(() => _isBookMarked = !_isBookMarked);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void didUpdateWidget(covariant ToggleBookmarkIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the incoming widget's value is different from the old one
    if (widget.isBookMarked != oldWidget.isBookMarked) {
      setState(() {
        // Update the state when the isMediaInLibrary value changes
        _isBookMarked = widget.isBookMarked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _isLoading ? null : _handleToggle,
        child: Icon(
          color: AppColors.amethystViolet,
          !_isBookMarked ? Icons.bookmark_border : Icons.bookmark,
          size: 24,
        )

        //  SvgPictureWidget(
        //   height: widget.height ?? 24,
        //   width: widget.width ?? 24,
        //   color: widget.color ?? Colors.white,
        //   _isInLibrary ? ImagePath.svg.heartFilled : ImagePath.svg.heartOutline,
        // ),
        );
  }
}
