import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool isPressed;
  final Color? color;
  final ShapeBorder? shape;
  final BoxShape boxShape;
  final VoidCallback? onTap;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius,
    this.isPressed = false,
    this.color,
    this.shape,
    this.boxShape = BoxShape.rectangle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = color ?? (isDark ? AppColors.surfaceDark : AppColors.surface);
    final shadowLight = isDark ? AppColors.shadowDarkTop : AppColors.shadowLightTop;
    final shadowDark = isDark ? AppColors.shadowDarkBottom : AppColors.shadowLightBottom;

    final double offset = isPressed ? 2 : 4;
    final double blur = isPressed ? 4 : 8;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: boxShape == BoxShape.circle ? null : (borderRadius ?? BorderRadius.circular(16)),
          shape: boxShape,
          boxShadow: isPressed
              ? [] // No shadow for "pressed" state to make it look flat/depressed relative to others
              : [
                  BoxShadow(
                    color: shadowDark,
                    offset: Offset(offset, offset),
                    blurRadius: blur,
                  ),
                  BoxShadow(
                    color: shadowLight,
                    offset: Offset(-offset, -offset),
                    blurRadius: blur,
                  ),
                ],
          gradient: isPressed 
            ? null 
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                  ? [
                      backgroundColor.withValues(alpha: 0.8), // Updated deprecated withOpacity
                      backgroundColor,
                      backgroundColor,
                      backgroundColor.withValues(alpha: 0.9),
                    ]
                  : [
                      backgroundColor.withValues(alpha: 0.6),
                      backgroundColor,
                      backgroundColor,
                      backgroundColor.withValues(alpha: 0.8),
                    ],
                stops: const [0.1, 0.3, 0.6, 1.0],
              ),
        ),
        child: child,
      ),
    );
  }
}

// Extension to adding inset support if needed later, but simple switching is okay for now.
// Note: Flutter's BoxShadow does not support 'inset' directly without external packages like flutter_inset_box_shadow.
// I will use a simple workaround by swapping shadow directions or colors if I don't want to add a package.
// For now, the standard "convex" look is the priority.
