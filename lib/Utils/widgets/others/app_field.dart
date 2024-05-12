import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppFormField extends StatefulWidget {
  final double? height;
  final double? width;
  final bool containerBorderCondition;
  final String texthint;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;
  final double? cursorHeight;
  final TextAlign textAlign;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;

  CustomAppFormField(
      {Key? key,
      this.containerBorderCondition = false,
      required this.texthint,
      required this.controller,
      this.validator,
      this.height,
      this.width,
      this.obscureText = false,
      this.onChanged,
      this.onTap,
      this.onTapOutside,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.cursorHeight,
      this.textAlign = TextAlign.start,
      this.prefix,
      this.suffix,
      this.prefixIcon,
      this.suffixIcon,
      this.prefixIconColor,
      this.suffixIconColor})
      : super(key: key);

  @override
  State<CustomAppFormField> createState() => _CustomAppFormFieldState();
}

class _CustomAppFormFieldState extends State<CustomAppFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: widget.width,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onTapOutside: widget.onTapOutside,
          onFieldSubmitted: widget.onFieldSubmitted,
          cursorHeight: widget.cursorHeight,
          textAlign: widget.textAlign,
          key: widget.key,
          obscureText: widget.obscureText,
          validator: widget.validator,
          controller: widget.controller,
          cursorColor: AppTheme.blackColor,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              prefixIconColor: widget.prefixIconColor,
              suffixIconColor: widget.suffixIconColor,
              prefix: widget.prefix,
              suffix: widget.suffix,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              contentPadding: const EdgeInsets.only(left: 5, bottom: 15),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.blackColor)),
              disabledBorder:
                  const UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: AppTheme.blackColor,
              )),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.blackColor)),
              hintText: "${widget.texthint}",
              hintStyle: TextStyle(color: Color(0xff838182))),
        ));
  }
}

class CustomTextField extends StatefulWidget {
  final controller;
  final hintText;
  final lines;
  CustomTextField({Key? key, this.controller, this.hintText, this.lines})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLines: widget.lines,
      decoration: InputDecoration(
        isDense: true,
        hintText: "${widget.hintText}",
        hintStyle: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
        ),
      ),
    );
  }
}

class AppField extends StatelessWidget {
  final TextEditingController textEditingController;
  final Color? textStyleColor;
  final String? labelText;
  final String? hintText;
  final String? functionValidate;
  final String? parametersValidate;
  final double fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final Color borderSideColor;
  final Color? hintTextColor;
  final IconData? prefixicon;
  final IconData? visibilityIcon;
  final IconData? visibilityOffIcon;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final Color fillColor;
  bool obscureText;
  final FocusNode? focusNode;
  final String? Function(String?)? onSaved;
  final String? initialValue;
  final List<FilteringTextInputFormatter>? inputFormattersList;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool decoration;
  final bool? showCursor;
  final bool autocorrect;
  final IconData? prefixIcon;
  final bool maxLengthEnforced;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final double? HintSize;
  final suffixIcon;
  final padding;

  AppField({
    Key? key,
    this.initialValue,
    this.focusNode,
    this.padding,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLengthEnforced = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.decoration = true,
    this.onSaved,
    this.prefixIcon,
    this.inputFormattersList,
    required this.textEditingController,
    this.textStyleColor,
    this.labelText,
    this.hintText,
    this.functionValidate,
    this.parametersValidate,
    this.fontSize = 15,
    this.fontStyle,
    this.fontWeight,
    this.borderRadius,
    this.borderSide,
    this.prefixicon,
    this.visibilityIcon,
    this.HintSize,
    this.suffixIcon,
    this.visibilityOffIcon,
    this.textInputType,
    this.borderSideColor = Colors.black,
    this.fillColor = Colors.red,
    this.hintTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return TextFormField(
        key: key,
        controller: textEditingController,
        initialValue: initialValue,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        style: TextStyle(color: textStyleColor),
        textDirection: textDirection,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        autofocus: autofocus,
        onSaved: onSaved,
        readOnly: readOnly,
        showCursor: showCursor,
        obscureText: obscureText,
        autocorrect: autocorrect,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        onChanged: onChanged,
        onTap: onTap,
        inputFormatters: inputFormattersList,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: padding,
          counterText: "",
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
              fontSize: textScaleFactor * fontSize, color: hintTextColor),
          fillColor: fillColor,
          isDense: true,
          border: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.zero,
              borderSide: BorderSide(width: 1, color: borderSideColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.zero,
              borderSide: BorderSide(color: borderSideColor, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderSideColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.zero,
              borderSide: BorderSide(color: borderSideColor, width: 1)),
          labelStyle: TextStyle(fontSize: 14, color: textStyleColor),
        ));
  }
}

class CustomAppPasswordfield extends StatefulWidget {
  final double? height;
  final double? width;
  final bool containerBorderCondition;
  final String texthint;
  final errorText;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final double? cursorHeight;
  final TextAlign textAlign;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final Color? cursorColor;
  final hintStyle;
  final style;
  final errorStyle;
  final errorBorder;
  final focusedErrorBorder;

  CustomAppPasswordfield(
      {Key? key,
      this.containerBorderCondition = false,
      required this.texthint,
      required this.controller,
      this.validator,
      this.height,
      this.width,
      this.onChanged,
      this.onTap,
      this.onTapOutside,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.cursorHeight,
      this.textAlign = TextAlign.start,
      this.prefix,
      this.suffix,
      this.prefixIcon,
      this.suffixIcon,
      this.prefixIconColor,
      this.suffixIconColor,
      this.errorText,
      this.hintStyle,
      this.cursorColor,
      this.style,
      this.errorStyle,
      this.errorBorder,
      this.focusedErrorBorder})
      : super(key: key);

  @override
  State<CustomAppPasswordfield> createState() => _CustomAppPasswordfieldState();
}

class _CustomAppPasswordfieldState extends State<CustomAppPasswordfield> {
  bool _obscureText = true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      onFieldSubmitted: widget.onFieldSubmitted,
      cursorHeight: widget.cursorHeight,
      textAlign: widget.textAlign,
      key: widget.key,
      obscureText: _obscureText,
      validator: widget.validator,
      controller: widget.controller,
      cursorColor: widget.cursorColor,
      style: widget.style,
      decoration: InputDecoration(
          prefixIconColor: widget.prefixIconColor,
          suffixIconColor: widget.suffixIconColor,
          prefix: widget.prefix,
          suffix: widget.suffix,
          prefixIcon: widget.prefixIcon,
          contentPadding: const EdgeInsets.only(left: 5),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.blackColor)),
          disabledBorder:
              const UnderlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: AppTheme.blackColor,
          )),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.blackColor)),
          hintText: "${widget.texthint}",
          hintStyle: TextStyle(color: Color(0xff838182)),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppTheme.appColor,
            ),
          )),
    );
  }
}
