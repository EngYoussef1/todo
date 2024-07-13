import 'package:flutter/material.dart';

Widget difaulttextformfield({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String labelText,
  required void Function(String) onChangedfunction,
  String? Function(String?)? validation,
  Function()? tapfunction,
  IconData? icon,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: isClickable,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        prefixIcon: Icon(icon),
      ),
      validator: validation,
      onChanged: onChangedfunction,
      onTap: tapfunction,
    );
