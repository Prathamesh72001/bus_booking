import 'package:bus_booking_app/utility/colors.dart';
import 'package:bus_booking_app/view/widgets/common/common_text_widget.dart';
import 'package:bus_booking_app/view/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatefulWidget {
  final bool isEnabled;
  final bool isLoading;
  final Function onTap;
  final String buttonText;
  const CommonButton(
      {super.key,
      this.isEnabled = false,
      this.isLoading = false,
      required this.onTap,
      required this.buttonText});

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> widget.onTap.call(),
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: BrandColors.secondary,
            boxShadow: const [
              BoxShadow(
                  color: BrandColors.shadow, blurRadius: 10, spreadRadius: 10)
            ]),
        child: widget.isLoading
            ? const LoaderWidget()
            : CommonText(
                text: widget.buttonText.toUpperCase(),
                fontWeight: FontWeight.bold,
                color:widget.isEnabled? BrandColors.primary : Colors.grey,
                textAlign: TextAlign.center,
                fontSize: 16,
              ),
      ),
    );
  }
}
