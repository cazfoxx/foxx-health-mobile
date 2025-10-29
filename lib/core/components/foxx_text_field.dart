import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:foxxhealth/features/presentation/theme/app_colors.dart";

class FoxxTextField extends StatelessWidget {
  final TextEditingController? controller;
  final double? height;
  final String? label;
  final String hint;
  final TextInputType keyboardType;
  final Color? fillColor;
  final void Function(String) onChanged;
  final void Function(String)? onSubmitted;
  final String? initialValue;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Color? textColor;
  final Color? onObscureColor;
  final List<TextInputFormatter>? inputFormatter;
  final Widget? suffixIcon;
  final bool? obscureText;
  final Function()? onObscurePressed;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final String? errorText;
  final bool readOnly;
  final Function()? onTap;
  final double? horizontalPadding;
  final TextAlign textAlign;
  final bool showErrorText;
  final bool showErrorBorder;
  final Color? focusBorderColor;
   final Color? borderColor;
  const FoxxTextField(
      {super.key,
      this.controller,
      this.height,
      this.minLines,
      this.label,
      required this.hint,
      this.keyboardType = TextInputType.text,
      this.obscureText,
      required this.onChanged,
      this.onSubmitted,
      this.initialValue,
      this.maxLines = 1,
      this.maxLength,
      this.fillColor,
      this.textColor,
      this.inputFormatter,
      this.suffixIcon,
      this.onObscurePressed,
      this.errorText,
      this.textInputAction,
      this.readOnly = false,
      this.textCapitalization = TextCapitalization.none,
      this.focusNode,
      this.onTap,
      this.horizontalPadding,
      this.showErrorText = true,
      this.showErrorBorder = false,
      this.textAlign = TextAlign.start,
      this.onObscureColor,
      this.focusBorderColor,
      this.borderColor
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
        ],
        SizedBox(
          height: maxLines! > 1 ? null : height ?? 50,
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            obscureText: obscureText ?? false,
            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            onTap: onTap,
            textAlign: textAlign,
            style: TextStyle(color: textColor ?? AppColors.secondaryTxt),
            inputFormatters: inputFormatter,
            buildCounter: (_,
                    {required currentLength, maxLength, required isFocused}) =>
                maxLength != null
                    ? Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "$currentLength/$maxLength",
                          style: const TextStyle(fontSize: 12, height: .5),
                        ))
                    : null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: horizontalPadding ?? 16.0,
                vertical: 8.0,
              ),
              hintText: hint,
              hintStyle:
                  const TextStyle(color: Color(0xffCECECF), fontSize: 14),
              fillColor: fillColor ?? Colors.white,
              filled: true,
              suffixIcon: obscureText != null
                  ? GestureDetector(
                      onTap: onObscurePressed,
                      child: !obscureText!
                          ? Icon(
                              Icons.visibility_off,
                              color: onObscureColor ?? Colors.white,
                              size: 20,
                            )
                          : Icon(
                              Icons.visibility,
                              color: onObscureColor ?? Colors.white,
                              size: 20,
                            ),
                    )
                  : suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide:  const BorderSide(
                  // color: (errorText != null && showErrorBorder) ? AppColors.errorTextColor : Colors.grey,

                  // color:borderColor ?? Colors.white,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:  BorderSide(color:borderColor ??Colors.white, width: 1),
                borderRadius: BorderRadius.circular(14),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide:  BorderSide(
                  color: focusBorderColor ?? Colors.white,
                  // color:
                  //     (errorText != null && showErrorBorder) ? AppColors.errorTextColor : Colors.purpleAccent.shade700,
                  width: 1.0,
                ),
              ),
            ),
            textInputAction: textInputAction,
            onFieldSubmitted: onSubmitted,
            textCapitalization: textCapitalization,
            onChanged: onChanged,
            initialValue: initialValue,
          ),
        ),
        if (errorText != null && showErrorText)
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              errorText!,
              style: const TextStyle(
                // color: AppColors.errorTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
      ],
    );
  }
}
//  InputDecoration(
//         labelText: label,
//         counterText: "",
//         hintText: hintText,
//         filled: true,
//         fillColor: Colors.black.withValues(alpha: .1),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         enabledBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.grey, width: 1),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: borderColor, width: 1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//       )
