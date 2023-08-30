import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      this.alignment,
      this.width,
      this.margin,
      this.controller,
      this.focusNode,
      this.autofocus = true,
      this.textStyle,
      this.obscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.hintStyle,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = true,
      this.validator,
      this.vertical,
      this.height,
      this.radius})
      : super(
          key: key,
        );

  final Alignment? alignment;

  final double? width;
  final double? height;

  final double? radius;

  final EdgeInsetsGeometry? margin;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;
  final double? vertical;
  final bool? filled;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: textFormFieldWidget,
          )
        : textFormFieldWidget;
  }

  Widget get textFormFieldWidget => TextFormField(
    controller: controller,
    focusNode: focusNode ?? FocusNode(),
    autofocus: autofocus!,
    obscureText: obscureText!,
    textInputAction: textInputAction,
    keyboardType: textInputType,
    maxLines: maxLines ?? 1,
    decoration: decoration,
    validator: validator,
    style: textStyle,
    
  );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        prefixIcon: prefix,
        hintStyle: hintStyle,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding:
             EdgeInsets.symmetric(vertical: vertical ?? 0, horizontal: 20),
        fillColor: fillColor,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius!),
              // borderSide: BorderSide(
              //   color: theme.colorScheme.onErrorContainer.withOpacity(1),
              //   width: 1,
              // ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius!),
              // borderSide: BorderSide(
              //   color: theme.colorScheme.onErrorContainer.withOpacity(1),
              //   width: 1,
              // ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius!),
              // borderSide: BorderSide(
              //   color: appTheme.lightBlue600,
              //   width: 1,
              // ),
            ),
      );
}
