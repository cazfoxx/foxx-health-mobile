import "dart:ui";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:foxxhealth/features/presentation/theme/app_colors.dart";
import "package:url_launcher/url_launcher.dart";

// ignore: prefer_typing_uninitialized_variables
var bottomSheetContext;

class AppHelper {
  // SHOW DIALOG BOX
  static Future showDialogBox({required BuildContext context, required Widget child, bool canDismiss = false}) async {
    return await showDialog(
        barrierDismissible: canDismiss,
        context: context,
        builder: (BuildContext context) {
          return child;
        });
  }

  //SHOW APP BOTTOM SHEET ACCORDING TO PLATFORM
  static showBottomModalSheet(
      {required BuildContext context,
      required Widget child,
      Color? backgroundColor,
      ShapeBorder? shape,
      double? verticalBorderRadius,
      bool isScrollControlled = false,
      bool enableDrag = false}) {
    {
      bottomSheetContext = context;
      //   if (defaultTargetPlatform == TargetPlatform.iOS) {
      //     return showCupertinoModalPopup(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return Material(
      //             color: Colors.transparent,
      //             child: Padding(
      //                 padding: EdgeInsets.only(
      //                     bottom: MediaQuery.of(context).viewInsets.bottom),
      //                 child: child),
      //           );
      //         });
      //   }
      // else {
      return showModalBottomSheet(
          context: context,
          backgroundColor: backgroundColor?? Colors.white,
          isScrollControlled: isScrollControlled,
          shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(verticalBorderRadius ?? 44))) ,
          enableDrag: enableDrag,
          builder: (
            context,
          ) {
            return child;
          });
    }
  }

  //
  static void showBottomSheets({required BuildContext context, required Widget child}) {
    {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          enableDrag: true,
          builder: (context) => Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              decoration: const BoxDecoration(
                color: AppColors.amethyst,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              ),
              child: child));
    }
  }

  //PROGRESS INDICATOR ACC TO PLATFORM
  static Widget showCircularProgressIndicator({Color? progressColor, double? size = 24}) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: const CircularProgressIndicator.adaptive(
          strokeWidth: 2,
        ),
      ),
    );
  }

  static Future<void> openLink({required String linkUrl}) async {
    final Uri url = Uri.parse(linkUrl);
    if (!await launchUrl(url)) {
      throw Exception("Could not launch $url");
    }
  }

  (String, String, String) durationToHHMMSS(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hr = twoDigits(duration.inHours.remainder(60));
    String min = twoDigits(duration.inMinutes.remainder(60));
    String sec = twoDigits(duration.inSeconds.remainder(60));

    return (hr, min, sec);
  }

  static void pushPage({required Widget pushTo, required BuildContext context}) {
    final routeBuilder = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoPageRoute(builder: (context) => pushTo)
        : MaterialPageRoute(builder: (context) => pushTo);
    Navigator.of(context).push(routeBuilder);
  }

  static void pushWithFadeTransition(
      {required Widget pushTo, required BuildContext context, bool opaque = false, bool fullscreenDialog = true}) {
    Navigator.of(context).push(FadePageRoute(
      widget: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: pushTo,
      ),
      opaque: opaque,
      fullscreenDialog: fullscreenDialog,
    ));
  }

  static Image showDefaultThumbnailImage({String image = "assets/images/new_banner.png"}) {
    return Image.asset(
      image,
      fit: BoxFit.cover,
    );
  }
}


class FadePageRoute extends PageRouteBuilder {
  final Widget? widget;

  FadePageRoute({
    this.widget,
    super.opaque = true,
    super.fullscreenDialog = false,
  }) : super(
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          pageBuilder: (BuildContext context, _, __) {
            return widget!;
          },
        );
}
