import 'package:flutter/material.dart';
import 'package:musa_app/Resources/app_style.dart';
import 'package:musa_app/Resources/colors.dart';

class TabSelector extends StatefulWidget {
  final String firstTitle;
  final String secondTitle;
  final Function? tabChangeCallback;

  const TabSelector({
    required this.firstTitle,
    required this.secondTitle,
    super.key,required this.tabChangeCallback,
  });

  @override
  _TabSelectorState createState() => _TabSelectorState();
}

class _TabSelectorState extends State<TabSelector> {
  bool isFirstSelected = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFirstSelected = true;
                      });
                      widget.tabChangeCallback!(isFirstSelected?0:1);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: isFirstSelected ? 15 : 14),
                      decoration: BoxDecoration(
                        gradient: isFirstSelected
                            ? LinearGradient(
                                colors: [Color(0xFF9ED899), Color(0xFF66BAB4)],
                              )
                            : null,
                        color: isFirstSelected ? null : AppColor.white,
                        border: isFirstSelected
                            ? null
                            : Border.all(color: AppColor.grey),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      child: Text(
                        widget.firstTitle,
                        textAlign: TextAlign.center,
                        style: isFirstSelected
                            ? AppTextStyle.semiMediumTextStyle(
                                color: AppColor.black, size: 14)
                            : AppTextStyle.semiTextStyle(
                                color: AppColor.black, size: 14),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFirstSelected = false;
                      });
                      widget.tabChangeCallback!(isFirstSelected?0:1);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: isFirstSelected ? 14 : 15),
                      decoration: BoxDecoration(
                        gradient: isFirstSelected
                            ? null
                            : LinearGradient(
                                colors: [Color(0xFF9ED899), Color(0xFF66BAB4)],
                              ),
                        color: isFirstSelected ? Colors.white : null,
                        border: isFirstSelected
                            ? Border.all(color: Colors.grey)
                            : null,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Text(
                        widget.secondTitle,
                        textAlign: TextAlign.center,
                        style: isFirstSelected
                            ? AppTextStyle.semiTextStyle(
                                color: AppColor.black, size: 14)
                            : AppTextStyle.semiMediumTextStyle(
                                color: AppColor.black, size: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
