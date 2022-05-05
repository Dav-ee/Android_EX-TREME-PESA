import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/argon_theme.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Input extends StatelessWidget {
  final String placeholder;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final Function onChanged;
  final Function validator;
  final bool autofocus;
  final Color borderColor;



  final requiredValidator =
  RequiredValidator(errorText: 'This field is required');


  Input(
      {required this.placeholder,
        required this.suffixIcon,
        required this.prefixIcon,
        required this.onChanged,
        required this.validator,
        this.autofocus = false,
        this.borderColor = ArgonColors.border,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: ArgonColors.muted,
        autofocus: autofocus,
        validator: requiredValidator,
        style:
        TextStyle(height: 0.85, fontSize: 14.0, color: ArgonColors.initial),
        textAlignVertical: TextAlignVertical(y: 0.6),
        decoration: InputDecoration(
            filled: true,
            fillColor: ArgonColors.white,
            hintStyle: TextStyle(
              color: ArgonColors.muted,
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                    color: borderColor, width: 1.0, style: BorderStyle.solid)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                    color: borderColor, width: 1.0, style: BorderStyle.solid)),
            hintText: placeholder));
  }


}
