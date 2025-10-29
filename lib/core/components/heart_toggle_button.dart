import "package:flutter/material.dart";
import "package:foxxhealth/features/presentation/theme/app_colors.dart";

class HeartToggleButton extends StatefulWidget {
  final bool isLiked;
  final double? height;
  final double? width;
  final Color? color;
  final Future<void> Function() onToggle; // API call function

  const HeartToggleButton({
    super.key,
    required this.isLiked,
    required this.onToggle,
    this.height,
    this.width,
    this.color = Colors.white,
  });

  @override
  HeartToggleButtonState createState() => HeartToggleButtonState();
}

class HeartToggleButtonState extends State<HeartToggleButton> {
  late bool _isLiked;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
  }

  Future<void> _handleToggle() async {
    if (_isLoading) return; // Prevent multiple taps

    setState(() {
      _isLoading = true;
      _isLiked = !_isLiked;
    });

    try {
      await widget.onToggle();
    } catch (e, stackTrace) {
      debugPrint("Error toggling library status: $e\n$stackTrace");
      // Revert state on failure
      setState(() => _isLiked = !_isLiked);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void didUpdateWidget(covariant HeartToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the incoming widget's value is different from the old one
    if (widget.isLiked != oldWidget.isLiked) {
      setState(() {
        // Update the state when the isMediaInLibrary value changes
        _isLiked = widget.isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _isLoading ? null : _handleToggle,
        child: Icon(
          color: AppColors.amethystViolet,
          !_isLiked ? Icons.favorite_border : Icons.favorite,
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
