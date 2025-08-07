// custom_text_field.dart - Enhanced with keyboard navigation
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final VoidCallback? onTap;
  final VoidCallback? onSubmitted;
  final bool enableKeyboardNavigation;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.onTap,
    this.onSubmitted,
    this.enableKeyboardNavigation = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  // Handle keyboard navigation within text field
  void _handleKeyEvent(KeyEvent event) {
    if (!widget.enableKeyboardNavigation) return;

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        // Move to next field
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        } else {
          FocusScope.of(context).nextFocus();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        // Move to previous field
        FocusScope.of(context).previousFocus();
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        // Handle Enter key
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        } else if (widget.onSubmitted != null) {
          widget.onSubmitted!();
        } else {
          FocusScope.of(context).nextFocus();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: _handleKeyEvent,
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onTap: widget.onTap,
            onFieldSubmitted: (_) {
              if (widget.nextFocusNode != null) {
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
              } else if (widget.onSubmitted != null) {
                widget.onSubmitted!();
              }
            },
            textInputAction: widget.nextFocusNode != null
                ? TextInputAction.next
                : TextInputAction.done,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle:
                  const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: const Color(0xFF9CA3AF))
                  : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF9CA3AF),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFFF97316), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
