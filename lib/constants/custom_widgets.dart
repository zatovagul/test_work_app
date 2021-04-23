import 'package:flutter/material.dart';
import 'package:test_work_app/constants/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const ButtonWidget({Key? key, this.onPressed, this.text:''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        onPressed: onPressed,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.yellow,
            border: Border.all(width: 1, color: Colors.black)
          ),
          child: Center(
            child: Text(text),
          ),
        )
    );
  }
}
