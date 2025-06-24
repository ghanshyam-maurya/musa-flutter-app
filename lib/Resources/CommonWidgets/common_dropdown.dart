import 'package:musa_app/Utility/packages.dart';

class CommonDropdownWidgets {
  static Widget commonDropdownField<T>({
    Color? bgColor,
    String? hint, // Placeholder text
    required List<T> items, // List of items
    required T? selectedValue, // Currently selected value
    ValueChanged<T?>? onChanged, // Callback for value changes
    bool? isLoading = false,
    String Function(T)? displayItem,
    Widget? prefixIcon,
  }) =>
      Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          color: bgColor ?? Colors.white,
          child: DropdownButtonFormField<T>(
            dropdownColor: Colors.white,
            hint: Text(hint ?? 'Select'),
            value: selectedValue,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(item.toString()),
              );
            }).toList(),
            onChanged: onChanged,
            icon: SizedBox.shrink(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColor.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 2, color: AppColor.green)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.grey),
              ),
              prefixIcon: prefixIcon ??
                  Icon(Icons.grid_view_rounded, color: AppColor.grey),
              suffixIcon: (isLoading != null && isLoading)
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColor.primaryColor),
                      ),
                    )
                  : Icon(Icons.arrow_drop_down,
                      color: AppColor.primaryTextColor),
            ),
          ),
        ),
      );

  static Widget textFieldChat(
          {int? inputMaxLine,
          int? inputMinLine,
          Widget? suffixIcon,
          TextEditingController? inputController,
          String? inputHintText,
          Function(String)? onFieldSubmitted}) =>
      Padding(
        padding: const EdgeInsets.all(5),
        child: TextFormField(
          onFieldSubmitted: onFieldSubmitted,
          textCapitalization: TextCapitalization.sentences,
          maxLines: inputMaxLine,
          minLines: inputMinLine ?? 1,
          controller: inputController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            // suffixIcon: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: suffixIcon,
            // ), // Icon inside the border

            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            hintText: inputHintText,
            hintStyle: AppTextStyle.normalTextStyle1,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white)),
          ),
        ),
      );
}
