import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

class ImageUtil {
  static const defaultMixloImagePath =
      "assets/images/new_banner.png"; //change this when default image is available
  static Widget defaultUserImageWidget({ double size = 24}) {
    return Icon(
      Icons.person,
      color: Colors.grey[600],
      size: size,
    );
  }

  static ImageProvider cachedImageNetworkProviderWidget(String? imageUrl,
      {String defaultImageAsset = defaultMixloImagePath,
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
        errorWidget: (context, _, __) =>
            errorWidget ?? defaultUserImageWidget(),
        placeholder: (context, url) =>
            placeHolder != null ? placeHolder(context, url) : Container(),
        fadeInCurve: Curves.easeIn,
        fadeInDuration: const Duration(seconds: 2),
        fit: boxfit ?? BoxFit.cover,
      );
}
