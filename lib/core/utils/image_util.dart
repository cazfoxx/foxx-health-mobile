import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class ImageUtil {
  static const defaultUserAvatarPath =
      "assets/svg/icons/user_avatar.svg"; //change this when default image is available
  static Widget defaultUserImageWidget({double size = 24}) {
    return SvgPicture.asset(defaultUserAvatarPath);
  }

  static ImageProvider cachedImageNetworkProviderWidget(String? imageUrl,
      {String defaultImageAsset = defaultUserAvatarPath,
      double scale = 1,
      BoxFit fit = BoxFit.cover}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset(
        defaultImageAsset,
        fit: fit,
        scale: scale,
      ).image;
    }
    return CachedNetworkImageProvider(
      imageUrl,
      scale: scale,
    );
  }

  static CachedNetworkImage getUserImage(String? imageUrl,
          {double? height,
          double? width,
          BoxFit? boxfit,
          Widget Function(BuildContext, String)? placeHolder}) =>
      CachedNetworkImage(
        height: height,
        width: width,
        imageUrl: imageUrl ?? "",
        errorWidget: (context, _, __) => defaultUserImageWidget(),
        placeholder: (context, url) =>
            placeHolder != null ? placeHolder(context, url) : Container(),
        fadeInCurve: Curves.easeIn,
        fadeInDuration: const Duration(seconds: 2),
        fit: boxfit ?? BoxFit.cover,
      );

  static CachedNetworkImage getImage(String? imageUrl,
          {Widget? errorWidget,
          double? height,
          double? width,
          BoxFit? boxfit,
          Widget Function(BuildContext, String)? placeHolder}) =>
      CachedNetworkImage(
        height: height,
        width: width,
        imageUrl: imageUrl ?? "",
        errorWidget: (context, _, __) => errorWidget ?? const SizedBox(),
        placeholder: (context, url) =>
            placeHolder != null ? placeHolder(context, url) : Container(),
        fadeInCurve: Curves.easeIn,
        fadeInDuration: const Duration(seconds: 2),
        fit: boxfit ?? BoxFit.cover,
      );
}
