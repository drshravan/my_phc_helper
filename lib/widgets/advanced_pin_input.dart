import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';

class AdvancedPinInput extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const AdvancedPinInput({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<AdvancedPinInput> createState() => _AdvancedPinInputState();
}

class _AdvancedPinInputState extends State<AdvancedPinInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _nextField(String value, int index) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        String pin = _controllers.map((c) => c.text).join();
        widget.onCompleted(pin);
      }
    }
    widget.onChanged?.call(_controllers.map((c) => c.text).join());
  }
  
  void _prevField(int index) {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final baseColor = isDark ? Colors.grey[800]! : Colors.grey[200]!; // Unused

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 50,
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDark : AppColors.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
               // Neumorphic Inner Shadow (simulated by border or specific shadow stack)
               // For input, standard "inset" look is tricky, so we use "Outset" but distinct
               BoxShadow(
                color: isDark ? Colors.black54 : Colors.grey.shade300,
                offset: const Offset(4, 4),
                blurRadius: 6,
              ),
              BoxShadow(
                color: isDark ? Colors.white10 : Colors.white,
                offset: const Offset(-4, -4),
                blurRadius: 6,
              ),
            ],
            border: Border.all(
               color: _focusNodes[index].hasFocus ? AppColors.primary : Colors.transparent,
               width: 1.5
            )
          ),
          child: RawKeyboardListener(
             focusNode: FocusNode(), // Dummy node to capture raw keys if needed, but TextField handles backspace
             onKey: (event) {
               if (event is RawKeyDownEvent && 
                   event.logicalKey == LogicalKeyboardKey.backspace && 
                   _controllers[index].text.isEmpty && 
                   index > 0) {
                 _prevField(index);
               }
             },
             child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              obscureText: true,
              obscuringCharacter: '●',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87
              ),
              decoration: const InputDecoration(
                counterText: "",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                if (value.isEmpty && index > 0) {
                   _prevField(index);
                } else {
                   _nextField(value, index);
                }
              },
            ),
          ),
        );
      }),
    );
  }
}
