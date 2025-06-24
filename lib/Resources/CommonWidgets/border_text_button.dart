import 'package:musa_app/Utility/packages.dart';

class MusaTextButton {
  static Material borderTextButton({
    required void Function()? onPressed,
    required String title,
    Color? borderColor, // Add border color property
    double? borderWidth, // Add border width property
    Color? textcolor,
    double? minWidth,
    double? minHeight, // Height property
    double? borderRadius,
    double? fontSize,
    FontWeight? fontWeight,
  }) =>
      Material(
        elevation: 5.0, // Optional: Add elevation for button shadow
        borderRadius: BorderRadius.circular(10.0),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColor.bgGrey,
            borderRadius: BorderRadius.circular(borderRadius ?? 5),
            border: Border.all(
              color: borderColor ?? Colors.blue, // Default border color (blue)
              width: borderWidth ?? 2.0, // Default border width
            ),
          ),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: minWidth ?? double.maxFinite,
            height: minHeight ?? double.maxFinite,
            // Default height if not provided
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 5),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: textcolor ?? Colors.grey, // Default text color (blue)
                  fontSize: fontSize ?? 10, // Default  font size
                  fontWeight:
                      fontWeight ?? FontWeight.w400, // Default font weight
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
  static Widget commonTextField({
    FocusNode? focusNode,
    int? inputMaxLine,
    Widget? suffixIcon,
    bool? obscureText,
    Widget? prefixIcon,
    TextEditingController? inputController,
    String? inputHintText,
    int? maxLength,
    String? Function(String?)? validator,
    bool readOnly = false,
    Key? key,
    void Function()? onTap,
    void Function(String)? onChanged,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    void Function()? onEditingComplete,
    Color? bgColor,
    void Function(String?)? onSaved,
    List<TextInputFormatter>?
        inputFormatters, // Added parameter for input formatters
  }) =>
      Container(
        color: bgColor ?? AppColor.white,
        child: TextFormField(
          key: key,
          readOnly: readOnly,
          obscureText: obscureText ?? false,
          onTap: onTap,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSaved: onSaved,
          maxLines: inputMaxLine,
          maxLength: maxLength,
          validator: validator,
          controller: inputController,
          keyboardType: keyboardType ?? TextInputType.text,
          textInputAction: textInputAction ?? TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: inputFormatters, // Pass input formatters here
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintText: inputHintText,
            hintStyle: AppTextStyle.normalTextStyle(
                color: AppColor.primaryTextColor, size: 14),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(inputMaxLine == 1 ? 10 : 10),
              borderSide: BorderSide(color: AppColor.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(inputMaxLine == 1 ? 10 : 10),
              borderSide: BorderSide(color: AppColor.primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(inputMaxLine == 1 ? 10 : 10),
              borderSide: BorderSide(color: AppColor.grey),
            ),
          ),
        ),
      );
}
