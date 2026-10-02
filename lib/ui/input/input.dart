import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? hintText;
  final Color? color;
  final Color? styleTextColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool? enabled;
  final int? maxLength;
  final String? errorText;
  final IconData? prefixIcon;
  final BorderRadius borderRadius;
  final bool obscureText;
  final Widget? suffixIcon;
  final double? width;
  final int? maxLines;
  final double? height;
  final bool autoFocus;
  final Decoration? decoration;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? border;
  final InputBorder? focusedErrorBorder;
  final EdgeInsetsGeometry? padding;

  const InputText({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.color,
    this.styleTextColor,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.enabled,
    this.maxLength,
    this.errorText,
    this.prefixIcon,
    this.borderRadius = const BorderRadius.all(Radius.circular(11)),
    this.obscureText = false,
    this.suffixIcon,
    this.width,
    this.maxLines = 1,
    this.height,
    this.autoFocus = true,
    this.decoration,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: decoration,
      height: height ?? (errorText != null ? 65 : 43),
      width: width,
      child: TextField(
        maxLines: maxLines,
        readOnly: readOnly,
        enabled: enabled,
        maxLength: maxLength,
        autofocus: autoFocus,
        controller: controller,
        onChanged: onChanged,
        cursorHeight: 18,
        cursorWidth: 1,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        style: TextStyle(color: styleTextColor, fontSize: 14),
        cursorErrorColor: Colors.black,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            size: 21,
            color: AppColors.blackColorAlpha120,
          ),
          errorText: errorText,
          errorStyle: TextStyle(
            color: Color(0xFFFF9500),
            fontSize: 12,
            fontWeight: .w600,
          ),
          errorBorder:
              errorBorder ??
              OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: color ?? AppColors.blackColorAlpha55,
                ),
              ),
          focusedErrorBorder:
              focusedErrorBorder ??
              OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: color ?? AppColors.blackColorAlpha55,
                ),
              ),
          counterText: '',
          hintText: hintText,
          hintStyle: TextStyle(
            color: color ?? AppColors.blackColorAlpha55,
            fontSize: 12.5,
          ),
          border: OutlineInputBorder(),
          enabledBorder:
              enabledBorder ??
              OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: color ?? AppColors.blackColorAlpha55,
                ),
              ),
          focusedBorder:
              focusedBorder ??
              OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: AppColors.mainColor),
              ),
          contentPadding: .all(10),
          suffixIcon: suffixIcon,
        ),
        obscureText: obscureText,
      ),
    );
  }
}
