import 'package:flutter/material.dart';

class AppInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final bool isSearch;

  const AppInput({super.key, this.controller, this.label, this.hint, this.errorText, this.prefixIcon, this.suffixIcon, this.obscureText = false, this.keyboardType, this.validator, this.onChanged, this.maxLines = 1, this.isSearch = false});
  const AppInput.search({super.key, this.controller, this.label, this.hint, this.errorText, this.suffixIcon, this.keyboardType, this.validator, this.onChanged, this.maxLines = 1}) : obscureText = false, isSearch = true, prefixIcon = const Icon(Icons.search);
  const AppInput.password({super.key, this.controller, this.label, this.hint, this.errorText, this.prefixIcon, this.keyboardType, this.validator, this.onChanged, this.maxLines = 1}) : obscureText = true, isSearch = false, suffixIcon = null;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscured,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText 
          ? IconButton(
              icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscured = !_obscured),
            )
          : widget.suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(widget.isSearch ? 30 : 12)),
        filled: widget.isSearch,
        fillColor: widget.isSearch ? Colors.grey[200] : null,
      ),
    );
  }
}
