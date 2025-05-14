import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormBuilderTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      obscureText: isPassword,
      keyboardType: inputType,
      validator: FormBuilderValidators.compose(validators ?? []),
      decoration: InputDecoration(
        labelText: label,
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
      ),
    );
  }
}
