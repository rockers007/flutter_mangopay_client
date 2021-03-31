import 'package:flutter/material.dart';
import 'package:flutter_mangopay_client/flutter_mangopay_client.dart';

/// This is a custom input field widget which is used
/// to take input from the user on login page registration page.
///
/// Note: Make sure this field is Wrapped with [Form] widget at any level above this
/// field, otherwise the validations will not work.
class FormInputField extends StatefulWidget {
  /// The Title of the Input field, this should be a short string
  final String title;

  /// The hint text of the input field, this should be a short string
  final String hint;

  /// This is the text value which will be pre-filled in the input area, by default it's empty
  final String initialText;

  /// This Function is the validator function for this input field, if this validation
  /// function returns a non-null String then input field will show  given [errorText]
  /// and will reflect the error with changing the border color
  final FormFieldValidator<String> validator;

  /// This function is the final callback which is used when the field is finally submitted
  /// for validation this will be called when user changes focus to another field for input
  final Function(String value) onSubmit;

  /// This function is the final callback which is used when the form calls
  /// [FormState.save] method which triggers this callback on all field included in the
  /// form.
  ///
  /// This method should provide only validated string value as parameter.
  /// Value provided by this callback is used as final value to be used outside the form
  /// for either login or sign up process.
  final Function(String value) onSaved;

  /// This function is called when the value of input changes.
  ///
  /// This method may not provide validated string value as parameter.
  /// Value provided by this callback must validated before being used directly.
  final Function(String value) onChange;

  /// Defines what type of keyboard should be displayed
  ///
  /// Full alpha-numeric - [TextInputType.text],
  /// Email - [TextInputType.emailAddress],
  /// Simple numeric - [TextInputType.number],
  /// Advanced numeric - [TextInputType.numberWithOptions],
  /// etc.
  final TextInputType inputType;

  /// Defines what action to be done and what icon to display on 'return'/'enter'
  /// button on the keyboard
  ///
  /// Go to next field - [TextInputAction.next],
  /// Search - [TextInputAction.search],
  /// Done - [TextInputAction.done],
  /// etc.
  ///
  final TextInputAction inputAction;

  /// Flag to define if to display the text in the input field or to hide it
  ///
  /// Useful in fields like Password and OTP.
  final bool obscureText;

  /// Define if to validate the string automatically when user leaves the
  /// field, this does not require a manual trigger using [FormState.validate]
  ///
  /// It can be:
  ///  always enabled - [AutovalidateMode.always]
  ///  enabled only on user interaction - [AutovalidateMode.onUserInteraction]
  ///  always disabled - [AutovalidateMode.disabled]
  final AutovalidateMode autoValidateMode;

  /// prefix icon to show before the input text, useful for defining UX
  final Widget prefixIcon;

  /// suffix icon to show after the input text, useful for providing
  /// additional functionality
  final Widget suffixIcon;

  /// Text that will be displayed on error, Can be something which shows the exact
  /// error or provides a hint for preventing such error
  final String errorText;

  /// Color of the hint text
  final Color hintColor;

  /// Color of the label text
  final Color labelColor;

  /// Color of the main text shown inside the form field
  final Color textColor;

  /// Color of the border of the input field
  final Color borderColor;

  /// Color of the filled area inside the form field
  final Color fillColor;

  /// Padding of the content outside portion of the form field
  final EdgeInsets primaryPadding;

  /// Padding of the content inside portion of the form field
  final EdgeInsets secondaryPadding;

  /// Flag value that informs the underlying FormField to show
  /// dense UI or to show normal one
  final bool isDense;

  /// Focus node is used to gain focus to the input field
  final FocusNode focusNode;

  /// Radius value provided in this variable will be used to round up the
  /// corners of the Input field borders
  final double borderRadius;

  /// This function is called when the input field gains focus.
  ///
  /// This method may not provide validated string value as parameter.
  /// Value provided by this callback must validated before being used directly.
  final VoidCallback onTap;

  /// Flag to decide if the input field is allowed to be editable or not
  final bool enabled;

  /// Flag to decide which styling theme should be used for current Input field
  final bool enforceUnderLineBorder;

  /// Flag to decide if the text input is for single line or multiple lines
  final int maxLines;

  const FormInputField({
    Key key,
    this.title = '',
    this.hint = '',
    this.validator,
    this.initialText,
    this.onSubmit,
    this.onSaved,
    this.onChange,
    this.inputType,
    this.inputAction,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.errorText,
    this.hintColor,
    this.labelColor,
    this.textColor,
    this.fillColor,
    this.borderColor,
    this.primaryPadding = const EdgeInsets.only(left: 16, right: 16, top: 8),
    this.secondaryPadding = const EdgeInsets.symmetric(horizontal: 12),
    this.isDense,
    this.onTap,
    this.focusNode,
    this.borderRadius = 7.0,
    this.enabled = true,
    this.enforceUnderLineBorder = true,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _FormInputFieldState createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  TextEditingController _controller;

  @override
  void initState() {
    final initialText = widget.initialText;
    _controller = TextEditingController(
      text: initialText,
    );

    if (isNotEmpty(initialText)) {
      widget.onChange?.call(initialText);
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var fillColor = widget.fillColor;
    var borderColor = widget.borderColor;
    var textColor = widget.textColor;
    var hintColor = widget.hintColor;
    var labelColor = widget.labelColor;

    var maxLines = widget.maxLines;
    return Container(
      child: Padding(
        padding: widget.primaryPadding,
        child: Padding(
          padding: widget.secondaryPadding,
          child: TextFormField(
            enabled: widget.enabled,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              errorText: widget.errorText,
              labelText: widget.title ?? '',
              labelStyle: TextStyle(
                color: labelColor,
                fontSize: 16,
              ),
              hintText: widget.hint ?? '',
              floatingLabelBehavior:
                  maxLines == 1 ? null : FloatingLabelBehavior.never,
              alignLabelWithHint: maxLines != 1,
              hintStyle: TextStyle(
                color: hintColor,
                fontSize: 16,
              ),
              focusColor: fillColor,
              filled: fillColor != null,
              border: buildInputBorder(borderColor),
              focusedBorder: buildInputBorder(borderColor),
              enabledBorder: buildInputBorder(borderColor),
              isDense: widget.isDense ?? false,
            ),
            keyboardType:
                maxLines == 1 ? widget.inputType : TextInputType.multiline,
            maxLines: maxLines,
            textInputAction: widget.inputAction,
            obscureText: widget.obscureText,
            onFieldSubmitted: widget.onSubmit,
            validator: widget.validator,
            controller: _controller,
            autovalidateMode: widget.autoValidateMode,
            cursorColor: textColor,
            onSaved: widget.onSaved,
            onChanged: widget.onChange,
            style: TextStyle(
              color: textColor,
            ),
            onTap: widget.onTap,
            focusNode: widget.focusNode,
          ),
        ),
      ),
    );
  }

  InputBorder buildInputBorder(
    Color borderColor, {
    double width = 1.0,
    double radius = 5.0,
    bool enforceUnderLineBorder,
  }) {
    return widget.enforceUnderLineBorder
        ? buildUnderlineInputBorder(
            width: width, color: borderColor, radius: radius)
        : buildOutlineInputBorder(
            width: width, color: borderColor, radius: radius);
  }

  static UnderlineInputBorder buildUnderlineInputBorder({
    double width = 2.0,
    Color color,
    double radius = 5.0,
  }) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        width: width,
        color: color ?? Colors.grey.shade700,
      ),
    );
  }

  static OutlineInputBorder buildOutlineInputBorder({
    double width = 4.0,
    Color color,
    double radius = 5.0,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: width,
        color: color ?? Colors.grey.shade700,
      ),
      borderRadius: BorderRadius.circular(radius),
    );
  }
}

final FormFieldValidator<String> cardNumberValidator = (String value) {
  if (isEmpty(value)) return 'empty card number';
  var numberLength = (value?.length ?? 0);

  if (numberLength != 16) {
    return "Card number must be 16 digits";
  }
  return null;
};

final FormFieldValidator<String> cardCVVNumberValidator = (String value) {
  if (isEmpty(value)) return 'empty CVV';
  var numberLength = (value?.length ?? 0);

  if (numberLength != 3) {
    return "CVV must be 3 digits";
  }
  return null;
};

final FormFieldValidator<String> notEmptyValidator = (String value) {
  if (isEmpty(value)) {
    return 'Invalid input';
  }
  return null;
};
