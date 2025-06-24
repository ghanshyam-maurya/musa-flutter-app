import 'package:musa_app/Utility/packages.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? prefixIconPath;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefix;
  final Widget? suffix;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? textStyle;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final InputCounterWidgetBuilder? buildCounter;
  final InputDecoration? decoration;
  final Color? fillColor;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIconPath,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleObscure,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.readOnly = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.contentPadding,
    this.prefix,
    this.suffix,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.textStyle,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.inputFormatters,
    this.buildCounter,
    this.decoration,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      readOnly: readOnly,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      autovalidateMode: autovalidateMode,
      inputFormatters: inputFormatters,
      buildCounter: buildCounter,
      cursorColor: AppColor.greenDark,
      style: textStyle ??
          AppTextStyle.normalTextStyle(color: AppColor.black, size: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? AppColor.greenTextbg,
        hintText: hintText,
        hintStyle: AppTextStyle.normalTextStyleNew(
          size: 14,
          color: AppColor.hintTextColor,
          fontweight: FontWeight.w600,
        ),

        //  AppTextStyle.normalTextStyle(
        //     color: AppColor.hintTextColor, size: 14),

        prefixIcon: prefixIconPath != null
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SvgPicture.asset(prefixIconPath!),
              )
            : null,
        suffixIcon: suffix ??
            (isPassword
                ? GestureDetector(
                    onTap: onToggleObscure,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      // child: Text(
                      //   obscureText ? 'Show' : 'Hide',
                      //   style: AppTextStyle.semiMediumTextStyle(
                      //     color: AppColor.secondaryTextColor,
                      //     size: 12,
                      //   ),
                      // ),
                      // child: Icon(
                      //   obscureText ? Icons.visibility_off : Icons.visibility,
                      //   color: Colors.grey,
                      // ),
                      child: SvgPicture.asset(
                        obscureText ? Assets.openEye : Assets.closeEye,
                      ),
                    ),
                  )
                : null),
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.hintTextColor),
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.primaryColor, width: 2.0),
            ),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor.hintTextColor, width: 1.0),
            ),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
    );
  }
}
