import 'package:musa_app/Utility/packages.dart';
import 'package:musa_app/Cubit/dashboard/CreateMusa/create_musa_cubit.dart';

class CommonDescriptionFieldWithCounter extends StatefulWidget {
  final TextEditingController controller;

  const CommonDescriptionFieldWithCounter(
      {super.key, required this.controller});

  @override
  State<CommonDescriptionFieldWithCounter> createState() =>
      _DescriptionFieldWithCounterState();
}

class _DescriptionFieldWithCounterState
    extends State<CommonDescriptionFieldWithCounter> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        CommonTextField(
          controller: widget.controller,
          hintText: 'Description',
          //prefixIconPath: 'assets/svgs/edit_icon.svg',
          maxLength: 500,
          maxLines: 5,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          onChanged: (value) {
            context.read<CreateMusaCubit>().updateDescription(value);
          },
          buildCounter: (
            BuildContext context, {
            required int currentLength,
            required bool isFocused,
            required int? maxLength,
          }) {
            return Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 8),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '$currentLength / $maxLength' ' characters',
                  style: TextStyle(
                    color: const Color(0xFF222222).withOpacity(0.4),
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 20 / 12,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
