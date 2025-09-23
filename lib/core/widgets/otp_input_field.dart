import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom OTP Input Field Widget
class OtpInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final bool enabled;
  final String? errorText;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusColor;

  const OtpInputField({
    super.key,
    this.length = 6,
    required this.onChanged,
    required this.onCompleted,
    this.enabled = true,
    this.errorText,
    this.fillColor,
    this.borderColor,
    this.focusColor,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _values;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );
    _values = List.filled(widget.length, '');
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      // Handle paste operation
      _handlePaste(value, index);
      return;
    }

    setState(() {
      _values[index] = value;
    });

    // Move to next field if current field is filled
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Move to previous field if current field is empty and backspace is pressed
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _updateParent();
  }

  void _handlePaste(String value, int startIndex) {
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    final endIndex = (startIndex + cleanValue.length).clamp(0, widget.length);
    
    for (int i = startIndex; i < endIndex; i++) {
      if (i < widget.length) {
        final char = cleanValue[i - startIndex];
        _controllers[i].text = char;
        _values[i] = char;
      }
    }

    // Focus the last filled field or the last field
    final lastFilledIndex = (endIndex - 1).clamp(0, widget.length - 1);
    _focusNodes[lastFilledIndex].requestFocus();
    
    _updateParent();
  }

  void _updateParent() {
    final otp = _values.join('');
    widget.onChanged(otp);
    
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  void _clear() {
    for (int i = 0; i < widget.length; i++) {
      _controllers[i].clear();
      _values[i] = '';
    }
    _focusNodes[0].requestFocus();
    _updateParent();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            widget.length,
            (index) => _buildDigitField(index),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDigitField(int index) {
    return Container(
      width: 50,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        enabled: widget.enabled,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor ?? 
            Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.borderColor ?? 
                Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.borderColor ?? 
                Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: widget.focusColor ?? 
                Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onChanged: (value) => _onChanged(value, index),
        onTap: () {
          // Select all text when tapped
          _controllers[index].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[index].text.length,
          );
        },
      ),
    );
  }
}
