import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../utils/validators.dart';

class MyTextInput extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function()? onTap;
  final IconData? icon;
  final IconData? rightIcon;
  final Function()? rightIconOnPressed;
  final String? initialValue;
  final TextEditingController? controller;

  const MyTextInput({
    Key? key,
    required this.hintText,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.icon,
    this.rightIcon,
    this.rightIconOnPressed,
    this.validator,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.controller,
  }) : super(key: key);

  @override
  State<MyTextInput> createState() => _MyTextInputState();
}

class _MyTextInputState extends State<MyTextInput> {
  late FocusNode _textFieldFocus;
  late Function(String?)? validator;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.keyboardType == TextInputType.emailAddress &&
        widget.validator == null) {
      validator = (value) => Validators().email(context, value);
    } else {
      validator = widget.validator;
    }
    _textFieldFocus = FocusNode();

    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _textFieldFocus.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      validator: widget.validator,
      style: TextStyle(
        color: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.inputDecorationTheme.labelStyle!.color),
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
        prefixIcon: widget.icon != null
            ? Icon(
                widget.icon,
                color: context.select((ThemeProvider themeProvider) =>
                    themeProvider.currentTheme.secondaryHeaderColor),
              )
            : null,
        suffixIcon: widget.rightIcon != null
            ? IconButton(
                onPressed: widget.rightIconOnPressed,
                icon: Icon(widget.rightIcon),
                color: context.select((ThemeProvider themeProvider) =>
                    themeProvider.currentTheme.secondaryHeaderColor),
                splashRadius: 0.1,
              )
            : null,
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: context.select((ThemeProvider themeProvider) => themeProvider
              .currentTheme.inputDecorationTheme.floatingLabelStyle!.color),
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.inputDecorationTheme.hintStyle!.color),
          fontWeight: FontWeight.normal,
          fontSize: 16.0,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.inputDecorationTheme.filled),
        fillColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.inputDecorationTheme.fillColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.secondaryHeaderColor),
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.secondaryHeaderColor),
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      focusNode: _textFieldFocus,
      obscuringCharacter: '*',
      onChanged: widget.onChanged,
      onTap: widget.onTap,
    );
  }
}
