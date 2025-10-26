import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vienna_airport_taxi/core/constants/colors.dart';
import 'package:vienna_airport_taxi/core/constants/text_styles.dart';
import 'package:vienna_airport_taxi/core/utils/phone_input_formatter.dart';

class PhoneInputField extends StatefulWidget {
  final String? value;
  final Function(String) onChanged;
  final String? errorText;
  final String hintText;

  const PhoneInputField({
    super.key,
    this.value,
    required this.onChanged,
    this.errorText,
    this.hintText = 'Telefonnummer',
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late PhoneInputController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Initialize controller with existing value or empty
    if (widget.value != null && widget.value!.isNotEmpty) {
      _controller = PhoneInputController(text: widget.value);
    } else {
      _controller = PhoneInputController(text: ''); // Start empty
    }

    // Listen to focus changes
    _focusNode.addListener(_onFocusChange);

    // Listen to text changes
    _controller.addListener(_onTextChange);
  }

  @override
  void didUpdateWidget(PhoneInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller if value changed from outside
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      if (widget.value != null && widget.value!.isNotEmpty) {
        _controller.text = widget.value!;
      }
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // When focused, show +43 if field is empty
      _controller.initializeWithPrefix();
    } else {
      // When focus is lost, clear if only prefix remains
      if (_controller.isEmpty()) {
        _controller.text = '';
      }
    }
  }

  void _onTextChange() {
    // Only call onChanged if we have more than just the prefix
    String valueToReturn = _controller.isEmpty() ? '' : _controller.text;
    widget.onChanged(valueToReturn);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: widget.errorText != null
                  ? AppColors.error
                  : const Color(0xFFCCCCCC),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              PhoneInputFormatter(),
              LengthLimitingTextInputFormatter(16), // + plus up to 15 digits
            ],
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: AppColors.textLight),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              prefixIcon: Container(
                width: 40,
                height: 48,
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/icons/inputs/phone.svg',
                  width: 18,
                  height: 18,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                maxWidth: 40,
                minHeight: 48,
                maxHeight: 48,
              ),
            ),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              widget.errorText!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }
}
