import 'package:flutter/material.dart';
import 'package:nanny_fairy/res/components/colors.dart';

class RoundedCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;

  const RoundedCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = AppColor.oceanColor,
  });

  @override
  _RoundedCheckboxState createState() => _RoundedCheckboxState();
}

class _RoundedCheckboxState extends State<RoundedCheckbox> {
  void _handleTap() {
    widget.onChanged(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: widget.value ? widget.activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.value ? widget.activeColor : Colors.grey,
            width: 0.5,
          ),
        ),
        child: widget.value
            ? const Icon(Icons.check, size: 16, color: AppColor.authCreamColor)
            : null,
      ),
    );
  }
}
