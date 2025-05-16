import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormBuilderTextField extends StatefulWidget {
  final String name;
  final String label;
  final TextInputType inputType;
  final bool isPassword;
  final List<String? Function(String?)>? validators;

  const CustomFormBuilderTextField({
    Key? key,
    required this.name,
    required this.label,
    this.inputType = TextInputType.text,
    this.isPassword = false,
    this.validators,
  }) : super(key: key);

  @override
  State<CustomFormBuilderTextField> createState() => _CustomFormBuilderTextFieldState();
}

class _CustomFormBuilderTextFieldState extends State<CustomFormBuilderTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: widget.name,
      obscureText: widget.isPassword && !_isPasswordVisible,
      keyboardType: widget.inputType,
      validator: FormBuilderValidators.compose(widget.validators ?? []),
      decoration: InputDecoration(
        labelText: widget.label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[600],
          ),
        )
            : null,
      ),
    );
  }
}
