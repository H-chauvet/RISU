import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/validators.dart';

class MyTextInput extends StatefulWidget {
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
  late Function(String?)? validator;
  late TextEditingController _controller;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();

    if (widget.keyboardType == TextInputType.emailAddress &&
        widget.validator == null) {
      validator = (value) => Validators().email(context, value);
    } else {
      validator = widget.validator;
    }

    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.inputDecorationTheme.fillColor),
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.secondaryHeaderColor),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            isFocused = hasFocus;
          });
        },
        child: TextFormField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          validator: widget.validator,
          style: TextStyle(
            color: context.select((ThemeProvider themeProvider) => themeProvider
                .currentTheme.inputDecorationTheme.labelStyle!.color),
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
                    key: const Key('textinput-button_righticon'),
                    onPressed: widget.rightIconOnPressed,
                    icon: Icon(widget.rightIcon),
                    color: context.select((ThemeProvider themeProvider) =>
                        themeProvider.currentTheme.secondaryHeaderColor),
                    splashRadius: 0.1,
                  )
                : null,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: isFocused || _controller.text.isNotEmpty
                  ? context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor)
                  : Colors.grey,
              fontWeight: isFocused || _controller.text.isNotEmpty
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: 16.0,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.inputDecorationTheme.filled),
            fillColor: context.select((ThemeProvider themeProvider) =>
                themeProvider.currentTheme.inputDecorationTheme.fillColor),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(32.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
          obscuringCharacter: '*',
          onChanged: widget.onChanged,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
