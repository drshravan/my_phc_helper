import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class NeumorphicTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const NeumorphicTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Inset shadow colors (inverse of regular neumorphism)
    final shadowDark = isDark ? Colors.black.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.4);
    final shadowLight = isDark ? Colors.grey.withValues(alpha: 0.1) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            // Inner shadow simulation for "inset" look
            boxShadow: [
              // Bottom Right (Light source top left) -> Dark inner shadow for depth
             /* Note: True inner shadows are hard in Flutter without custom painting. 
                We will use a flat style with a specific border/color to simulate the "pressed" or "input" area look.
                For a true neumorphic input, we usually use a flat container with an outer shadow, OR an inner shadow.
                Let's stick to a clean "outer" pressed look or just flat for simplicity and accessibility.
             */
              BoxShadow(
                color: shadowDark,
                offset: const Offset(2, 2),
                blurRadius: 4,
                spreadRadius: 1,
                // inset: true // Not supported natively in BoxShadow yet without packages
              ),
              BoxShadow(
                color: shadowLight,
                offset: const Offset(-2, -2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
  /* 
             To fix the "inset" look properly without external packages, we can wrap the TextField 
             in a Container that looks "pressed". Since standard shadows are "drop" (outer), 
             we actually want the INVERSE colors for a "pressed" look (Dark TopLeft, Light BottomRight) 
             or just use the standard "elevated" look for the field container.
             
             Let's use a subtle "Elevated" container for the field, similar to the cards, 
             so it looks like a physical object you type onto.
          */
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            readOnly: readOnly,
            onTap: onTap,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.6)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor, // Blend with container
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon: suffixIcon,
              counterText: "", // Hide character counter
            ),
          ),
        ),
      ],
    );
  }
}
